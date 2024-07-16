import 'package:flutter/material.dart';

///cart icon badge

class CartIconBadge extends StatefulWidget {
  final IconData icon;
  final double size;
  final int qty;

  CartIconBadge({
    Key? key,
    required this.icon,
    required this.qty,
    required this.size,
  }) : super(key: key);

  @override
  _IconBadgeState createState() => _IconBadgeState();
}

class _IconBadgeState extends State<CartIconBadge> {
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
              color: widget.qty == 0 ? Colors.transparent : Colors.blue,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: BoxConstraints(
              minWidth: 13,
              minHeight: 13,
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 1),
              child: Text(
                widget.qty == 0 ? "" : "${widget.qty}",
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
