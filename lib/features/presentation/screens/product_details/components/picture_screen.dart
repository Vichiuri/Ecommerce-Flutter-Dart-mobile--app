import 'package:biz_mobile_app/core/utils/constants.dart';
import 'package:biz_mobile_app/features/domain/models/ProductImages/ProductImagesModel.dart';
import 'package:flutter/material.dart';

class PictureScreen extends StatefulWidget {
  const PictureScreen({
    Key? key,
    required this.images,
    required this.image,
  }) : super(key: key);
  final List<ProductImagesModel> images;
  final ProductImagesModel image;

  @override
  _PictureScreenState createState() => _PictureScreenState();
}

class _PictureScreenState extends State<PictureScreen> {
  late final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    late final _index = widget.images.indexOf(widget.image);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _pageController.jumpToPage(_index);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        body: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {},
          itemCount: widget.images.length,
          itemBuilder: (c, i) => SizedBox.expand(
            child: Image.network(
              IMAGE_URL + widget.images[i].image!,
              fit: BoxFit.contain,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (o, c, s) =>
                  Image.asset("assets/images/placeholder.png"),
            ),
          ),
        ));
  }
}
