
import 'package:flutter/material.dart';
import 'package:ripple_action_button/ripple_action_button.dart';

void main() {
  runApp(CustomButtonStatesExample());
}

class CustomButtonStatesExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Custom Button States Example')),
        body: Center(
          child: RippleActionButton(
            idleWidget: Text('Submit'),
            loadingWidget: CircularProgressIndicator(),
            successWidget: Icon(Icons.check, color: Colors.green),
            errorWidget: Icon(Icons.error, color: Colors.red),
            onPressed: () async {
              await Future.delayed(Duration(seconds: 2));
              return false; // Simulate failure
            },
          ),
        ),
      ),
    );
  }
}
