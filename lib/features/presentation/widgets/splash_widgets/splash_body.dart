import 'package:biz_mobile_app/core/utils/const.dart';
import 'package:biz_mobile_app/features/presentation/icons/my_flutter_app_icons.dart';
import 'package:flutter/material.dart';

class SplashBody extends StatelessWidget {
  const SplashBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 40.0, right: 40.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset('assets/images/m_logo.png'),
            SizedBox(width: 40.0),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                top: 15.0,
              ),
              child: Text(
                "${Constants.appName}",
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
