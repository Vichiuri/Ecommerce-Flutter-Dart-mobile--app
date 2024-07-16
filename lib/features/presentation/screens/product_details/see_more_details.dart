import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class SeeMoreDetails extends StatelessWidget {
  final String data;

  const SeeMoreDetails({Key? key, required this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        // centerTitle: true,
        title: Text('Product Details'),
      ),
      body: SingleChildScrollView(
        child: Html(
          data: data,
        ),
      ),
    );
  }
}
