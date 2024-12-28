import 'package:flutter/material.dart';
import 'package:ripple_action_button/ripple_action_button.dart';

void main() {
  runApp(HorizontalButtonExample());
}

class HorizontalButtonExample extends StatelessWidget {
  const HorizontalButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Horizontal Button Example')),
        body: Center(
          child: RippleActionButton(
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
          ),
        ),
      ),
    );
  }
}
