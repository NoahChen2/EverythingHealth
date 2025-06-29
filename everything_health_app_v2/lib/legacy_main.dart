import 'dart:math' show exp;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Everything Health',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  // <-- Changed to TickerProviderStateMixin for multiple controllers
  var selectedIndex = 0;
  var logFoodIndex = -1;
  var prevLogFoodIndex = 0;
  late AnimationController
      _addPageAnimationController; // For main slide (0.0 to 1.0)
  late AnimationController
      _overdragReturnAnimationController; // For overdrag snap back

  late AnimationController _logFoodPageAnimationController;
  late Animation<Offset> _logFoodPageSlideAnimation;
  var addPageOpen = false;
  bool _isDraggingLogFoodPage = false;

  late Tween<Offset> _offsetTween;
  late Animation<Offset> _linearAddPageSlideAnimation;
  late Animation<Offset> _curvedAddPageSlideAnimation;

  bool _isDraggingAddPage = false;
  double _screenHeight = 0.0;
  double _screenWidth = 0.0;
  double _addPageContentHeight = 0.0;

  // State for upward overdrag
  double _currentVisualUpwardOverdragPixels =
      0.0; // Directly used by Transform.translate
  double _cumulativeLinearUpwardOverdragInput =
      0.0; // Raw linear drag input for the curve

  static const double _dismissedControllerValue = 0.0;
  static const double _defaultOpenControllerValue = 1.0;

  bool _isToggleQueued = false;

  @override
  void initState() {
    super.initState();
    _addPageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      lowerBound: _dismissedControllerValue,
      upperBound: _defaultOpenControllerValue,
    );

    _overdragReturnAnimationController = AnimationController(
      duration:
          const Duration(milliseconds: 100), // Duration for elastic snap back
      vsync: this,
    );
    // Listener for _overdragReturnAnimationController will be added dynamically

    _logFoodPageAnimationController = AnimationController(
      // <-- NEW
      duration: const Duration(milliseconds: 300), // Adjust as needed
      vsync: this,
    );

    _offsetTween = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    );

    _linearAddPageSlideAnimation =
        _offsetTween.animate(_addPageAnimationController);
    _curvedAddPageSlideAnimation = _offsetTween.animate(
      CurvedAnimation(
        parent: _addPageAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _logFoodPageSlideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // From the right
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _logFoodPageAnimationController,
      curve: Curves.easeInOut,
    ));

    Tween<Offset>(
      begin: const Offset(1.0, 0.0), // From the right
      end: Offset.zero,
    ).animate(_logFoodPageAnimationController); // No curve for linear response
  }

  @override
  void dispose() {
    _addPageAnimationController.dispose();
    _overdragReturnAnimationController.dispose();
    _logFoodPageAnimationController.dispose();
    super.dispose();
  }

  void _onLogFoodSelection(int index) {
    if (index != -1) {
      setState(() {
        prevLogFoodIndex = index;
      });
    }
    if (addPageOpen) {
      _toggleAddPageOverlay(draggedDown: false);
    }

    final bool wasShowingLogFood = logFoodIndex != -1;
    final bool willShowLogFood = index != -1;

    if (mounted) {
      // Good practice to check if mounted before setState
      setState(() {
        logFoodIndex = index;
      });
    }
    if (willShowLogFood && !wasShowingLogFood) {
      _logFoodPageAnimationController.forward();
    } else if (!willShowLogFood && wasShowingLogFood) {
      _logFoodPageAnimationController.reverse();
    }

    setState(() {
      logFoodIndex = index;
    });
  }

  void _onNavigatorSelection(int index) {
    if (_addPageAnimationController.value > 0.1 ||
        _isDraggingAddPage ||
        _currentVisualUpwardOverdragPixels > 0) {
      return;
    }
    setState(() {
      selectedIndex = index;
    });
  }

  void _toggleAddPageOverlay({bool draggedDown = false}) {
    // --- Existing early returns for other conditions ---
    if (_isDraggingAddPage) {
      print("Ignoring toggle: currently dragging.");
      return;
    }
    if (_overdragReturnAnimationController.isAnimating) {
      if (!_isToggleQueued) {
        // Only queue if not already waiting for a toggle
        _isToggleQueued = true;

        late AnimationStatusListener
            statusListener; // Use 'late' for non-nullable self-reference
        statusListener = (status) {
          if (status == AnimationStatus.completed ||
              status == AnimationStatus.dismissed) {
            _overdragReturnAnimationController
                .removeStatusListener(statusListener); // Clean up
            _isToggleQueued = false; // Reset the queue flag
            _toggleAddPageOverlay(); // "Recursive" call to perform the queued toggle
          }
        };
        _overdragReturnAnimationController.addStatusListener(statusListener);
      }
      return;
    }

    if (_currentVisualUpwardOverdragPixels > 0) {
      print("Ignoring toggle: current visual upward overdrag pixels > 0.");
      return;
    }

    if (_addPageAnimationController.isAnimating) {
      if (!draggedDown) {
        return;
      }
      if (!_isToggleQueued) {
        // Only queue if not already waiting for a toggle
        _isToggleQueued = true;

        late AnimationStatusListener
            statusListener; // Use 'late' for non-nullable self-reference
        statusListener = (status) {
          if (status == AnimationStatus.completed ||
              status == AnimationStatus.dismissed) {
            _addPageAnimationController
                .removeStatusListener(statusListener); // Clean up
            _isToggleQueued = false; // Reset the queue flag
            _toggleAddPageOverlay(); // "Recursive" call to perform the queued toggle
          }
        };
        _addPageAnimationController.addStatusListener(statusListener);
      }
      return;
    }
    addPageOpen = !addPageOpen;
    if (_addPageAnimationController.status == AnimationStatus.completed) {
      _addPageAnimationController.reverse();
    } else {
      // This handles AnimationStatus.dismissed or if it was somehow stopped mid-animation (AnimationStatus.forward/reverse)
      _addPageAnimationController.forward();
    }
  }

  double _calculateCurvedOverdragPixels(
      double linearInputPixels, double screenH) {
    if (linearInputPixels <= 0) return 0.0;
    // Max visual upward shift: content (50% screen) moves up so its top is at 25% of screen.
    // This is an upward shift of 0.25 * screenH from its default open top.
    double maxVisualUpwardPixelShift = 0.1 * screenH;
    // Curve: L * (1 - exp(-k*x))
    // x = linearInputPixels, L = maxVisualUpwardPixelShift
    // k needs tuning. A smaller k makes it "softer" (takes more drag to reach near limit).
    double k = 0.005; // Adjusted for pixel input. Start tuning from here.
    double curvedPixels =
        maxVisualUpwardPixelShift * (1.0 - exp(-k * linearInputPixels));
    return curvedPixels;
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;
    _addPageContentHeight = _screenHeight * 0.5;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = DashboardPage();
      case 1:
        page = CalendarPage();
      case 2:
        page = PlanPage();
      case 3:
        page = SettingsPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    Widget mainScreenContent = Stack(children: [
      page,
      MyBottomNavigationBar(
        currentIndex: selectedIndex,
        onNavigatorSelection: _onNavigatorSelection,
        addButtonSelector: () => _toggleAddPageOverlay(draggedDown: false),
      )
    ]);

    // The main application stack
    return Stack(
      children: [
        // Layer 1: Main screen content + Dimming for AddPage
        AnimatedBuilder(
          animation: _addPageAnimationController,
          builder: (BuildContext context, Widget? child) {
            double dimmingValue = _addPageAnimationController.value
                .clamp(_dismissedControllerValue, _defaultOpenControllerValue);
            int alpha = (dimmingValue * 150).toInt().clamp(0, 255);
            return Stack(children: [
              mainScreenContent, // Base screen content
              if (alpha > 0)
                GestureDetector(
                  onTap: _addPageAnimationController.value > 0 &&
                          !_isDraggingAddPage &&
                          _currentVisualUpwardOverdragPixels == 0
                      ? () => _toggleAddPageOverlay(
                          draggedDown: false) // Ensure correct params if any
                      : null,
                  child: Container(color: Color.fromARGB(alpha, 0, 0, 0)),
                )
            ]);
          },
        ),

        // Layer 2: AddPage (handles its own overdrag via internal positioning)
        GestureDetector(
          onVerticalDragStart: (details) {
            _addPageAnimationController.stop();
            _overdragReturnAnimationController.stop();
            _isDraggingAddPage = true;
          },
          onVerticalDragUpdate: (details) {
            /* ... same as before ... */
            if (!_isDraggingAddPage) return;
            final double pixelDyDelta = details.delta.dy;
            bool changed = false;
            if (_cumulativeLinearUpwardOverdragInput > 0 ||
                (_addPageAnimationController.value ==
                        _defaultOpenControllerValue &&
                    pixelDyDelta < 0)) {
              _addPageAnimationController.value = _defaultOpenControllerValue;
              _cumulativeLinearUpwardOverdragInput -= pixelDyDelta;
              if (_cumulativeLinearUpwardOverdragInput < 0) {
                double remainingDownwardPixelDelta =
                    -_cumulativeLinearUpwardOverdragInput;
                _cumulativeLinearUpwardOverdragInput = 0;
                double valChange = remainingDownwardPixelDelta / _screenHeight;
                _addPageAnimationController.value =
                    (_addPageAnimationController.value - valChange).clamp(
                        _dismissedControllerValue, _defaultOpenControllerValue);
              }
              _currentVisualUpwardOverdragPixels =
                  _calculateCurvedOverdragPixels(
                      _cumulativeLinearUpwardOverdragInput, _screenHeight);
              changed = true;
            } else {
              if (_cumulativeLinearUpwardOverdragInput != 0 ||
                  _currentVisualUpwardOverdragPixels != 0) {
                _cumulativeLinearUpwardOverdragInput = 0;
                _currentVisualUpwardOverdragPixels = 0;
                changed = true;
              }
              double valChange = pixelDyDelta / _screenHeight;
              double oldValue = _addPageAnimationController.value;
              double newValueRequest = oldValue - valChange;
              _addPageAnimationController.value = newValueRequest.clamp(
                  _dismissedControllerValue, _defaultOpenControllerValue);
              if ((oldValue - _addPageAnimationController.value).abs() >
                  0.0001) {
                changed = true;
              }
            }
            if (changed) setState(() {});
          },
          onVerticalDragEnd: (details) {
            /* ... same as before, BUT remove the _toggleAddPageOverlay(draggedDown: true) call ... */
            if (!_isDraggingAddPage) return;
            _isDraggingAddPage = false;
            if (_cumulativeLinearUpwardOverdragInput > 0.01 &&
                _currentVisualUpwardOverdragPixels > 0.01) {
              final double startOverdragPixels =
                  _currentVisualUpwardOverdragPixels;
              Animation<double> snapBackAnimation =
                  Tween<double>(begin: startOverdragPixels, end: 0.0).animate(
                      CurvedAnimation(
                          parent: _overdragReturnAnimationController,
                          curve: Curves.easeOut));
              void snapBackListener() {
                if (mounted) {
                  setState(() {
                    _currentVisualUpwardOverdragPixels =
                        snapBackAnimation.value;
                  });
                }
              }

              snapBackAnimation.addListener(snapBackListener);
              _overdragReturnAnimationController
                  .forward(from: 0.0)
                  .whenCompleteOrCancel(() {
                _cumulativeLinearUpwardOverdragInput = 0.0;
                _currentVisualUpwardOverdragPixels = 0.0;
                snapBackAnimation.removeListener(snapBackListener);
                if (mounted) setState(() {});
              });
            } else {
              _cumulativeLinearUpwardOverdragInput = 0.0;
              _currentVisualUpwardOverdragPixels = 0.0;
              double dismissThresholdInPixels = _addPageContentHeight / 2.0;
              double controllerValueChangeForDismissal =
                  dismissThresholdInPixels / _screenHeight;
              double dismissTriggerControllerValue =
                  _defaultOpenControllerValue -
                      controllerValueChangeForDismissal;
              double targetMainControllerValue;
              if (_addPageAnimationController.value <
                  dismissTriggerControllerValue) {
                targetMainControllerValue = _dismissedControllerValue;
              } else {
                targetMainControllerValue = _defaultOpenControllerValue;
              }
              _addPageAnimationController.animateTo(targetMainControllerValue);
              // REMOVED: _toggleAddPageOverlay(draggedDown: true); as animateTo handles the state.
              if (mounted) {
                setState(() {});
              }
            }
          },
          child: SlideTransition(
            position:
                _isDraggingAddPage && _cumulativeLinearUpwardOverdragInput <= 0
                    ? _linearAddPageSlideAnimation
                    : _curvedAddPageSlideAnimation,
            child: AddPage(
              backgroundPage: Container(color: Colors.transparent),
              onDismissRequest: () => _toggleAddPageOverlay(draggedDown: false),
              currentVisualUpwardOverdragPixels:
                  _currentVisualUpwardOverdragPixels,
              onLogFoodSelection:
                  _onLogFoodSelection, // Make sure this is passed
            ),
          ),
        ),

        // Layer 3: LogFoodPage, slides in from the right
        // Conditionally build if it's visible or animating out to allow exit animation
        if (logFoodIndex != -1 ||
            _logFoodPageAnimationController.status != AnimationStatus.dismissed)
          GestureDetector(
            onHorizontalDragStart: (details) {
              if (_logFoodPageAnimationController.isAnimating) {
                _logFoodPageAnimationController.stop();
              }
              _isDraggingLogFoodPage = true;
              setState(() {}); // To switch to linear animation if not already
            },
            onHorizontalDragUpdate: (details) {
              if (!_isDraggingLogFoodPage || _screenWidth == 0) return;
              double delta = details.delta.dx / _screenWidth;
              _logFoodPageAnimationController.value -= delta;
              _logFoodPageAnimationController.value =
                  _logFoodPageAnimationController.value.clamp(0.0, 1.0);
            },
            onHorizontalDragEnd: (details) {
              if (!_isDraggingLogFoodPage) return;
              _isDraggingLogFoodPage = false;

              final currentValue = _logFoodPageAnimationController.value;
              // Call setState to ensure SlideTransition switches to curved animation for the snap
              setState(() {});

              if (currentValue < 0.5) {
                // Dismiss if dragged more than halfway to the right
                _logFoodPageAnimationController
                    .reverse()
                    .whenCompleteOrCancel(() {
                  if (mounted &&
                      _logFoodPageAnimationController.status ==
                          AnimationStatus.dismissed) {
                    // Ensure logFoodIndex is updated after dismissal by drag
                    if (logFoodIndex != -1) {
                      // Avoid redundant setState if already -1
                      setState(() {
                        logFoodIndex = -1;
                      });
                    }
                  }
                });
              } else {
                _logFoodPageAnimationController.forward(); // Snap back to open
              }
            },
            child: SlideTransition(
              position: _logFoodPageSlideAnimation,
              child: LogFoodPage(
                logFoodIndex: logFoodIndex,
                prevLogFoodIndex: prevLogFoodIndex,
                onLogFoodSelection: _onLogFoodSelection, // For "Back" button
              ),
            ),
          ),
      ],
    );
  }
}

class MyBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavigatorSelection;
  final Function() addButtonSelector;
  const MyBottomNavigationBar(
      {super.key,
      required this.currentIndex,
      required this.onNavigatorSelection,
      required this.addButtonSelector});
  @override
  Widget build(BuildContext context) {
    double barHeight = 60;
    Color barColor = const Color.fromARGB(255, 0, 36, 72);
    Color plusColor = Colors.pinkAccent;
    Color nonSelectedColor = const Color.fromARGB(255, 117, 115, 119);
    Color selectedColor = Colors.white;
    return Align(
        alignment: Alignment.bottomCenter,
        child: Material(
            color: Color.fromARGB(0, 0, 0, 0),
            child: SizedBox(
              width: double.infinity, // Makes the Container take the full width
              height: barHeight * 2,
              child: LayoutBuilder(builder: (context, constraints) {
                double circleDiameter = constraints.maxWidth / 5;
                return Stack(
                  children: [
                    Transform.translate(
                        offset: Offset(0, barHeight),
                        child: Container(
                            height: barHeight,
                            color: barColor,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  _buildNavItem(
                                    icon: Icons.home,
                                    label: "Dashboard",
                                    colorUsed: currentIndex == 0
                                        ? selectedColor
                                        : nonSelectedColor,
                                    onTap: () => onNavigatorSelection(
                                        0), // Call callback with index 0
                                  ),
                                  _buildNavItem(
                                    icon: Icons.calendar_month,
                                    label: "Calendar",
                                    colorUsed: currentIndex == 1
                                        ? selectedColor
                                        : nonSelectedColor,
                                    onTap: () => onNavigatorSelection(
                                        1), // Call callback with index 0
                                  ),
                                  Expanded(flex: 1, child: SizedBox()),
                                  _buildNavItem(
                                    icon: Icons.playlist_play_rounded,
                                    label: "Plan",
                                    colorUsed: currentIndex == 2
                                        ? selectedColor
                                        : nonSelectedColor,
                                    onTap: () => onNavigatorSelection(
                                        2), // Call callback with index 0
                                  ),
                                  _buildNavItem(
                                    icon: Icons.settings,
                                    label: "Settings",
                                    colorUsed: currentIndex == 3
                                        ? selectedColor
                                        : nonSelectedColor,
                                    onTap: () => onNavigatorSelection(
                                        3), // Call callback with index 0
                                  ),
                                ]))),
                    Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                            height: circleDiameter,
                            width: circleDiameter,
                            child: InkWell(
                                onTap: () => addButtonSelector(),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                child: Stack(children: [
                                  Icon(
                                    Icons.circle,
                                    color: plusColor,
                                    size: circleDiameter,
                                  ),
                                  Align(
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.add,
                                        color: barColor,
                                        size: circleDiameter * 0.75,
                                      ))
                                ]))))
                  ],
                );
              }),
            )));
  }

  // Helper widget to build individual navigation items
  // This makes the main build method cleaner and items consistent
}

Widget _buildNavItem({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
  required Color colorUsed,
}) {
  return Expanded(
      flex: 1,
      child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          // For tap effects
          onTap: onTap,
          child: Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 12.0), // Padding for touch area
              child: Column(
                mainAxisSize: MainAxisSize
                    .min, // So the Column doesn't take up all the Row's height
                children: <Widget>[
                  Icon(icon, color: colorUsed, size: 24),
                  SizedBox(height: 4), // Space between icon and text
                  Text(
                    label,
                    style: TextStyle(fontSize: 10, color: colorUsed),
                  ),
                ],
              ),
            ),
          )));
}

class AddPage extends StatelessWidget {
  final Widget backgroundPage;
  final VoidCallback onDismissRequest;
  final Function(int) onLogFoodSelection;
  final double currentVisualUpwardOverdragPixels;
  const AddPage(
      {super.key,
      required this.backgroundPage,
      required this.onDismissRequest,
      required this.currentVisualUpwardOverdragPixels,
      required this.onLogFoodSelection});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double pageHeight =
          constraints.maxHeight; // This should be the screen height
      double defaultOrangeHeight = pageHeight * 0.5;

      // The upwardOverdragPixels is already curved and represents the desired upward shift
      // of the top edge AND the amount of downward extension.
      double upwardExpansion = currentVisualUpwardOverdragPixels;

      // Calculate the new height of the orange box
      double currentOrangeHeight = defaultOrangeHeight + upwardExpansion;
      // Sanity clamp: height should be positive and not exceed the page height (or a practical limit like 75% if desired, though the curve should handle the visual limit)
      currentOrangeHeight = currentOrangeHeight.clamp(
          0.0, pageHeight * 0.75); // Max 75% effective height
      double menuOptionHeight = 66;
      double menuOptionWidth = menuOptionHeight * 1.5;
      return Stack(children: [
        AbsorbPointer(
          absorbing:
              true, // Prevents any pointer events (taps, hovers) on the backgroundPage
          child: backgroundPage,
        ),
        GestureDetector(
          onTap: () {
            onDismissRequest();
          },
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
                height: currentOrangeHeight,
                width: double.infinity,
                child: Container(
                  color: const Color.fromARGB(255, 255, 153, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 40),
                      Text("Log Food",
                          style: TextStyle(
                            fontSize: 20,
                            color: const Color.fromARGB(255, 255, 255, 255),
                            decoration: TextDecoration.none,
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _menuOptionRectangle(
                              height: menuOptionHeight,
                              width: menuOptionWidth,
                              icon: Icons.search,
                              label: "Search Food",
                              colorUsed: Colors.purple,
                              onTap: () {
                                onLogFoodSelection(0);
                              }),
                          _menuOptionRectangle(
                              height: menuOptionHeight,
                              width: menuOptionWidth,
                              icon: Icons.qr_code_scanner,
                              label: "Scan Barcode",
                              colorUsed: Colors.green,
                              onTap: () {
                                onLogFoodSelection(1);
                              }),
                          _menuOptionRectangle(
                              height: menuOptionHeight,
                              width: menuOptionWidth,
                              icon: Icons.history,
                              label: "History",
                              colorUsed: Colors.deepOrange,
                              onTap: () {
                                onLogFoodSelection(2);
                              }),
                          _menuOptionRectangle(
                              height: menuOptionHeight,
                              width: menuOptionWidth,
                              icon: Icons.favorite,
                              label: "Favorites",
                              colorUsed: Colors.yellowAccent,
                              onTap: () {
                                onLogFoodSelection(3);
                              }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _menuOptionRectangle(
                              height: menuOptionHeight,
                              width: menuOptionWidth,
                              icon: Icons.water_drop,
                              label: "Add something else",
                              colorUsed:
                                  const Color.fromARGB(255, 100, 170, 180),
                              onTap: () {
                                print("Log Something else");
                              }),
                          _menuOptionRectangle(
                              height: menuOptionHeight,
                              width: menuOptionWidth,
                              icon: Icons.door_back_door,
                              label: "Log very long string of text for testing",
                              colorUsed:
                                  const Color.fromARGB(255, 255, 101, 191),
                              onTap: () {
                                print(
                                    "Log Very Long String of text for testing");
                              }),
                        ],
                      )
                    ],
                  ),
                )))
      ]);
    });
  }
}

Widget _menuOptionRectangle({
  required IconData icon,
  required String label,
  required Color colorUsed,
  required double height,
  required double width,
  required VoidCallback onTap,
}) {
  return Container(
      height: height,
      width: width,
      margin: EdgeInsets.all(height * .1),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 32, 70, 101),
        borderRadius: BorderRadius.circular(height * .08),
      ),
      child: Stack(children: [
        Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Icon(icon, color: colorUsed, size: height * .5),
              SizedBox(height: height * .1),
              Text(label,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: height / 6,
                    decoration: TextDecoration.none,
                  )),
            ])),
        Material(
            color: Colors.transparent,
            child: InkWell(
              highlightColor: Colors.black.withValues(alpha: 120),
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              borderRadius: BorderRadius.circular(height * .08),
              onTap: onTap,
            )),
      ]));
}

class LogFoodPage extends StatelessWidget {
  final int prevLogFoodIndex;
  final int logFoodIndex;
  final Function(int) onLogFoodSelection;
  const LogFoodPage(
      {super.key,
      this.logFoodIndex = -1,
      required this.prevLogFoodIndex,
      required this.onLogFoodSelection});
  @override
  Widget build(BuildContext context) {
    Color selectedColor = Colors.white;
    Color nonSelectedColor = const Color.fromARGB(255, 117, 115, 119);
    var navItems = [
      _buildNavItem(
          icon: Icons.arrow_back,
          label: "Back",
          colorUsed: const Color.fromARGB(255, 75, 223, 179),
          onTap: () => onLogFoodSelection(-1)),
      _buildNavItem(
          icon: Icons.search,
          label: "Search Food",
          colorUsed: logFoodIndex == 0 ? selectedColor : nonSelectedColor,
          onTap: () => onLogFoodSelection(0)),
      _buildNavItem(
          icon: Icons.qr_code_scanner,
          label: "Scan Barcode",
          colorUsed: logFoodIndex == 1 ? selectedColor : nonSelectedColor,
          onTap: () => onLogFoodSelection(1)),
      _buildNavItem(
          icon: Icons.history,
          label: "History",
          colorUsed: logFoodIndex == 2 ? selectedColor : nonSelectedColor,
          onTap: () => onLogFoodSelection(2)),
      _buildNavItem(
          icon: Icons.star,
          label: "Favorites",
          colorUsed: logFoodIndex == 3 ? selectedColor : nonSelectedColor,
          onTap: () => onLogFoodSelection(3)),
    ];
    var logFoodPages = [
      Container(color: Colors.amber),
      Container(color: Colors.blueAccent),
      Container(color: Colors.orangeAccent),
      Container(color: Colors.blueGrey),
    ];
    return Stack(children: [
      Container(
        color: Colors.lightGreen,
        child:
            logFoodPages[logFoodIndex == -1 ? prevLogFoodIndex : logFoodIndex],
      ),
      MyTopNavigationBar(
        logFoodIndex: logFoodIndex,
        navItems: navItems,
      ),
    ]);
  }
}

class MyTopNavigationBar extends StatelessWidget {
  final int logFoodIndex;
  final List<Widget> navItems;
  const MyTopNavigationBar(
      {super.key, required this.logFoodIndex, required this.navItems});
  @override
  Widget build(BuildContext context) {
    double barHeight = 60;
    Color barColor = const Color.fromARGB(255, 0, 36, 72);
    return Align(
        alignment: Alignment.topCenter,
        child: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: double.infinity, // Makes the Container take the full width
              height: barHeight,
              child: Container(
                color: barColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: navItems,
                ),
              ),
            )));
  }
}

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Everything Health Dashboard",
                style: TextStyle(
                  fontSize: 20,
                  color: const Color.fromARGB(255, 219, 219, 219),
                  decoration: TextDecoration.none,
                ))
          ],
        )
      ],
    );
  }
}

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Everything Health Calendar", style: TextStyle(fontSize: 20))
          ],
        )
      ],
    );
  }
}

class PlanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Everything Health Plan", style: TextStyle(fontSize: 20))
          ],
        )
      ],
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Everything Health Settings", style: TextStyle(fontSize: 20))
          ],
        )
      ],
    );
  }
}
