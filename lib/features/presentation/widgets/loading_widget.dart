import 'package:flutter/material.dart';

///Widget when state is loading
class LoadingWidget extends StatelessWidget {
  final double height;
  final String? title;
  const LoadingWidget({
    Key? key,
    required this.height,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        height: height,
        child: Column(
          children: [
            Container(
              height: height * 0.70,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
            SizedBox(height: 10),
            Container(
              height: height * 0.20,
              padding: EdgeInsets.all(10),
              alignment: Alignment.topCenter,
              child: Text(
                title ?? "Loading...",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
