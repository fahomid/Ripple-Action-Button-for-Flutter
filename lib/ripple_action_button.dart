import 'dart:async';
import 'package:flutter/material.dart';
import 'logger_stub.dart' if (dart.library.io) 'package:logger/logger.dart';
import 'package:async/async.dart';

/// Enum to manage the button's states.
/// Possible states are:
/// - [idle]: Button is in its default state.
/// - [loading]: Button shows a loading indicator.
/// - [success]: Button indicates a successful action.
/// - [error]: Button indicates an error.
enum ButtonState { idle, loading, success, error }

/// A robust, customizable button widget with a ripple effect and multiple states.
///
/// This button is highly flexible and includes states for idle, loading, success, and error.
/// Customizable appearance, animation, and behavior for each state.
/// Provide custom widgets, durations, and callbacks for each state,
/// Enabling robust and interactive UI experiences.
class RippleActionButton extends StatefulWidget {
  /// Widget to display in the idle state.
  final Widget? idleWidget;

  /// Function to execute when the button is pressed.
  /// Should return a [Future<bool>] to indicate success or failure.
  final Future<bool> Function()? onPressed;

  /// Callback function triggered after the button completes its task.
  /// Provides the current button state as a string (e.g., "loading", "success", "error").
  final Future<void> Function(String status)? onComplete;

  /// Widget to display during the loading state.
  final Widget? loadingWidget;

  /// Widget to display during the success state.
  final Widget? successWidget;

  /// Widget to display during the error state.
  final Widget? errorWidget;

  /// Duration for which the error state is displayed.
  final Duration errorDuration;

  /// Minimum duration for the loading state to persist.
  final Duration loadingDuration;

  /// Duration for which the success state is displayed.
  final Duration successDuration;

  /// Decoration for the button, including background color, border, etc.
  final BoxDecoration? buttonDecoration;

  /// Color of the ripple effect on button press.
  final Color? rippleSplashColor;

  /// Color of the ripple effect on button press.
  final Color? rippleHighlightColor;

  /// Opacity of the ripple effect on button press.
  final double? rippleSplashOpacity;

  /// Opacity of the ripple effect on button press.
  final double? rippleHighlightOpacity;

  /// Ripple splash factory.
  final InteractiveInkFeatureFactory? rippleSplashFactory;

  /// Duration of animations between state transitions.
  final Duration animationDuration;

  /// Animation curve for transitioning to the idle state.
  final Curve idleCurve;

  /// Whether button is enabled or not.
  final bool enabled;

  /// Animation curve for transitioning to the loading state.
  final Curve loadingCurve;

  /// Animation curve for transitioning to the success state.
  final Curve successCurve;

  /// Animation curve for transitioning to the error state.
  final Curve errorCurve;

  /// Whether the keyboard should automatically hide when the button is pressed.
  final bool autoHideKeyboard;

  /// Callback triggered when the button enters the idle state.
  final VoidCallback? onIdle;

  /// Callback triggered when the button enters the loading state.
  final VoidCallback? onLoading;

  /// Callback triggered when the button enters the success state.
  final VoidCallback? onSuccess;

  /// Callback triggered when the button enters the error state.
  final VoidCallback? onError;

  /// Callback triggered when onPressed face exception
  final void Function(Object error, StackTrace stackTrace)? onException;

  /// Callback triggered when the keyboard is hidden.
  final VoidCallback? onKeyboardHidden;

  /// Explicit height for the button.
  final double? explicitHeight;

  /// Explicit width for the button.
  final double? explicitWidth;

  const RippleActionButton({
    super.key,
    this.idleWidget,
    this.onPressed,
    this.onComplete,
    this.loadingWidget = const Padding(
      padding: EdgeInsets.all(12.0),
      child: SizedBox(
        height: 24,
        width: 24,
        child: FittedBox(
          fit: BoxFit.scaleDown, // Scale down only when necessary
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
    ),
    this.successWidget = const Padding(
      padding: EdgeInsets.all(12.0),
      child: SizedBox(
        height: 24,
        width: 24,
        child: FittedBox(
          fit: BoxFit.scaleDown, // Scale down only when necessary
          child: Icon(Icons.check, color: Colors.white),
        ),
      ),
    ),
    this.errorWidget = const Padding(
      padding: EdgeInsets.all(12.0),
      child: SizedBox(
        height: 24,
        width: 24,
        child: FittedBox(
          fit: BoxFit.scaleDown, // Scale down only when necessary
          child: Icon(Icons.error, color: Colors.white),
        ),
      ),
    ),
    this.errorDuration = const Duration(seconds: 1),
    this.loadingDuration = const Duration(milliseconds: 500),
    this.successDuration = const Duration(seconds: 1),
    this.buttonDecoration,
    this.rippleSplashColor = Colors.grey,
    this.rippleHighlightColor = Colors.grey,
    this.rippleSplashFactory,
    this.rippleSplashOpacity = 0.3,
    this.rippleHighlightOpacity = 0.3,
    this.animationDuration = const Duration(milliseconds: 200),
    this.idleCurve = Curves.easeInOut,
    this.loadingCurve = Curves.easeInOut,
    this.successCurve = Curves.easeInOut,
    this.errorCurve = Curves.easeInOut,
    this.autoHideKeyboard = false,
    this.enabled = true,
    this.onIdle,
    this.onLoading,
    this.onSuccess,
    this.onError,
    this.onException,
    this.onKeyboardHidden,
    this.explicitHeight,
    this.explicitWidth,
  });

  @override
  RippleActionButtonState createState() => RippleActionButtonState();
}

class RippleActionButtonState extends State<RippleActionButton> {
  final GlobalKey _idleKey = GlobalKey();
  final logger = Logger();
  CancelableOperation<void>? _ongoingOperation;

  double? _buttonHeight;
  double? _buttonWidth;

  late final ValueNotifier<ButtonState> _currentState;

  String _currentStateAsText = "idle";

  late final Widget _cachedIdleWidget;
  late final Widget _cachedLoadingWidget;
  late final Widget _cachedSuccessWidget;
  late final Widget _cachedErrorWidget;

  @override
  void initState() {
    super.initState();
    _currentState = ValueNotifier(ButtonState.idle);
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureButtonSize());
    _initializeCachedWidgets();
    widget.onIdle?.call();
  }

  void _initializeCachedWidgets() {
    _cachedIdleWidget = widget.idleWidget ?? const SizedBox.shrink();
    _cachedLoadingWidget =
        widget.loadingWidget ?? const CircularProgressIndicator.adaptive();
    _cachedSuccessWidget =
        widget.successWidget ?? const Icon(Icons.check, color: Colors.white);
    _cachedErrorWidget =
        widget.errorWidget ?? const Icon(Icons.error, color: Colors.white);
  }

  void _measureButtonSize() {
    if (widget.explicitHeight != null && widget.explicitWidth != null) {
      setState(() {
        _buttonHeight = widget.explicitHeight;
        _buttonWidth = widget.explicitWidth;
      });
    } else {
      final renderBox =
      _idleKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        setState(() {
          _buttonHeight = renderBox.size.height;
          _buttonWidth = renderBox.size.width;
        });
      }
    }
  }

  Future<void> _handlePress() async {
    // Check if any pending task before continuing
    if (!mounted || !widget.enabled || (_ongoingOperation != null && !_ongoingOperation!.isCompleted) || widget.onPressed == null || _currentState.value != ButtonState.idle) {
      return;
    }

    // Auto-hide keyboard on button press
    if (widget.autoHideKeyboard && mounted && FocusScope.of(context).isFirstFocus) {
      FocusScope.of(context).unfocus();

      // Call on auto-hide keyboard method
      widget.onKeyboardHidden?.call();
      await Future.microtask(() {});
    }

    // Transition to the loading state
    _transitionToState(ButtonState.loading);

    // Delay to show the loading state
    await Future.delayed(widget.loadingDuration);

    // Ensure loading state respects mounting
    if (!mounted) return;

    // Start a cancellable operation
    _ongoingOperation = CancelableOperation.fromFuture(
      Future<void>(() async {
        try {
          bool result = await widget.onPressed?.call() ?? false;

          // Check mount again
          if (!mounted) return;

          if (result) {
            _transitionToState(ButtonState.success);

            // Add the delay to show the success state
            await Future.delayed(widget.successDuration);

            // Mount check again
            if (!mounted) return;
          } else {
            _transitionToState(ButtonState.error);

            // Add the delay to show the error state
            await Future.delayed(widget.errorDuration);

            // Mount check again
            if (!mounted) return;
          }
        } catch (e, stackTrace) {
          // Call the provided onException callback if it exists
          widget.onException?.call(e, stackTrace);

          // Log the error
          logger.e('RippleActionButton error occurred during onPressed',
              error: e, stackTrace: stackTrace);
        } finally {
          // Mount check again
          if (mounted) {
            // Transition back to idle
            _transitionToState(ButtonState.idle);

            // Call onComplete method if callback method provided
            if (widget.onComplete != null) {
              await widget.onComplete?.call(_currentStateAsText);
            }
          }
        }
      }),
      onCancel: () {
        // Transition back to idle state on cancellation
        if (mounted) {
          _transitionToState(ButtonState.idle);
        }
      },
    );

    // Await operation completion or cancellation
    await _ongoingOperation?.valueOrCancellation();
  }

  void _transitionToState(ButtonState state) {
    if (!mounted) return;
    if (state != ButtonState.idle) {
      _currentStateAsText = _getStateAsString(state);
    }

    // Call appropriate callback based on the state
    switch (state) {
      case ButtonState.loading:
        widget.onLoading?.call();
        break;
      case ButtonState.success:
        widget.onSuccess?.call();
        break;
      case ButtonState.error:
        widget.onError?.call();
        break;
      default:
        widget.onIdle?.call();
        break;
    }
    _currentState.value = state;
  }

  @override
  void dispose() {
    // Cancel any ongoing operation
    _ongoingOperation?.cancel();

    // Dispose ValueNotifier and other resources
    _currentState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final decoration = widget.buttonDecoration ??
        BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(8.0),
        );

    // Use theme's color or custom color
    final splashColor = widget.rippleSplashColor ?? theme.splashColor;
    final splashOpacity = widget.rippleSplashOpacity ?? theme.splashColor.a;
    final highlightColor = widget.rippleHighlightColor ?? theme.highlightColor;
    final highlightOpacity = widget.rippleHighlightOpacity ?? theme.highlightColor.a;

    return ValueListenableBuilder<ButtonState>(
      valueListenable: _currentState,
      builder: (context, state, child) {
        final currentWidget = _getWidgetForState(state);

        return Semantics(
          button: true,
          enabled: state == ButtonState.idle,
          label: _getAccessibilityLabel(state),
          child: Opacity(
            opacity: widget.enabled ? 1.0 : 0.5, // Adjust opacity when disabled
            child:  ClipRRect(
              borderRadius: decoration.borderRadius?.resolve(TextDirection.ltr) ?? BorderRadius.circular(8.0),
              child: AnimatedContainer(
                duration: widget.animationDuration,
                height: _buttonHeight,
                width: _buttonWidth,
                decoration: decoration,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedSwitcher(
                      duration: widget.animationDuration,
                      switchInCurve: _getCurveForState(state),
                      switchOutCurve: _getCurveForState(state),
                      child: state == ButtonState.idle
                          ? SizedBox(key: _idleKey, child: currentWidget)
                          : currentWidget,
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashFactory: widget.rippleSplashFactory,
                          splashColor: splashColor.withAlpha((splashOpacity * 255).toInt()),
                          highlightColor: highlightColor.withAlpha((highlightOpacity * 255).toInt()),
                          onTap: widget.enabled ? _handlePress : null,
                          child: Container(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _getWidgetForState(ButtonState state) {
    switch (state) {
      case ButtonState.loading:
        return _cachedLoadingWidget;
      case ButtonState.success:
        return _cachedSuccessWidget;
      case ButtonState.error:
        return _cachedErrorWidget;
      default:
        return _cachedIdleWidget;
    }
  }

  Curve _getCurveForState(ButtonState state) {
    switch (state) {
      case ButtonState.loading:
        return widget.loadingCurve;
      case ButtonState.success:
        return widget.successCurve;
      case ButtonState.error:
        return widget.errorCurve;
      default:
        return widget.idleCurve;
    }
  }

  String _getAccessibilityLabel(ButtonState state) {
    switch (state) {
      case ButtonState.loading:
        return 'Loading';
      case ButtonState.success:
        return 'Success';
      case ButtonState.error:
        return 'Error';
      default:
        return 'Idle';
    }
  }

  String _getStateAsString(ButtonState state) {
    return state.toString().split('.').last;
  }

  /// Simulates a button click programmatically.
  Future<void> simulateClick() async {
    if (!mounted || _currentState.value != ButtonState.idle) return;
    await _handlePress();
  }
}