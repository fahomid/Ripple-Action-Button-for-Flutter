import 'package:flutter/material.dart';
import 'package:ripple_action_button/ripple_action_button.dart';

void main() {
  runApp(HandlingEventsExample());
}

class HandlingEventsExample extends StatelessWidget {
  const HandlingEventsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Handling Events Example')),
        body: Center(
          child: RippleActionButton(
            idleWidget: Text('Process'),
            onIdle: () => debugPrint('Button is idle'),
            onLoading: () => debugPrint('Loading...'),
            onSuccess: () => debugPrint('Action succeeded'),
            onError: () => debugPrint('Action failed'),
            onPressed: () async {
              await Future.delayed(Duration(seconds: 2));
              throw Exception('Simulated error'); // Triggers onError
            },
            onException: (error, stackTrace) {
              debugPrint('Exception occurred: $error');
            },
          ),
        ),
      ),
    );
  }
}
