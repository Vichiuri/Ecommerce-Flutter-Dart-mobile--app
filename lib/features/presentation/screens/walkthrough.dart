import 'package:auto_route/auto_route.dart';
import 'package:biz_mobile_app/core/routes/app_router.gr.dart';
import 'package:biz_mobile_app/features/presentation/widgets/intro_widgets/intro_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../di/injection.dart';
import '../bloc/splash/splash_bloc.dart';

//intro splash screen
class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  SplashBloc splashBloc = getIt<SplashBloc>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: BlocProvider<SplashBloc>(
          create: (context) => splashBloc,
          child: BlocBuilder<SplashBloc, SplashState>(
            builder: (context, state) {
              if (state is SplashInitial) {
                return IntroWidget(splashBloc: splashBloc);
              } else if (state is SplashIntroErrorState) {
                return IntroWidget(
                  splashBloc: splashBloc,
                  title: state.message,
                  message: state.message,
                );
              } else if (state is SplashToLogin) {
                WidgetsBinding.instance!.addPostFrameCallback(
                  (_) => AutoRouter.of(context).replaceAll([LoginPageRoute()]),
                );
                return Container(color: Colors.white);
              } else {
                WidgetsBinding.instance!.addPostFrameCallback(
                  (_) =>
                      AutoRouter.of(context).replaceAll([UnknownPageRoute()]),
                );
                return Container(color: Colors.white);
              }
            },
          ),
        ),
      ),
    );
  }
}
