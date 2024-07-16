import 'package:flutter/material.dart';

//custom snackbar bottim
class CustomSnackBar extends StatelessWidget {
  const CustomSnackBar({
    Key? key,
    this.message,
    this.title,
  }) : super(key: key);

  final String? message, title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: title != null
          ? Container(
              height: 60,
              width: double.infinity,
              color: title == "success" ? Colors.green : Colors.red,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Icon(
                        title == "success" ? Icons.thumb_up : Icons.warning,
                        color: Colors.white,
                      ),
                    ),
                    // SizedBox(width: 20),
                    Expanded(
                      flex: 5,
                      child: Center(
                        child: Text(
                          message ?? 'Something went wrong',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(height: 0, width: 0),
    );
  }
}
