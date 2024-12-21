
import 'package:flutter/material.dart';
import 'package:ripple_action_button/ripple_action_button.dart';

void main() {
  runApp(VerticalButtonExample());
}

class VerticalButtonExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Vertical Button Example')),
        body: Center(
          child: RippleActionButton(
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
          ),
        ),
      ),
    );
  }
}
