import 'package:flutter/material.dart';

import 'action_button.dart';

class BottomActionBar extends StatelessWidget {
  List<ActionButton> actionButtonsList;

  BottomActionBar({required this.actionButtonsList});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      padding: EdgeInsets.all(10.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: actionButtonsList),
    );
  }
}
