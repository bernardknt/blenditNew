import 'package:flutter/cupertino.dart';


class TipsDialog extends StatelessWidget {
  final List<String> tips; // Array of tips
  final VoidCallback onClose;

  TipsDialog({required this.tips, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('Tips of the Day'),
      content: Column(
        children: [
          Text(
            tips[0], // Display the first tip from the array
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 10.0),
          Text(
            tips[1], // Display the second tip from the array
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          child: Text('Close'),
          onPressed: onClose,
        ),
      ],
    );
  }
}
