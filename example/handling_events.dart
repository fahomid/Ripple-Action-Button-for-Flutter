
import 'package:flutter/material.dart';
import 'package:ripple_action_button/ripple_action_button.dart';

void main() {
  runApp(HandlingEventsExample());
}

class HandlingEventsExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Handling Events Example')),
        body: Center(
          child: RippleActionButton(
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
          ),
        ),
      ),
    );
  }
}
