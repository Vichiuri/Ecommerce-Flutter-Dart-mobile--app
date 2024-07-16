import 'package:flutter/material.dart';

//custom button
class MyCustomButton extends StatelessWidget {
  const MyCustomButton({
    Key? key,
    required this.press,
    required this.title,
    required this.color,
  }) : super(key: key);

  final Function press;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        onPressed: () => press,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: color != null ? color : Theme.of(context).accentColor,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: "OpenSans",
          ),
        ),
      ),
    );
  }
}
