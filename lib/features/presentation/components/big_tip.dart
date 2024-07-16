import 'package:flutter/material.dart';

class BigTip extends StatelessWidget {
  const BigTip({Key? key, required this.icon, this.title, this.subtitle})
      : super(key: key);

  /// If this parameters holds a [Icon] widget, an automatic theme will be applied,
  /// setting its size to 100, and using the caption text style's color by default.
  final Widget icon;

  /// Main title widget of the view. Usually a [Text] widget.
  final Widget? title;

  /// Secondary widget of the view. Usually a [Text] widget.
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconTheme.merge(
              data: Theme.of(context).iconTheme.copyWith(
                    color: Theme.of(context).textTheme.caption!.color,
                    size: 100,
                  ),
              child: icon,
            ),
            if (title != null || subtitle != null) SizedBox(height: 22),
            if (title != null)
              DefaultTextStyle(
                style: Theme.of(context).textTheme.headline6!,
                textAlign: TextAlign.center,
                child: title!,
              ),
            if (subtitle != null) ...[
              if (title != null) SizedBox(height: 8),
              DefaultTextStyle(
                style: Theme.of(context).textTheme.subtitle1!,
                textAlign: TextAlign.center,
                child: subtitle!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
