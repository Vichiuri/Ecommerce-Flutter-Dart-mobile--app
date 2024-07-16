import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//bottom loader for infinit list
class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(Colors.blue),
          ),
        ),
      ),
    );
  }
}
