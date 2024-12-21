
import 'package:flutter/material.dart';
import 'package:ripple_action_button/ripple_action_button.dart';

void main() {
  runApp(SimpleButtonExample());
}

class SimpleButtonExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Simple Button Example')),
        body: Center(
          child: RippleActionButton(
            idleWidget: Text('Click Me'),
            onPressed: () async {
              await Future.delayed(Duration(seconds: 2));
              return true; // Simulate success
            },
          ),
        ),
      ),
    );
  }
}
