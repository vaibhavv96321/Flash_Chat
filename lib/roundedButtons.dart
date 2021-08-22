import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  Buttons(
      {this.text, this.color, @required this.pushedName, this.borderAnimation});

  final String text;
  final Function pushedName;
  final Color color;
  final BorderRadius borderAnimation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: borderAnimation,
        child: MaterialButton(
          onPressed: pushedName,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
          ),
        ),
      ),
    );
  }
}
