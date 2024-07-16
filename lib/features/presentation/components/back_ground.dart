import 'package:flutter/widgets.dart';

class BackGroundWidget extends StatelessWidget {
  const BackGroundWidget({Key? key, required Widget child})
      : _child = child,
        super(key: key);
  final Widget _child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      "assets/images/bg.png",
                    ))),
          ),
        ),
        SizedBox.expand(child: _child)
      ],
    );
  }
}
