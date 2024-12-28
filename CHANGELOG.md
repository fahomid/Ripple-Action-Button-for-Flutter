# Changelog

## 1.1.1 Small changes
- Fixed formatting issues to comply with Dart formatter.
- Resolved static analysis warnings to improve package quality.

## Version 1.1.0 - Enhancements and Bug Fixes

### New Features
- **Enabled Property**:
  - Added `enabled` property to control whether the button is interactive.
  - Adjusts button opacity when disabled for visual feedback.

- **Ripple Customization**:
  - Introduced `rippleSplashFactory` for advanced customization of ripple behavior using `InteractiveInkFeatureFactory`.

### Improvements
- **Press Handling**:
  - Updated `_handlePress` method to respect the new `enabled` property, preventing interaction when the button is disabled.

- **Visual Feedback**:
  - Enhanced `build` method to dynamically adjust button opacity based on `enabled` state.

### Bug Fixes
- Fixed potential edge cases in state transitions ensuring smoother and more predictable animations.

---

## Version 1.0.0 - Initial Release

### Features
- **Button States**:
  - Supports multiple states: `idle`, `loading`, `success`, and `error`.
  - Transitions between states with customizable animations and durations.

- **Customization**:
  - Define custom widgets for each state.
  - Configurable ripple effects, including color, opacity, and splash settings.
  - Customizable button dimensions, decorations, and animation curves.

- **Callbacks**:
  - Includes lifecycle callbacks for each state: `onIdle`, `onLoading`, `onSuccess`, and `onError`.
  - Provides `onPressed` to execute async tasks with success/error feedback.
  - `onComplete` to notify when the button task finishes, including status.

- **Error Handling**:
  - Graceful exception handling with `onException` callback.

- **Responsive Design**:
  - Automatically adapts button size or allows explicit width/height settings.
  - Auto-hides keyboard upon interaction if enabled.

- **Accessibility**:
  - Includes semantic labels for better accessibility support.

- **Utilities**:
  - Programmatically simulate button clicks using `simulateClick()`. 
