import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripple_action_button/ripple_action_button.dart';
import 'dart:async';

void main() {
  group('RippleActionButton Tests', () {
    testWidgets('Should render idle state by default', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RippleActionButton(
              idleWidget: Text('Idle'),
              onPressed: () async {
                return true; // Return a valid Future<bool>
              },
            ),
          ),
        ),
      );

      expect(find.text('Idle'), findsOneWidget);
    });

    testWidgets('Should transition to loading state when pressed',
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: RippleActionButton(
                idleWidget: Text('Idle'),
                onPressed: () async {
                  await Future.delayed(Duration(milliseconds: 500));
                  return true; // Return a valid Future<bool>
                },
                loadingWidget: Text('Loading...'),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle(); // Ensure layout is finalized

        // Attempt to tap the interactive parent (InkWell or equivalent)
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle(); // Wait for loading state

        // Verify state transition
        expect(find.text('Loading...'), findsOneWidget);
      });
    });

    testWidgets('Should transition to success state and reset to idle',
        (WidgetTester tester) async {
      // Variables to track state transitions
      bool onSuccessCalled = false;
      bool onIdleCalled = false;

      // Create a mock onPressed function
      Future<bool> mockOnPressed() async {
        await Future.delayed(
            const Duration(milliseconds: 300)); // Simulate delay
        return true; // Indicate success
      }

      // Create a mock onComplete callback
      Future<void> mockOnComplete(String status) async {
        expect(status, equals('success'));
      }

      // Build the RippleActionButton widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: RippleActionButton(
                idleWidget: const Text('Tap me'),
                onPressed: mockOnPressed,
                onComplete: mockOnComplete,
                onSuccess: () => onSuccessCalled = true,
                onIdle: () => onIdleCalled = true,
              ),
            ),
          ),
        ),
      );

      // Ensure the initial state is idle
      expect(find.text('Tap me'), findsOneWidget);
      expect(onIdleCalled, isTrue);

      // Simulate button press
      onIdleCalled = false; // Reset flag for verification
      await tester.tap(find.byType(RippleActionButton));
      await tester.pump(); // Trigger animations and state changes

      // Verify button transitions to loading state
      await tester
          .pump(const Duration(milliseconds: 300)); // Allow async tasks to run
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Advance time to simulate async operation completion
      await tester.pump(const Duration(milliseconds: 800));

      // Verify button transitions to success state
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(onSuccessCalled, isTrue);

      // Wait for the success state duration and transition to idle
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.byIcon(Icons.check), findsNothing);
      expect(find.text('Tap me'), findsOneWidget);
      expect(onIdleCalled, isTrue);
    });

    testWidgets('Should transition to error state and reset to idle',
        (WidgetTester tester) async {
      // Variables to track state transitions
      bool onErrorCalled = false;
      bool onIdleCalled = false;

      // Create a mock onPressed function
      Future<bool> mockOnPressed() async {
        await Future.delayed(
            const Duration(milliseconds: 300)); // Simulate delay
        return false; // Indicate success
      }

      // Create a mock onComplete callback
      Future<void> mockOnComplete(String status) async {
        expect(status, equals('error'));
      }

      // Build the RippleActionButton widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: RippleActionButton(
                idleWidget: const Text('Tap me'),
                onPressed: mockOnPressed,
                onComplete: mockOnComplete,
                onError: () => onErrorCalled = true,
                onIdle: () => onIdleCalled = true,
              ),
            ),
          ),
        ),
      );

      // Ensure the initial state is idle
      expect(find.text('Tap me'), findsOneWidget);
      expect(onIdleCalled, isTrue);

      // Simulate button press
      onIdleCalled = false; // Reset flag for verification
      await tester.tap(find.byType(RippleActionButton));
      await tester.pump(); // Trigger animations and state changes

      // Verify button transitions to loading state
      await tester
          .pump(const Duration(milliseconds: 300)); // Allow async tasks to run
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Advance time to simulate async operation completion
      await tester.pump(const Duration(milliseconds: 800));

      // Verify button transitions to error state
      expect(find.byIcon(Icons.error), findsOneWidget);
      expect(onErrorCalled, isTrue);

      // Wait for the success state duration and transition to idle
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.byIcon(Icons.error), findsNothing);
      expect(find.text('Tap me'), findsOneWidget);
      expect(onIdleCalled, isTrue);
    });

    testWidgets('Should call onComplete after completion', (tester) async {
      String? callbackStatus;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RippleActionButton(
              idleWidget: Text('Idle'),
              onPressed: () async {
                await Future.delayed(Duration(milliseconds: 500));
                return true; // Simulate success
              },
              onComplete: (status) async {
                callbackStatus = status;
              },
            ),
          ),
        ),
      );

      // Ensure the button is in the idle state
      expect(find.text('Idle'), findsOneWidget);

      // Simulate tap and trigger state transitions
      await tester.tap(find.byType(InkWell));
      await tester.pump(); // Trigger onPressed
      await tester.pump(Duration(milliseconds: 500)); // Wait for loading state
      await tester.pump(Duration(milliseconds: 500)); // Wait for success state

      // Wait for auto-reset and onComplete callback
      await tester.pump(Duration(seconds: 1));
      await tester.pumpAndSettle(); // Ensure all async code is resolved

      // Check if callbackStatus is updated
      expect(callbackStatus, equals('success'),
          reason: 'onComplete should set callbackStatus to success');
    });

    testWidgets('Should test callbacks', (WidgetTester tester) async {
      // Callback trackers
      bool onIdleCalled = false;
      bool onLoadingCalled = false;
      bool onSuccessCalled = false;
      bool onKeyboardHiddenCalled = false;

      // Mock functions
      Future<bool> mockOnPressed() async {
        await Future.delayed(
            const Duration(milliseconds: 500)); // Simulate async task
        return true; // Simulate success
      }

      Future<void> mockOnComplete(String status) async {
        // Do nothing, just to fulfill the callback
      }

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                height: 60,
                child: RippleActionButton(
                  idleWidget: const Text('Idle'),
                  successWidget: const Text('Success'),
                  errorWidget: const Text('Error'),
                  onPressed: mockOnPressed,
                  onComplete: mockOnComplete,
                  autoHideKeyboard: true,
                  onIdle: () => onIdleCalled = true,
                  onLoading: () => onLoadingCalled = true,
                  onSuccess: () => onSuccessCalled = true,
                  onKeyboardHidden: () => onKeyboardHiddenCalled = true,
                ),
              ),
            ),
          ),
        ),
      );

      // Allow animations to settle
      await tester.pumpAndSettle();

      // Verify onIdle callback
      expect(onIdleCalled, isTrue);

      // Simulate button tap
      final center = tester.getCenter(find.text('Idle'));
      await tester.tapAt(center);
      await tester.pump(); // Start animations

      // Verify onLoading callback
      await tester
          .pump(const Duration(milliseconds: 500)); // Match loading duration
      expect(onLoadingCalled, isTrue);

      // Wait for success state and verify onSuccess callback
      await tester.pump(const Duration(seconds: 1));
      expect(onSuccessCalled, isTrue);

      // Wait for auto-reset and verify onIdle callback again
      await tester.pump(const Duration(seconds: 2));
      expect(onIdleCalled, isTrue);

      // Verify onKeyboardHidden callback
      expect(onKeyboardHiddenCalled, isTrue);
    });

    testWidgets(
        'Should set button size based on explicitHeight and explicitWidth',
        (WidgetTester tester) async {
      // Arrange: Set explicit width and height for the button
      const double explicitHeight = 60.0;
      const double explicitWidth = 200.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RippleActionButton(
              explicitHeight: explicitHeight,
              explicitWidth: explicitWidth,
              idleWidget: Text('Idle'),
              onPressed: () async {
                return true; // Simulate success
              },
            ),
          ),
        ),
      );

      // Act: Rebuild the widget and find the RippleActionButton
      await tester.pumpAndSettle();

      final buttonFinder = find.byType(RippleActionButton);
      final buttonWidget = tester.widget<RippleActionButton>(buttonFinder);

      // Assert: Check that the button has the specified dimensions
      expect(buttonWidget.explicitHeight, explicitHeight);
      expect(buttonWidget.explicitWidth, explicitWidth);

      // Verify the RenderBox size matches the explicit dimensions
      final renderBox = tester.renderObject<RenderBox>(buttonFinder);
      expect(renderBox.size.height, equals(explicitHeight));
      expect(renderBox.size.width, equals(explicitWidth));
    });

    testWidgets(
        'Should fallback to default size when explicitHeight and explicitWidth are not provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RippleActionButton(
              idleWidget: Text('Idle'),
              onPressed: () async {
                return true; // Simulate success
              },
            ),
          ),
        ),
      );

      // Act: Rebuild the widget and find the RippleActionButton
      await tester.pumpAndSettle();

      final buttonFinder = find.byType(RippleActionButton);
      final renderBox = tester.renderObject<RenderBox>(buttonFinder);

      // Assert: Verify that the size is not explicitly set but defaults to intrinsic dimensions
      expect(renderBox.size.height, greaterThan(0.0));
      expect(renderBox.size.width, greaterThan(0.0));
    });

    testWidgets('Should handles exception and stays in loading state',
        (WidgetTester tester) async {
      final onExceptionCompleter = Completer<void>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RippleActionButton(
              idleWidget: const Text('Tap Me'),
              onPressed: () async {
                throw Exception('Simulated Error');
              },
              onException: (error, stackTrace) {
                debugPrint('Exception caught: $error');
                onExceptionCompleter.complete();
              },
            ),
          ),
        ),
      );

      // Verify the button starts in idle state
      expect(find.text('Tap Me'), findsOneWidget);

      // Tap the button to trigger onPressed
      await tester.tap(find.byType(RippleActionButton));
      await tester.pump(); // Begin animation
      await tester.pump(const Duration(
          milliseconds: 500)); // Wait for loading state transition

      // Verify the button is in loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for exception handling
      await onExceptionCompleter.future;

      // Verify the button stays in loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'Should not trigger onPressed when button is not in idle state or onPressed is null',
        (WidgetTester tester) async {
      bool onPressedCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RippleActionButton(
              idleWidget: Text('Idle'),
              loadingWidget: Text('Loading...'),
              onPressed: null, // Simulate no callback being provided
            ),
          ),
        ),
      );

      // Verify the initial idle state
      expect(find.text('Idle'), findsOneWidget);

      // Simulate a tap on the button
      await tester.tap(find.byType(RippleActionButton));
      await tester.pump(); // Start animations

      // Verify no state change occurred since onPressed is null
      expect(find.text('Idle'), findsOneWidget);
      expect(onPressedCalled, isFalse);
    });

    testWidgets('Should transition to idle on cancel when disposed',
        (WidgetTester tester) async {
      // A flag to check if onCancel is triggered
      bool onCancelCalled = false;

      // Mock onPressed implementation with a delayed operation
      Future<bool> onPressedMock() async {
        await Future.delayed(
            const Duration(milliseconds: 500)); // Simulate a delay
        return true;
      }

      // Build the initial widget
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: RippleActionButton(
            idleWidget: const Text('Idle'),
            onPressed: onPressedMock,
            onComplete: (_) async {},
            onError: () {
              onCancelCalled = true;
            },
          ),
        ),
      ));

      // Verify initial state is idle
      expect(find.text('Idle'), findsOneWidget);

      // Tap the button to trigger loading state
      await tester.tap(find.byType(RippleActionButton));
      await tester.pump(); // Trigger animation start

      // Verify transition to loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Replace the widget to simulate dispose
      await tester
          .pumpWidget(const MaterialApp(home: Scaffold(body: SizedBox())));

      // Resolve all pending timers to avoid the `!timersPending` error
      await tester.pump(
          const Duration(milliseconds: 500)); // Ensure delayed Future completes

      // Verify onCancel logic and state transition
      expect(onCancelCalled,
          isFalse); // `onCancel` should not be triggered after dispose
      expect(
          find.text('Idle'), findsNothing); // Widget is no longer in the tree
    });

    testWidgets(
        'Should simulate click to trigger success state and resets to idle',
        (WidgetTester tester) async {
      // Variables to track state transitions
      bool onSuccessCalled = false;
      bool onIdleCalled = false;

      // Create a GlobalKey for the RippleActionButton
      final GlobalKey<RippleActionButtonState> rippleActionButtonKey =
          GlobalKey<RippleActionButtonState>();

      // Mock the onPressed function
      Future<bool> mockOnPressed() async {
        await Future.delayed(
            const Duration(milliseconds: 300)); // Simulate async delay
        return true; // Indicate success
      }

      // Build the RippleActionButton widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: RippleActionButton(
                key: rippleActionButtonKey,
                idleWidget: const Text('Tap me'),
                onPressed: mockOnPressed,
                onSuccess: () {
                  onSuccessCalled = true;
                },
                onIdle: () {
                  onIdleCalled = true;
                },
              ),
            ),
          ),
        ),
      );

      // Ensure initial state is idle
      expect(find.text('Tap me'), findsOneWidget);
      expect(onIdleCalled, isTrue);

      // Reset state for further validation
      onIdleCalled = false;

      // Programmatically trigger simulateClick using the GlobalKey
      rippleActionButtonKey.currentState?.simulateClick();
      await tester.pump(); // Start the state transition

      // Allow time for loading state
      await tester.pump(const Duration(milliseconds: 300)); // Time for loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Allow time for success state
      await tester.pump(const Duration(milliseconds: 800)); // Time for success
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(onSuccessCalled, isTrue);

      // Allow time for success to transition back to idle
      await tester.pumpAndSettle(const Duration(seconds: 1)); // Time for idle
      expect(find.text('Tap me'), findsOneWidget);
      expect(onIdleCalled, isTrue);
    });
  });
}
