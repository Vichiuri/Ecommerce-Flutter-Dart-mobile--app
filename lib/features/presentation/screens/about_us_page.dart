import 'package:biz_mobile_app/features/domain/models/distributors/about_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

///about company page
class ABoutUsPage extends StatelessWidget {
  final AboutModel? _about;

  const ABoutUsPage({Key? key, required AboutModel? about})
      : _about = about,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Distributor"),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "About Us",
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: 20,
            ),
            Html(
              data: _about?.about ?? "",
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Privacy Policy",
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: 10,
            ),
            Html(
              data: _about?.privacy ?? "",
            ),
            Text(
              "Terms and Condition",
              style: Theme.of(context).textTheme.headline5,
            ),
            Html(
              data: _about?.terms ?? "",
            ),
          ],
        ),
      ),
    );
  }
}
