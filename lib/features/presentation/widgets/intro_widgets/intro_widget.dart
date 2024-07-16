import 'dart:async';

import 'package:biz_mobile_app/features/presentation/bloc/splash/splash_bloc.dart';
import 'package:biz_mobile_app/features/presentation/widgets/intro_widgets/slide_item.dart';
import 'package:biz_mobile_app/features/presentation/widgets/intro_widgets/slider_model.dart';
import 'package:flutter/material.dart';

import '../custom_snack_bar.dart';
import 'slider_dots.dart';

///intro slider widget
///
class IntroWidget extends StatefulWidget {
  IntroWidget({
    Key? key,
    this.message,
    this.title,
    required this.splashBloc,
  }) : super(key: key);
  final String? message, title;
  final SplashBloc splashBloc;
  @override
  _IntroWIdgetState createState() => _IntroWIdgetState();
}

class _IntroWIdgetState extends State<IntroWidget> {
  int _currentPage = 0;

  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  void initState() {
    super.initState();

    //!automatic pageview scroller
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      final isLastPage = _currentPage.round() == sliderArrayList.length - 1;
      if (isLastPage) {
        timer.cancel();
        return;
      }
      if (_pageController.hasClients) {
        _pageController.nextPage(
            duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      }
    });
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLastPage = (_currentPage.round() == sliderArrayList.length - 1);
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(10.0),
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                PageView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: sliderArrayList.length,
                  itemBuilder: (context, i) => SlideItem(i),
                ),
                Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 15.0, bottom: 15.0),
                        child: MaterialButton(
                          elevation: 0,
                          onPressed: isLastPage
                              ? () =>
                                  widget.splashBloc.add(SaveFirstTimeEvent())
                              : () {
                                  if (_pageController.hasClients) {
                                    _pageController.nextPage(
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.easeIn,
                                    );
                                  }
                                },
                          focusColor: Colors.blue,
                          child: Text(
                            isLastPage ? "DONE" : "NEXT",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.0, bottom: 15.0),
                        child: isLastPage
                            ? Opacity(opacity: 1)
                            : MaterialButton(
                                elevation: 0,
                                onPressed: () =>
                                    widget.splashBloc.add(SaveFirstTimeEvent()),
                                focusColor: Colors.blue,
                                child: Text(
                                  "SKIP",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Container(
                      alignment: AlignmentDirectional.bottomCenter,
                      margin: EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          for (int i = 0; i < sliderArrayList.length; i++)
                            if (i == _currentPage)
                              SlideDots(true)
                            else
                              SlideDots(false)
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          if (widget.title != null)
            CustomSnackBar(message: widget.message, title: widget.title)
        ],
      ),
    );
  }
}
