import 'dart:math' show exp;
import 'package:flutter/material.dart';

// Imports for other screens
import 'dashboard_page.dart';
import 'calendar_page.dart';
import 'plan_page.dart';
import 'settings_page.dart';
import 'log_food_page.dart';

// Imports for widgets
import '../widgets/nav_bars.dart';
import '../widgets/add_page_content.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key}); // Added super.key

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  var selectedIndex = 0;
  var logFoodIndex = -1;
  var prevLogFoodIndex =
      0; // To show previous content while LogFoodPage slides out

  late AnimationController _addPageAnimationController;
  late AnimationController _overdragReturnAnimationController;
  late AnimationController _logFoodPageAnimationController;

  var addPageOpen = false;

  late Tween<Offset> _addPageOffsetTween; // Renamed for clarity
  late Animation<Offset> _linearAddPageSlideAnimation;
  late Animation<Offset> _curvedAddPageSlideAnimation;

  late Animation<Offset> _logFoodPageSlideAnimation;
  late Animation<Offset>
      _linearLogFoodPageSlideAnimation; // For dragging LogFoodPage

  bool _isDraggingAddPage = false;
  bool _isDraggingLogFoodPage = false; // For dragging LogFoodPage

  double _screenHeight = 0.0;
  double _screenWidth = 0.0;
  double _addPageContentHeight = 0.0;

  double _currentVisualUpwardOverdragPixels = 0.0;
  double _cumulativeLinearUpwardOverdragInput = 0.0;

  static const double _dismissedControllerValue = 0.0;
  static const double _defaultOpenControllerValue = 1.0;

  bool _isToggleQueued = false; // For AddPage toggle
  // ignore: unused_field
  bool _isLogFoodToggleQueued =
      false; // For LogFoodPage toggle (if needed for its own animations)

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
          const Duration(milliseconds: 100), // Shortened for less bounce feel
      vsync: this,
    );

    _logFoodPageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 250), // Consistent duration
      vsync: this,
    );

    _addPageOffsetTween = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // For AddPage (from bottom)
      end: Offset.zero,
    );

    _linearAddPageSlideAnimation =
        _addPageOffsetTween.animate(_addPageAnimationController);
    _curvedAddPageSlideAnimation = _addPageOffsetTween.animate(
      CurvedAnimation(
        parent: _addPageAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    final logFoodPageOffsetTween = Tween<Offset>(
      // Specific tween for log food page
      begin: const Offset(1.0, 0.0), // From the right
      end: Offset.zero,
    );
    _logFoodPageSlideAnimation = logFoodPageOffsetTween.animate(CurvedAnimation(
      parent: _logFoodPageAnimationController,
      curve: Curves.easeInOut,
    ));
    _linearLogFoodPageSlideAnimation = logFoodPageOffsetTween
        .animate(_logFoodPageAnimationController); // Linear for drag
  }

  @override
  void dispose() {
    _addPageAnimationController.dispose();
    _overdragReturnAnimationController.dispose();
    _logFoodPageAnimationController.dispose();
    super.dispose();
  }

  void _onLogFoodSelection(int index) {
    if (addPageOpen) {
      // Wait for AddPage to close IF it's open and not already closing
      if (_addPageAnimationController.status != AnimationStatus.reverse &&
          _addPageAnimationController.status != AnimationStatus.dismissed) {
        _toggleAddPageOverlay(
            draggedDown: false,
            onComplete: () {
              _updateAndAnimateLogFoodPage(index);
            });
        return; // Don't proceed further until AddPage is closed
      }
    }
    _updateAndAnimateLogFoodPage(index);
  }

  void _updateAndAnimateLogFoodPage(int index) {
    final bool wasShowingLogFood = logFoodIndex != -1;
    final bool willShowLogFood = index != -1;

    // Update prevLogFoodIndex only if we are navigating to a valid new sub-page or coming from one
    if (logFoodIndex != -1 && index != -1 && logFoodIndex != index) {
      // This logic might be too simple if rapidly switching sub-pages.
      // The current approach of just using index for LogFoodPage content is simpler.
      // prevLogFoodIndex = logFoodIndex; // Keep previous valid index
    } else if (willShowLogFood && !wasShowingLogFood) {
      // If opening from scratch, and if prevLogFoodIndex was -1 (or some default like 0)
      // ensure prevLogFoodIndex is set to a valid default for initial display before slide.
      // For now, prevLogFoodIndex is set at the top if index != -1.
    }

    if (mounted) {
      setState(() {
        if (index != -1) {
          prevLogFoodIndex = logFoodIndex != -1
              ? logFoodIndex
              : index; // Store old or new if opening
        }
        logFoodIndex = index;
      });
    }

    if (willShowLogFood && !wasShowingLogFood) {
      _logFoodPageAnimationController.forward();
    } else if (!willShowLogFood && wasShowingLogFood) {
      _logFoodPageAnimationController.reverse();
    } else if (willShowLogFood &&
        wasShowingLogFood &&
        logFoodIndex != prevLogFoodIndex) {
      // If already showing LogFoodPage but changing the sub-index,
      // usually no slide animation, just content update via setState (already done).
      // You could add a cross-fade or minor animation here if desired.
    }
  }

  void _onNavigatorSelection(int index) {
    if (_addPageAnimationController.value > 0.01 ||
        _logFoodPageAnimationController.value >
            0.01 || // Check LogFoodPage animation
        _isDraggingAddPage ||
        _isDraggingLogFoodPage || // Check LogFoodPage drag
        _currentVisualUpwardOverdragPixels > 0) {
      return;
    }
    setState(() {
      selectedIndex = index;
    });
  }

  void _toggleAddPageOverlay(
      {bool draggedDown = false, VoidCallback? onComplete}) {
    if (_isDraggingAddPage) {
      print("Ignoring AddPage toggle: currently dragging.");
      onComplete?.call();
      return;
    }
    if (_overdragReturnAnimationController.isAnimating) {
      print("Ignoring AddPage toggle: overdrag animation. Queuing.");
      if (!_isToggleQueued) {
        _isToggleQueued = true;
        late AnimationStatusListener statusListener;
        statusListener = (status) {
          if (status == AnimationStatus.completed ||
              status == AnimationStatus.dismissed) {
            _overdragReturnAnimationController
                .removeStatusListener(statusListener);
            _isToggleQueued = false;
            onComplete?.call(); // Call original onComplete
            _toggleAddPageOverlay();
          }
        };
        _overdragReturnAnimationController.addStatusListener(statusListener);
      } else {
        onComplete?.call(); // If already queued, still call original onComplete
      }
      return;
    }
    if (_currentVisualUpwardOverdragPixels > 0) {
      print("Ignoring AddPage toggle: upward overdrag exists.");
      onComplete?.call();
      return;
    }

    if (_addPageAnimationController.isAnimating) {
      print(
          "AddPage animation in progress. Queuing toggle. draggedDown: $draggedDown");
      if (!_isToggleQueued) {
        _isToggleQueued = true;
        late AnimationStatusListener statusListener;
        statusListener = (status) {
          if (status == AnimationStatus.completed ||
              status == AnimationStatus.dismissed) {
            _addPageAnimationController.removeStatusListener(statusListener);
            _isToggleQueued = false;
            print(
                "Previous AddPage animation finished. Re-calling _toggleAddPageOverlay.");
            onComplete?.call(); // Call original onComplete
            _toggleAddPageOverlay();
          }
        };
        _addPageAnimationController.addStatusListener(statusListener);
      } else {
        print("AddPage toggle already queued.");
        onComplete?.call();
      }
      return;
    }

    TickerFuture future;
    if (_addPageAnimationController.status == AnimationStatus.completed) {
      addPageOpen = false;
      future = _addPageAnimationController.reverse();
    } else {
      addPageOpen = true;
      future = _addPageAnimationController.forward();
    }

    // Only attach the callback if it's provided
    if (onComplete != null) {
      future.whenCompleteOrCancel(onComplete);
    }
  }

  double _calculateCurvedOverdragPixels(
      double linearInputPixels, double screenH) {
    if (linearInputPixels <= 0) return 0.0;
    double maxVisualUpwardPixelShift = 0.1 * screenH; // As per your last code
    double k = 0.005; // As per your last code
    return maxVisualUpwardPixelShift * (1.0 - exp(-k * linearInputPixels));
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width; // Initialize _screenWidth
    _addPageContentHeight = _screenHeight * 0.5;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const DashboardPage();
      case 1:
        page = const CalendarPage();
      case 2:
        page = const PlanPage();
      case 3:
        page = const SettingsPage();
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

    return Stack(
      children: [
        AnimatedBuilder(
          animation: _addPageAnimationController,
          builder: (BuildContext context, Widget? child) {
            double dimmingValue =
                _addPageAnimationController.value.clamp(0.0, 1.0);
            int alpha = (dimmingValue * 150).toInt().clamp(0, 255);
            return Stack(children: [
              mainScreenContent,
              if (alpha > 0)
                GestureDetector(
                  onTap: _addPageAnimationController.value > 0.01 &&
                          !_isDraggingAddPage &&
                          !_isDraggingLogFoodPage && // Ensure LogFoodPage isn't being dragged
                          _currentVisualUpwardOverdragPixels == 0
                      ? () => _toggleAddPageOverlay(draggedDown: false)
                      : null,
                  child: Container(color: Color.fromARGB(alpha, 0, 0, 0)),
                )
            ]);
          },
        ),
        GestureDetector(
          // For AddPage
          onVerticalDragStart: (details) {
            _addPageAnimationController.stop();
            _overdragReturnAnimationController.stop();
            _isDraggingAddPage = true;
            setState(
                () {}); // Ensure UI updates if animation choice depends on this
          },
          onVerticalDragUpdate: (details) {
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
                    (_addPageAnimationController.value - valChange)
                        .clamp(0.0, 1.0);
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
              _addPageAnimationController.value =
                  (oldValue - valChange).clamp(0.0, 1.0);
              if ((oldValue - _addPageAnimationController.value).abs() > 0.0001) {
                changed = true;
              }
            }
            if (changed) setState(() {});
          },
          onVerticalDragEnd: (details) {
            if (!_isDraggingAddPage) return;
            _isDraggingAddPage = false;
            // Ensure _isDraggingAddPage is false before any animation starts for correct animation choice
            setState(() {});

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
                  setState(() => _currentVisualUpwardOverdragPixels =
                      snapBackAnimation.value);
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
              double dismissThreshold = _defaultOpenControllerValue -
                  ((_addPageContentHeight / 2.0) / _screenHeight);
              double targetValue =
                  (_addPageAnimationController.value < dismissThreshold)
                      ? 0.0
                      : 1.0;
              _addPageAnimationController.animateTo(targetValue);
              if (targetValue == 0.0) {
                addPageOpen = false; // Update addPageOpen state
              }
              if (mounted) setState(() {});
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
              onLogFoodSelection: _onLogFoodSelection,
            ),
          ),
        ),
        if (logFoodIndex != -1 ||
            _logFoodPageAnimationController.status != AnimationStatus.dismissed)
          GestureDetector(
            // For LogFoodPage Drag
            onHorizontalDragStart: (details) {
              if (_logFoodPageAnimationController.isAnimating) {
                _logFoodPageAnimationController.stop();
              }
              _isDraggingLogFoodPage = true;
              setState(() {});
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
              setState(() {});

              if (currentValue < 0.5) {
                _logFoodPageAnimationController
                    .reverse()
                    .whenCompleteOrCancel(() {
                  if (mounted &&
                      _logFoodPageAnimationController.status ==
                          AnimationStatus.dismissed) {
                    if (logFoodIndex != -1) setState(() => logFoodIndex = -1);
                  }
                });
              } else {
                _logFoodPageAnimationController.forward();
              }
            },
            child: SlideTransition(
              position: _isDraggingLogFoodPage
                  ? _linearLogFoodPageSlideAnimation // Use linear for LogFoodPage drag
                  : _logFoodPageSlideAnimation, // Use curved for LogFoodPage automated
              child: LogFoodPage(
                logFoodIndex: logFoodIndex,
                prevLogFoodIndex: prevLogFoodIndex,
                onLogFoodSelection: _onLogFoodSelection,
              ),
            ),
          ),
      ],
    );
  }
}
