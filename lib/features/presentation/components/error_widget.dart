import 'package:flutter/material.dart';

///error when call fails
class DashboardErrorWidget extends StatelessWidget {
  final VoidCallback refresh;

  const DashboardErrorWidget({Key? key, required this.refresh})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Container(
        // height: double.infinity,
        // width: double.infinity,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                // height: 100,
                // child: Lottie.asset(
                //   "assets/lottie/sad_cloud.json",
                // ),
                ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Something went wrong, Please try again",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: refresh,
              color: Colors.blue,
              textColor: Colors.white,
              child: Text("RETRY"),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
