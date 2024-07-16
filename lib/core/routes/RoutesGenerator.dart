import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:biz_mobile_app/features/presentation/screens/product_details/details_screen.dart';
import 'package:biz_mobile_app/features/presentation/screens/walkthrough.dart';

import '../../features/presentation/screens/login.dart';
import '../../features/presentation/screens/splash.dart';
import '../../features/presentation/widgets/custom_button_widget.dart';
import '../utils/constants.dart';

class RoutesGenerator {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    //Getting arguments passed in while calling Navigator.pushNamed
    final args = routeSettings.arguments;
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
          settings: routeSettings,
        );

      case '/intro':
        return MaterialPageRoute(
          builder: (_) => IntroPage(),
          settings: routeSettings,
        );

      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());

      case '/details':
        if (args is ProductDetailsArguments) {
          return MaterialPageRoute(
              builder: (_) => ProductDetailsScreen(detailsArguments: args));
        }
        return _errorRoute();

      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(builder: (_) {
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
                press: () => Navigator.of(_).popAndPushNamed('/'),
                title: 'Refresh',
                color: Colors.blueAccent,
              )
            ],
          ),
        ),
      );
    });
  }
}
