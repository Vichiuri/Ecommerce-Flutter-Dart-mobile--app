import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:biz_mobile_app/core/routes/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../di/injection.dart';
import '../bloc/splash/splash_bloc.dart';
import '../widgets/splash_widgets/splash_body.dart';

///the first screen of the app, the entry point
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashBloc splashBloc = getIt<SplashBloc>();

  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIOverlays([]);

    Timer(
      Duration(seconds: 2),
      () => splashBloc.add(CheckFirstTimeEvent()),
    );

    // WidgetsBinding.instance!.addPostFrameCallback(
    //     (timeStamp) => context.read<NetworkBloc>().add(NetworkStarted()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: BlocProvider<SplashBloc>(
        create: (context) => splashBloc,
        child: BlocBuilder<SplashBloc, SplashState>(
          builder: (context, state) {
            if (state is SplashInitial) {
              return SplashBody();
            } else if (state is SplashToIntro) {
              WidgetsBinding.instance!.addPostFrameCallback(
                (_) => AutoRouter.of(context).replaceAll([IntroPageRoute()]),
              );
              return Container();
            } else if (state is SplashToHome) {
              // WidgetsBinding.instance!.addPostFrameCallback(
              //   (_) => AutoRouter.of(context).replace(MainScreenRoute()),
              // );
              WidgetsBinding.instance!.addPostFrameCallback(
                (_) => AutoRouter.of(context).replaceAll([HomePageRoute()]),
              );
              return Container();
            } else if (state is SplashToLogin) {
              WidgetsBinding.instance!.addPostFrameCallback(
                (_) => AutoRouter.of(context).replaceAll([LoginPageRoute()]),
              );
              return Container();
            } else {
              WidgetsBinding.instance!.addPostFrameCallback(
                (_) => AutoRouter.of(context).replaceAll([UnknownPageRoute()]),
              );
              return Container();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    splashBloc.close();
    super.dispose();
  }
}
