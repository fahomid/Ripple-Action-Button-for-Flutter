# Ripple Action Button Examples

This document provides comprehensive examples and explanations for using the `RippleActionButton` class. Each example demonstrates different use cases, including button states, enabling/disabling the button, and programmatically simulating clicks. Padding options are also illustrated.

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

### Explanation
- The `rippleSplashFactory` property allows you to define a custom ripple effect.
- For example, `InkRipple.splashFactory` or `InkSparkle.splashFactory` (if supported).
- You can customize the splash and highlight colors for a unique appearance.

---

These examples should cover most use cases for the `RippleActionButton`. Customize further based on your requirements!

