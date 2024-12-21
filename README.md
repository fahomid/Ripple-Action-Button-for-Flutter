# RippleActionButton

**RippleActionButton** is a robust and customizable Flutter widget that provides an interactive button with a ripple effect and multiple states: `idle`, `loading`, `success`, and `error`. It is designed to enhance user experiences with flexible customization options, smooth animations, and extensive state-handling capabilities.

## Features
- **Multiple States**: `idle`, `loading`, `success`, `error`.
- **Custom Widgets**: Define unique appearances for each state.
- **Highly Customizable**: Any widget can be used for button content (e.g., text, icons, images, or complex layouts).
- **Smooth Transitions**: Control animations and durations between states.
- **Ripple Effects**: Customize ripple splash and highlight colors, opacity, and duration.
- **Callbacks**: Handle lifecycle events (`onIdle`, `onLoading`, `onSuccess`, `onError`, etc.).
- **Error Handling**: Exception-safe with `onException` callback.
- **Programmatic Interaction**: Simulate clicks with `simulateClick()`.
- **Responsive Design**: Adapts automatically or accepts explicit dimensions.
- **Accessibility Support**: Semantic labels for improved usability.

---

## Installation
Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  ripple_action_button: ^1.0.0
```

Then import it in your Dart file:

```dart
import 'package:ripple_action_button/ripple_action_button.dart';
```

---

## Usage

### 1. Simple Button with Text
```dart
RippleActionButton(
  idleWidget: Text('Click Me'),
  onPressed: () async {
    // Simulate a successful action
    await Future.delayed(Duration(seconds: 2));
    return true;
  },
);
```

### 2. Customization of Button States
Define custom widgets for `idle`, `loading`, `success`, and `error` states:

```dart
RippleActionButton(
  idleWidget: Text('Submit'),
  loadingWidget: CircularProgressIndicator(),
  successWidget: Icon(Icons.check, color: Colors.green),
  errorWidget: Icon(Icons.error, color: Colors.red),
  onPressed: () async {
    // Simulate an action
    await Future.delayed(Duration(seconds: 2));
    return false; // Simulate failure
  },
);
```

### 3. Horizontal Button Layout
Place child widgets horizontally:

```dart
RippleActionButton(
  idleWidget: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.upload),
      SizedBox(width: 8),
      Text('Upload File'),
    ],
  ),
  onPressed: () async {
    await Future.delayed(Duration(seconds: 1));
    return true;
  },
);
```

### 4. Vertical Button Layout
Place child widgets vertically:

```dart
RippleActionButton(
  idleWidget: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.refresh),
      SizedBox(height: 4),
      Text('Refresh'),
    ],
  ),
  onPressed: () async {
    await Future.delayed(Duration(seconds: 1));
    return true;
  },
);
```

### 5. Handling Events
Use lifecycle callbacks to handle button events:

```dart
RippleActionButton(
  idleWidget: Text('Process'),
  onIdle: () => print('Button is idle'),
  onLoading: () => print('Loading...'),
  onSuccess: () => print('Action succeeded'),
  onError: () => print('Action failed'),
  onPressed: () async {
    await Future.delayed(Duration(seconds: 2));
    throw Exception('Simulated error'); // Triggers onError
  },
  onException: (error, stackTrace) {
    print('Exception occurred: $error');
  },
);
```

---

## Configuration and Settings
### General Properties
| **Property**            | **Type**                              | **Default**                     | **Description**                                                                 |
|--------------------------|---------------------------------------|----------------------------------|---------------------------------------------------------------------------------|
| `idleWidget`            | `Widget?`                            | `null`                           | Widget to display in the idle state.                                            |
| `onPressed`             | `Future<bool> Function()?`           | `null`                           | Callback for button press. Returns `true` for success, `false` for error.       |
| `onComplete`            | `Future<void> Function(String)?`     | `null`                           | Callback after the button task completes, providing the state as a string.      |
| `loadingWidget`         | `Widget?`                            | CircularProgressIndicator        | Widget to display during the loading state.                                     |
| `successWidget`         | `Widget?`                            | Icon(Icons.check, color: white)  | Widget to display during the success state.                                     |
| `errorWidget`           | `Widget?`                            | Icon(Icons.error, color: white)  | Widget to display during the error state.                                       |
| `buttonDecoration`      | `BoxDecoration?`                     | Theme-based decoration           | Custom decoration for the button, including background, border, etc.            |

### Durations
| **Property**            | **Type**                              | **Default**                     | **Description**                                                                 |
|--------------------------|---------------------------------------|----------------------------------|---------------------------------------------------------------------------------|
| `errorDuration`         | `Duration`                           | `Duration(seconds: 1)`           | Time to display the error state.                                                |
| `loadingDuration`       | `Duration`                           | `Duration(milliseconds: 500)`    | Minimum time to display the loading state.                                      |
| `successDuration`       | `Duration`                           | `Duration(seconds: 1)`           | Time to display the success state.                                              |

### Ripple Effects
| **Property**            | **Type**                              | **Default**                     | **Description**                                                                 |
|--------------------------|---------------------------------------|----------------------------------|---------------------------------------------------------------------------------|
| `rippleSplashColor`     | `Color?`                             | `Colors.grey`                   | Color of the ripple splash effect.                                              |
| `rippleSplashOpacity`   | `double?`                            | `0.3`                           | Opacity of the ripple splash effect.                                            |
| `rippleHighlightColor`  | `Color?`                             | `Colors.grey`                   | Color of the ripple highlight effect.                                           |
| `rippleHighlightOpacity`| `double?`                            | `0.3`                           | Opacity of the ripple highlight effect.                                         |

### Animation
| **Property**            | **Type**                              | **Default**                     | **Description**                                                                 |
|--------------------------|---------------------------------------|----------------------------------|---------------------------------------------------------------------------------|
| `animationDuration`     | `Duration`                           | `Duration(milliseconds: 200)`    | Time for animations between state transitions.                                   |
| `idleCurve`             | `Curve`                              | `Curves.easeInOut`               | Animation curve for transitioning to the idle state.                            |
| `loadingCurve`          | `Curve`                              | `Curves.easeInOut`               | Animation curve for transitioning to the loading state.                         |
| `successCurve`          | `Curve`                              | `Curves.easeInOut`               | Animation curve for transitioning to the success state.                         |
| `errorCurve`            | `Curve`                              | `Curves.easeInOut`               | Animation curve for transitioning to the error state.                           |

---

---

## Support This Project 💖
If you find this widget useful, please consider supporting its development:

- [PayPal Donation](https://www.paypal.me/fahomid)

Your contributions help maintain and improve this project. Thank you! 🌟


## License
This project is licensed under the [Apache License 2.0](LICENSE).

