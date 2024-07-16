import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';
import 'package:biz_mobile_app/features/presentation/components/rounded_icon_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../size_config.dart';

class ColorDots extends StatelessWidget {
  const ColorDots(
      {Key? key,
      required this.product,
      required this.add,
      required this.substract,
      required this.number,
      // required this.pressType,
      required this.onChanged,
      required TextEditingController controller})
      : _controller = controller,
        super(key: key);

  final ProductModel product;
  final VoidCallback add;
  final VoidCallback substract;
  // final VoidCallback pressType;
  final int number;
  final TextEditingController _controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    // Now this is fixed and only for demo
    int selectedColor = 3;
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        children: [
          ...List.generate(
            1,
            (index) => ColorDot(
              color: Colors.brown,
              isSelected: index == selectedColor,
            ),
          ),
          Spacer(),
          Expanded(
            child: TextField(
              decoration: InputDecoration(focusColor: Colors.black),
              inputFormatters: [
                LengthLimitingTextInputFormatter(4),
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
              controller: _controller,
              onChanged: onChanged,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          RoundedIconBtn(
            icon: Icons.remove,
            press: substract,
            key: new Key(""),
          ),
          SizedBox(width: getProportionateScreenWidth(20)),
          RoundedIconBtn(
            icon: Icons.add,
            showShadow: true,
            press: add,
          ),
        ],
      ),
    );
  }
}

class ColorDot extends StatelessWidget {
  const ColorDot({
    Key? key,
    required this.color,
    this.isSelected = false,
  }) : super(key: key);

  final Color color;
  final bool isSelected;

  get kPrimaryColor => null;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 2),
      padding: EdgeInsets.all(getProportionateScreenWidth(8)),
      height: getProportionateScreenWidth(40),
      width: getProportionateScreenWidth(40),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border:
            Border.all(color: isSelected ? kPrimaryColor : Colors.transparent),
        shape: BoxShape.circle,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
