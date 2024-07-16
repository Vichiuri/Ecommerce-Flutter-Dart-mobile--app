import 'package:flutter/material.dart';

class IconAnimation extends StatefulWidget {
  IconAnimation(
      {Key? key,
      required bool animate,
      required this.endRadius,
      required this.child})
      : _animate = animate,
        super(key: key);
  final bool _animate;
  final double endRadius;
  final Widget child;

  @override
  _IconAnimationState createState() => _IconAnimationState();
}

class _IconAnimationState extends State<IconAnimation>
    with SingleTickerProviderStateMixin<IconAnimation> {
  late final _animController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  late final _curveAnimation =
      CurvedAnimation(parent: _animController, curve: Curves.fastOutSlowIn);

  late final Animation<double> _smallDiscAnimation = Tween(
    begin: (widget.endRadius * 2) / 6,
    end: (widget.endRadius * 2) * (3 / 4),
  ).animate(_curveAnimation);
  late final Animation<double> _bigDiscAnimation = Tween(
    begin: 0.0,
    end: (widget.endRadius * 2),
  ).animate(_curveAnimation);
  late final Animation<double> _alphaAnimation = Tween(
    begin: 0.30,
    end: 0.0,
  ).animate(_animController);

  late void Function(AnimationStatus status) _statusListener = (_) async {
    if (_animController.status == AnimationStatus.completed) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted && widget._animate) {
        _animController.reset();
        _animController.forward();
      }
    }
  };

  @override
  void initState() {
    super.initState();
    if (widget._animate) {
      _startAnimation();
    }
  }

  @override
  void dispose() {
    _animController.removeStatusListener(_statusListener);
    _animController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void didUpdateWidget(covariant IconAnimation oldWidget) {
    if (widget._animate != oldWidget._animate) {
      if (widget._animate) {
        _startAnimation();
      } else {
        _stopAnimation();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  //functions
  void _startAnimation() async {
    _animController.addStatusListener(_statusListener);
    if (mounted) {
      _animController.reset();
      _animController.forward();
    }
  }

  void _stopAnimation() async {
    _animController.removeStatusListener(_statusListener);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _alphaAnimation,
      child: widget.child,
      builder: (c, child) {
        final decoration = BoxDecoration(
          shape: BoxShape.circle,
          // If the user picks a curve that goes below 0 or above 1
          // this opacity will have unexpected effects without clamping
          color: Colors.blue.withOpacity(
            _alphaAnimation.value.clamp(
              0.0,
              1.0,
            ),
          ),
        );
        return Container(
          height: widget.endRadius * 2,
          width: widget.endRadius * 2,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              AnimatedBuilder(
                animation: _bigDiscAnimation,
                builder: (context, widget) {
                  // If the user picks a curve that goes below 0,
                  // this will throw without clamping
                  final num size = _bigDiscAnimation.value.clamp(
                    0.0,
                    double.infinity,
                  );
                  return Container(
                    height: size as double?,
                    width: size as double?,
                    decoration: decoration,
                  );
                },
              ),
              AnimatedBuilder(
                animation: _smallDiscAnimation,
                builder: (context, widget) {
                  final num size = _smallDiscAnimation.value.clamp(
                    0.0,
                    double.infinity,
                  );

                  return Container(
                    height: size as double?,
                    width: size as double?,
                    decoration: decoration,
                  );
                },
              ),
              child!,
            ],
          ),
        );
      },
    );
  }
}
