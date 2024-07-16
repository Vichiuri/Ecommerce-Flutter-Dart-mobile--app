import 'package:flutter/material.dart';

class HorizontalDottedIndicator extends StatefulWidget {
  const HorizontalDottedIndicator({Key? key}) : super(key: key);

  @override
  _HorizontalDottedIndicatorState createState() =>
      _HorizontalDottedIndicatorState();
}

class _HorizontalDottedIndicatorState extends State<HorizontalDottedIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class HorizontalDot extends StatelessWidget {
  const HorizontalDot({Key? key, required this.isActive}) : super(key: key);
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.bounceInOut,
      height: isActive ? 4.5 : 6,
      width: isActive ? 10.5 : 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.white : Colors.grey,
        border: isActive
            ? Border.all(
                color: Colors.blue,
                width: 2.0,
              )
            : Border.all(
                color: Colors.transparent,
                width: 1,
              ),
      ),
    );
  }
}
