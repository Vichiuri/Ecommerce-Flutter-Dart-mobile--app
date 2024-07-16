import 'package:flutter/material.dart';

import 'slider_model.dart';

///style of the items displayed on the widgets
class SlideItem extends StatelessWidget {
  final int index;
  SlideItem(this.index);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: size.height * 0.6,
          width: size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                sliderArrayList[index].sliderImageUrl,
              ),
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(
          height: (MediaQuery.of(context).padding.left +
                  MediaQuery.of(context).padding.right) *
              15,
        ),
        Text(
          sliderArrayList[index].sliderHeading,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20.5,
          ),
        ),
        SizedBox(
          height: (size.width / 100) * 3,
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              sliderArrayList[index].sliderSubHeading,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
                fontSize: 12.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
