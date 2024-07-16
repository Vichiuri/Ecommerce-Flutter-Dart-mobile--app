import 'package:auto_route/auto_route.dart';
import 'package:biz_mobile_app/core/routes/app_router.gr.dart';
import 'package:biz_mobile_app/core/utils/constants.dart';
import 'package:biz_mobile_app/features/presentation/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';

///Unknown Routes of the app
class UnknownPage extends StatelessWidget {
  const UnknownPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'Seems you wondered off',
              style: kLabelStyle,
            ),
            SizedBox(height: 10),
            MyCustomButton(
              press: () =>
                  AutoRouter.of(context).replaceAll([SplashScreenRoute()]),
              title: 'Refresh',
              color: Colors.blueAccent,
            )
          ],
        ),
      ),
    );
  }
}
