# RippleActionButton Documentation
![Pub Version](https://img.shields.io/pub/v/ripple_action_button)
[![GitHub Sponsor](https://img.shields.io/badge/Sponsor-GitHub-orange?logo=github)](https://github.com/sponsors/fahomid)
[![PayPal Donation](https://img.shields.io/badge/Donate-PayPal-blue?logo=paypal)](https://www.paypal.me/fahomid)


**RippleActionButton** is a robust and customizable Flutter widget that provides an interactive button with a ripple effect and multiple states: `idle`, `loading`, `success`, and `error`. It is designed to enhance user experiences with flexible customization options, smooth animations, and extensive state-handling capabilities.

## Features
- **Multiple States**: `idle`, `loading`, `success`, `error`.
- **Custom Widgets**: Define unique appearances for each state.
- **Highly Customizable**: Any widget can be used for button content (e.g., text, icons, images, or complex layouts).
- **Smooth Transitions**: Control animations and durations between states.
- **Ripple Effects**: Customize ripple splash and highlight colors, opacity, duration, and ripple effect factory.
- **Callbacks**: Handle lifecycle events (`onIdle`, `onLoading`, `onSuccess`, `onError`, `onKeyboardHidden`, etc.).
- **Error Handling**: Exception-safe with `onException` callback.
- **Programmatic Interaction**: Simulate clicks with `simulateClick()`.
- **Keyboard Handling**: Automatically hide the keyboard with `autoHideKeyboard`.
- **Responsive Design**: Adapts automatically or accepts explicit dimensions.
- **Accessibility Support**: Semantic labels for improved usability.
- **Enable/Disable State**: Control interactivity with the `enabled` property.

---

## Installation
Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  ripple_action_button: ^1.1.0
```

Then import it in your Dart file:

```dart
import 'package:ripple_action_button/ripple_action_button.dart';
```

---

## Usage

### Example Images
![RippleActionButton Demo 1](https://raw.githubusercontent.com/fahomid/Ripple-Action-Button-for-Flutter/master/example/example1.gif)

![RippleActionButton Demo 2](https://raw.githubusercontent.com/fahomid/Ripple-Action-Button-for-Flutter/master/example/example2.gif)

![RippleActionButton Demo 3](https://raw.githubusercontent.com/fahomid/Ripple-Action-Button-for-Flutter/master/example/example3.gif)

![RippleActionButton Demo 4](https://raw.githubusercontent.com/fahomid/Ripple-Action-Button-for-Flutter/master/example/example1.png)

![RippleActionButton Demo 5](https://raw.githubusercontent.com/fahomid/Ripple-Action-Button-for-Flutter/master/example/example2.png)

![RippleActionButton Demo 6](https://raw.githubusercontent.com/fahomid/Ripple-Action-Button-for-Flutter/master/example/example3.png)

![RippleActionButton Demo 7](https://raw.githubusercontent.com/fahomid/Ripple-Action-Button-for-Flutter/master/example/example4.png)

![RippleActionButton Demo 8](https://raw.githubusercontent.com/fahomid/Ripple-Action-Button-for-Flutter/master/example/example5.png)

---

## Basic Idle Button Example

```dart
RippleActionButton(
  idleWidget: Padding(
    padding: EdgeInsets.all(16.0),
    child: Text(
      'Submit',
      style: TextStyle(color: Colors.white, fontSize: 18),
    ),
  ),
  onPressed: () async {
    // Simulate an async operation
    await Future.delayed(Duration(seconds: 2));
    return true; // Return true for success, false for error
  },
)
```

### Default Widgets for States
If you don't specify `loadingWidget`, `successWidget`, or `errorWidget`, the following defaults will be used:
- **Loading:** A circular progress indicator.
- **Success:** A checkmark icon.
- **Error:** An error icon.

### Padding
The padding ensures the content inside the button has sufficient spacing.

---

## Button with Loading, Success, and Error States

```dart
RippleActionButton(
  idleWidget: Padding(
    padding: EdgeInsets.all(16.0),
    child: Text('Start Action', style: TextStyle(color: Colors.white)),
  ),
  loadingWidget: Padding(
    padding: EdgeInsets.all(12.0),
    child: CircularProgressIndicator(color: Colors.white),
  ),
  successWidget: Padding(
    padding: EdgeInsets.all(12.0),
    child: Icon(Icons.check, color: Colors.white),
  ),
  errorWidget: Padding(
    padding: EdgeInsets.all(12.0),
    child: Icon(Icons.error, color: Colors.red),
  ),
  onPressed: () async {
    // Simulate an operation
    await Future.delayed(Duration(seconds: 3));
    return true; // Success
  },
  onComplete: (status) async {
    print('Button finished with status: $status');
  },
)
```

### State Transitions
- **Idle:** Displays the idle widget.
- **Loading:** Shows a loading spinner.
- **Success:** Displays a success icon briefly before returning to idle.
- **Error:** Displays an error icon briefly before returning to idle.

---

## Button with `enabled` Property

```dart
RippleActionButton(
  idleWidget: Padding(
    padding: EdgeInsets.all(16.0),
    child: Text('Disabled Button', style: TextStyle(color: Colors.grey)),
  ),
  enabled: false, // Button is disabled
  onPressed: () async {
    return true;
  },
)
```

### Disabled Button
- Setting `enabled: false` prevents user interaction.
- The button opacity reduces to indicate it is not clickable.

---

## Using `GlobalKey` to Simulate a Click

### Example

```dart
final GlobalKey<RippleActionButtonState> buttonKey = GlobalKey<RippleActionButtonState>();

RippleActionButton(
  key: buttonKey,
  idleWidget: Padding(
    padding: EdgeInsets.all(16.0),
    child: Text('Simulate Click', style: TextStyle(color: Colors.white)),
  ),
  onPressed: () async {
    // Simulate async operation
    await Future.delayed(Duration(seconds: 2));
    return true;
  },
);

// Somewhere else in your code
buttonKey.currentState?.simulateClick();
```

### Explanation
- Use `GlobalKey` to programmatically trigger the button click.
- The `simulateClick` method initiates the `onPressed` logic.

---

## Button with Auto-Hide Keyboard

### Example

```dart
RippleActionButton(
  idleWidget: Padding(
    padding: EdgeInsets.all(16.0),
    child: Text('Submit', style: TextStyle(color: Colors.white)),
  ),
  autoHideKeyboard: true,
  onPressed: () async {
    return true;
  },
)
```

### Note
The `autoHideKeyboard` property only works for **physical button presses**, not programmatic clicks. It hides the keyboard if it is open when the button is pressed.

---

## Button with Loading Widget Customization

```dart
RippleActionButton(
  idleWidget: Padding(
    padding: EdgeInsets.all(16.0),
    child: Text('Upload File', style: TextStyle(color: Colors.white)),
  ),
  loadingWidget: Padding(
    padding: EdgeInsets.all(12.0),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(color: Colors.white),
        SizedBox(width: 8),
        Text('Uploading...', style: TextStyle(color: Colors.white)),
      ],
    ),
  ),
  onPressed: () async {
    await Future.delayed(Duration(seconds: 5));
    return true;
  },
)
```

---

## Button with Success and Error Timings

```dart
RippleActionButton(
  idleWidget: Padding(
    padding: EdgeInsets.all(16.0),
    child: Text('Action', style: TextStyle(color: Colors.white)),
  ),
  successWidget: Padding(
    padding: EdgeInsets.all(12.0),
    child: Icon(Icons.check, color: Colors.green),
  ),
  errorWidget: Padding(
    padding: EdgeInsets.all(12.0),
    child: Icon(Icons.error, color: Colors.red),
  ),
  successDuration: Duration(seconds: 3),
  errorDuration: Duration(seconds: 2),
  onPressed: () async {
    return false; // Simulate error
  },
)
```

---

## Styling the Button

```dart
RippleActionButton(
  idleWidget: Padding(
    padding: EdgeInsets.all(16.0),
    child: Text('Custom Style', style: TextStyle(color: Colors.white)),
  ),
  buttonDecoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(12.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        offset: Offset(0, 4),
        blurRadius: 8.0,
      ),
    ],
  ),
  onPressed: () async {
    return true;
  },
)
```

### Explanation
Customize the button’s appearance with the `buttonDecoration` property, including background color, border radius, and shadow.

---

## Complex Multi-Row and Multi-Column Button Example

### Example

```dart
RippleActionButton(
  idleWidget: Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.upload, color: Colors.white),
            SizedBox(width: 8),
            Text('Upload File', style: TextStyle(color: Colors.white)),
          ],
        ),
        SizedBox(height: 8),
        Text('Tap to upload your files', style: TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    ),
  ),
  loadingWidget: Padding(
    padding: EdgeInsets.all(12.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(color: Colors.white),
        SizedBox(height: 8),
        Text('Uploading...', style: TextStyle(color: Colors.white)),
      ],
    ),
  ),
  successWidget: Padding(
    padding: EdgeInsets.all(12.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle, color: Colors.green, size: 32),
        SizedBox(height: 8),
        Text('Upload Successful!', style: TextStyle(color: Colors.white)),
      ],
    ),
  ),
  errorWidget: Padding(
    padding: EdgeInsets.all(12.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error, color: Colors.red, size: 32),
        SizedBox(height: 8),
        Text('Upload Failed', style: TextStyle(color: Colors.white)),
      ],
    ),
  ),
  onPressed: () async {
    // Simulate a long operation
    await Future.delayed(Duration(seconds: 4));
    return true; // Return false for error
  },
)
```

### Explanation
- **Idle Widget:** Combines a row with an icon and text and an additional text line.
- **Loading Widget:** Includes a progress indicator and a message.
- **Success Widget:** Displays a success icon and message.
- **Error Widget:** Displays an error icon and message.

---

## Custom Ripple Effect Example

### Example

```dart
RippleActionButton(
  idleWidget: Padding(
    padding: EdgeInsets.all(16.0),
    child: Text('Ripple Custom', style: TextStyle(color: Colors.white)),
  ),
  rippleSplashFactory: InkRipple.splashFactory, // Use a custom ripple effect
  rippleSplashColor: Colors.yellow.withOpacity(0.5),
  rippleHighlightColor: Colors.yellow.withOpacity(0.3),
  onPressed: () async {
    await Future.delayed(Duration(seconds: 2));
    return true;
  },
)
```

### Ripple Effects
Customize the ripple effect with properties like:
- `rippleSplashColor`
- `rippleHighlightColor`
- `rippleSplashOpacity`
- `rippleHighlightOpacity`
- `rippleSplashFactory`

### Explanation
- The `rippleSplashFactory` property allows you to define a custom ripple effect.
- For example, `InkRipple.splashFactory` or `InkSparkle.splashFactory` (if supported).
- You can customize the splash and highlight colors for a unique appearance.

---

These examples should cover most use cases for the `RippleActionButton`. Customize further based on your requirements!

## Configuration and Settings

### General Properties
| Property           | Type      | Default    | Description                                     | Note                                                                 |
|--------------------|-----------|------------|-------------------------------------------------|----------------------------------------------------------------------|
| `enabled`          | `bool`    | `true`     | Whether the button is enabled or not.          | Controls the button's usability. Disabling it adjusts opacity and prevents interaction. |
| `explicitHeight`   | `double?` | `null`     | Explicit height for the button.                | Used for fixed-size buttons. Dynamically calculated if not provided. |
| `explicitWidth`    | `double?` | `null`     | Explicit width for the button.                 | Used for fixed-size buttons. Dynamically calculated if not provided. |
| `autoHideKeyboard` | `bool`    | `false`    | Whether the keyboard should automatically hide when the button is pressed. | Hides the keyboard before executing `onPressed` logic. |

### Widget Customization
| Property          | Type        | Default                 | Description                                              | Note                                                                     |
|-------------------|-------------|-------------------------|----------------------------------------------------------|--------------------------------------------------------------------------|
| `idleWidget`      | `Widget?`   | `null`                  | Widget to display in the idle state.                     | Defaults to an empty widget (`SizedBox.shrink`).                        |
| `loadingWidget`   | `Widget?`   | CircularProgressIndicator | Widget to display during the loading state.              | Used in the loading phase. Accepts custom widgets.                      |
| `successWidget`   | `Widget?`   | Success `Icon`          | Widget to display during the success state.              | Shown after a successful action.                                       |
| `errorWidget`     | `Widget?`   | Error `Icon`            | Widget to display during the error state.                | Shown after a failed action.                                           |
| `buttonDecoration`| `BoxDecoration?` | `null`              | Decoration for the button, including background color, border, etc. | If not provided, a default decoration with rounded corners is applied. |

### Animation & Transitions
| Property               | Type      | Default                   | Description                                              | Note                                                                      |
|------------------------|-----------|---------------------------|----------------------------------------------------------|---------------------------------------------------------------------------|
| `animationDuration`    | `Duration`| `200 ms`                  | Duration of animations between state transitions.       | Smoothens visual transitions between states.                              |
| `idleCurve`            | `Curve`   | `Curves.easeInOut`        | Animation curve for transitioning to the idle state.    | Defines how animations behave for idle state transitions.                 |
| `loadingCurve`         | `Curve`   | `Curves.easeInOut`        | Animation curve for transitioning to the loading state. | Defines how animations behave for loading state transitions.              |
| `successCurve`         | `Curve`   | `Curves.easeInOut`        | Animation curve for transitioning to the success state. | Defines how animations behave for success state transitions.              |
| `errorCurve`           | `Curve`   | `Curves.easeInOut`        | Animation curve for transitioning to the error state.   | Defines how animations behave for error state transitions.                |

### State Timing
| Property          | Type      | Default          | Description                                              | Note                                                                     |
|-------------------|-----------|------------------|----------------------------------------------------------|--------------------------------------------------------------------------|
| `loadingDuration` | `Duration`| `500 ms`         | Minimum duration for the loading state to persist.       | Ensures the loading state remains visible for at least this duration.    |
| `successDuration` | `Duration`| `1 second`       | Duration for which the success state is displayed.       | Automatically transitions out of the success state after this duration.  |
| `errorDuration`   | `Duration`| `1 second`       | Duration for which the error state is displayed.         | Automatically transitions out of the error state after this duration.    |

### Callbacks
| Property            | Type        | Default   | Description                                              | Note                                                                     |
|---------------------|-------------|-----------|----------------------------------------------------------|--------------------------------------------------------------------------|
| `onPressed`         | `Future<bool> Function()?` | `null` | Function to execute when the button is pressed. Returns a `Future<bool>` to indicate success or failure. | Main logic is executed here, transitioning the button between states based on result. |
| `onComplete`        | `Future<void> Function(String)?` | `null` | Callback triggered after the button completes its task. Provides the current button state as a string. | Useful for post-action logic, e.g., notifying the user or logging results. |
| `onIdle`            | `VoidCallback?`  | `null`   | Callback triggered when the button enters the idle state. | Invoked at the beginning or after resetting to idle state.              |
| `onLoading`         | `VoidCallback?`  | `null`   | Callback triggered when the button enters the loading state. | Invoked when the button begins the loading phase.                       |
| `onSuccess`         | `VoidCallback?`  | `null`   | Callback triggered when the button enters the success state. | Invoked after the action is completed successfully.                     |
| `onError`           | `VoidCallback?`  | `null`   | Callback triggered when the button enters the error state. | Invoked after the action fails.                                         |
| `onException`       | `void Function(Object, StackTrace)?` | `null` | Callback triggered when `onPressed` encounters an exception. | Handles exceptions gracefully and avoids breaking the button's behavior.|
| `onKeyboardHidden`  | `VoidCallback?`  | `null`   | Callback triggered when the keyboard is hidden.           | Useful for UI updates after hiding the keyboard.                       |

### Ripple Effects
| Property                  | Type                          | Default       | Description                                              | Note                                                                     |
|---------------------------|-------------------------------|---------------|----------------------------------------------------------|--------------------------------------------------------------------------|
| `rippleSplashColor`       | `Color?`                     | `Colors.grey` | Color of the ripple effect on button press.              | Provides a visual ripple effect during interaction.                     |
| `rippleHighlightColor`    | `Color?`                     | `Colors.grey` | Color of the ripple highlight effect on button press.    | Provides a highlighted ripple effect during interaction.                |
| `rippleSplashOpacity`     | `double?`                    | `0.3`         | Opacity of the ripple splash effect on button press.     | Adjusts transparency of the ripple splash.                              |
| `rippleHighlightOpacity`  | `double?`                    | `0.3`         | Opacity of the ripple highlight effect on button press.  | Adjusts transparency of the ripple highlight.                           |
| `rippleSplashFactory`     | `InteractiveInkFeatureFactory?` | `null`       | Ripple splash factory.                                   | Enables customizations for ripple interactions.                         |


## Support This Project 💖
If you find this widget useful, please consider supporting its development:

[![GitHub Sponsor](https://img.shields.io/badge/Sponsor-GitHub-orange?logo=github)](https://github.com/sponsors/fahomid)
[![PayPal Donation](https://img.shields.io/badge/Donate-PayPal-blue?logo=paypal)](https://www.paypal.me/fahomid)

Your contributions help maintain and improve this project. Thank you! 🌟

## Connect with Me
For questions, suggestions, or feedback, feel free to reach out on Twitter: [@fahomid](https://twitter.com/fahomid).

## License
This project is licensed under the [Apache License 2.0](LICENSE).

