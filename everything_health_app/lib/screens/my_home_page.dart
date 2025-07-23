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
      // ignore: unused_field
      _linearLogFoodPageSlideAnimation; // For dragging LogFoodPage

  bool _isDraggingAddPage = false;
  bool _isDraggingLogFoodPage = false; // For dragging LogFoodPage

  static const double _logFoodPageEdgeDragWidth = 40.0;

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

  Function goHome(String status)
  {
    return () {
      print(status);
      setState(() {
        _onLogFoodSelection(-1);
      });
    };
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
          behavior: HitTestBehavior
              .translucent, // Allow gesture to be caught to check position
          onVerticalDragStart: (details) {
            // Calculate current visual bounds of AddPage's main content
            double vSlide = _addPageAnimationController
                .value; // 0 (bottom) to 1 (default open)

            // Top of the AddPage's full-screen container due to SlideTransition
            double addPageContainerTopY = _screenHeight * (1.0 - vSlide);

            // Internal positioning and height of the orange content within AddPage
            double actualOrangeContentHeight = (_addPageContentHeight +
                    _currentVisualUpwardOverdragPixels)
                .clamp(0.0,
                    _screenHeight * 0.75); // Matches AddPage's internal clamp
            double orangeContentTopOffsetInContainer =
                (_screenHeight - _addPageContentHeight) -
                    _currentVisualUpwardOverdragPixels;

            // Final screen coordinates of the orange content
            double orangeContentScreenTopY =
                addPageContainerTopY + orangeContentTopOffsetInContainer;
            Rect addPageVisibleRect = Rect.fromLTWH(0, orangeContentScreenTopY,
                _screenWidth, actualOrangeContentHeight);

            // Check if drag started outside the visible AddPage content
            // Also, if AddPage is fully closed and user tries to drag down, ignore.
            if (!addPageVisibleRect.contains(details.globalPosition) ||
                (vSlide < 0.01)) {
              _isDraggingAddPage = false; // Ensure it's not set
              return; // Ignore the drag
            }

            // If drag is valid, proceed
            _addPageAnimationController.stop();
            _overdragReturnAnimationController.stop();
            _isDraggingAddPage = true;
            setState(() {}); // To switch to linear animation
          },
          onVerticalDragUpdate: (details) {
            if (!_isDraggingAddPage) {
              return; // Process only if drag was initiated correctly
            }
            // ... rest of onVerticalDragUpdate logic remains the same
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
            if (!_isDraggingAddPage) {
              return; // Process only if drag was initiated correctly
            }
            // ... rest of onVerticalDragEnd logic remains the same
            _isDraggingAddPage = false;
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
              if (_addPageAnimationController.value <
                      dismissTriggerControllerValue &&
                  targetMainControllerValue == _dismissedControllerValue) {
                // check if it was actually dismissed
                addPageOpen = false; // Update state if dismissed
              } else if (targetMainControllerValue ==
                  _defaultOpenControllerValue) {
                addPageOpen = true;
              }
              if (mounted) {
                setState(() {});
              }
            }
          },
          child: SlideTransition(
            // ... (SlideTransition setup for AddPage remains the same) ...
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
            onHorizontalDragStart: (details) {
              // --- MODIFICATION START ---
              // Check if the drag started on the left edge of the LogFoodPage.
              // details.localPosition.dx is relative to the GestureDetector's own bounds.
              // When LogFoodPage is fully shown, its left edge corresponds to localPosition.dx = 0.
              if (details.localPosition.dx > _logFoodPageEdgeDragWidth) {
                // If drag starts outside the sensitive left edge area, do nothing for this drag.
                _isDraggingLogFoodPage =
                    false; // Ensure it's false if drag is ignored
                return;
              }
              // --- MODIFICATION END ---

              if (_logFoodPageAnimationController.isAnimating) {
                _logFoodPageAnimationController.stop();
              }
              _isDraggingLogFoodPage = true;
              // Call setState to ensure the SlideTransition uses the linear animation
              // if its choice depends on _isDraggingLogFoodPage.
              if (mounted) {
                setState(() {});
              }
            },
            onHorizontalDragUpdate: (details) {
              if (!_isDraggingLogFoodPage || _screenWidth == 0) {
                return; // Check if drag was initiated
              }

              double delta = details.delta.dx / _screenWidth;
              // Controller value: 0.0 = dismissed (right), 1.0 = shown (Offset.zero)
              // Dragging right (positive delta.dx) should decrease controller.value
              _logFoodPageAnimationController.value -= delta;
              _logFoodPageAnimationController.value =
                  _logFoodPageAnimationController.value.clamp(0.0, 1.0);
            },
            onHorizontalDragEnd: (details) {
              if (!_isDraggingLogFoodPage) {
                return; // Only proceed if this drag was for LogFoodPage
              }
              _isDraggingLogFoodPage = false;

              final currentValue = _logFoodPageAnimationController.value;
              // Call setState to ensure SlideTransition switches to curved animation for the snap
              if (mounted) {
                setState(() {});
              }

              if (currentValue < 0.5) {
                // Dismiss threshold
                _logFoodPageAnimationController
                    .reverse()
                    .whenCompleteOrCancel(() {
                  if (mounted &&
                      _logFoodPageAnimationController.status ==
                          AnimationStatus.dismissed) {
                    if (logFoodIndex != -1) {
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
              position:
                  _isDraggingLogFoodPage // Use linear animation if dragging
                      ? Tween<Offset>(
                              begin: const Offset(1.0, 0.0), end: Offset.zero)
                          .animate(
                              _logFoodPageAnimationController) // Re-create linear if not stored
                      : _logFoodPageSlideAnimation, // Original curved animation
              child: LogFoodPage(
                logFoodIndex: logFoodIndex,
                prevLogFoodIndex: prevLogFoodIndex,
                onLogFoodSelection: _onLogFoodSelection,
                goHome: goHome,
              ),
            ),
          ),
      ],
    );
  }
}
