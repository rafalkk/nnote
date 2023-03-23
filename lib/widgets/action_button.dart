import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  IconData icon;
  String label;
  VoidCallback handleOnTap;

  ActionButton({
    required this.icon,
    required this.label,
    required this.handleOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: handleOnTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.black,
          ),
          Text(label),
        ],
      ),
    );
  }
}
