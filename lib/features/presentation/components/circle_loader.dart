import 'package:flutter/material.dart';
import 'dart:math' as math show sin, pi;

///CIrcle Loader Animated
class CircleLoader extends StatefulWidget {
  const CircleLoader({Key? key, double size = 50.0, Color? color})
      : _size = size,
        _color = color,
        super(key: key);
  final double _size;
  final Color? _color;

  @override
  _CircleLoaderState createState() => _CircleLoaderState();
}

class _CircleLoaderState extends State<CircleLoader>
    with SingleTickerProviderStateMixin<CircleLoader> {
  late final _animationController =
      (AnimationController(vsync: this, duration: Duration(milliseconds: 1200)))
        ..repeat();
  late final List<double> _delays = [
    .0,
    -1.1,
    -1.0,
    -0.9,
    -0.8,
    -0.7,
    -0.6,
    -0.5,
    -0.4,
    -0.3,
    -0.2,
    -0.1
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size.square(widget._size),
        child: Stack(
          children: List.generate(_delays.length, (index) {
            final _position = widget._size * .5;
            return Positioned.fill(
              left: _position,
              top: _position,
              child: Transform(
                transform: Matrix4.rotationZ(30.0 * index * 0.0174533),
                child: Align(
                  alignment: Alignment.center,
                  child: ScaleTransition(
                    scale: DelayTween(
                      delay: _delays[index],
                      begin: 0.0,
                      end: 1.0,
                    ).animate(_animationController),
                    child: SizedBox.fromSize(
                      size: Size.square(widget._size * 0.15),
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                        color: widget._color ??
                            Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      )),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class DelayTween extends Tween<double> {
  DelayTween({double? begin, double? end, required this.delay})
      : super(begin: begin, end: end);

  final double delay;

  @override
  double lerp(double t) =>
      super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
