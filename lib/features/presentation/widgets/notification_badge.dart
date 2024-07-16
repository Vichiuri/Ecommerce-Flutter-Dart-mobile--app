import 'package:flutter/material.dart';

//notification icon
class NotificationIconBadge extends StatefulWidget {
  final IconData icon;
  final double size;
  final String text;

  NotificationIconBadge(
      {Key? key, required this.icon, required this.size, required this.text})
      : super(key: key);

  @override
  _IconBadgeState createState() => _IconBadgeState();
}

class _IconBadgeState extends State<NotificationIconBadge> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Icon(
          widget.icon,
          size: widget.size,
        ),
        Positioned(
          right: 0.0,
          child: Container(
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: widget.text == "0" ? Colors.transparent : Colors.blue,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: BoxConstraints(
              minWidth: 13,
              minHeight: 13,
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 1),
              child: Text(
                widget.text == "0" ? "" : widget.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
