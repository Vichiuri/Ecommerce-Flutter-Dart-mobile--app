import 'package:biz_mobile_app/features/domain/models/distributors/Distributors.dart';
import 'package:biz_mobile_app/features/domain/models/retailers/RetailerModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

///distributor list slash retailer
class DistributorList extends StatelessWidget {
  final String name;
  final String? img;
  final int distId;
  final VoidCallback changeDefault;
  final DistributorsModel? dist;
  final RetailerModel? ret;
  final bool loading;

  DistributorList({
    Key? key,
    required this.name,
    required this.img,
    required this.distId,
    this.dist,
    this.ret,
    required this.loading,
    required this.changeDefault,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => ListTile(
        onTap: dist != null && distId == dist!.id ||
                ret != null && distId == ret!.id
            ? () {
                print("USHASELECT BANNNAAAAA");
              }
            : changeDefault,
        title: Text(
          "$name",
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            dist != null && distId == dist!.id
                ? Text(
                    "ACTIVE DISTRIBUTOR",
                    style: TextStyle(fontWeight: FontWeight.w800),
                  )
                : Opacity(opacity: 0),
            ret != null && distId == ret!.id
                ? Text(
                    "ACTIVE RETAILER",
                    style: TextStyle(fontWeight: FontWeight.w800),
                  )
                : Opacity(opacity: 0),
            Text("Contacts: +${dist?.phone ?? ret?.phone ?? ""}"),
            Text("Email: ${dist?.email ?? ret?.email ?? ""}")
          ],
        ),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () =>
                  canLaunch('https://wa.me/${dist?.phone ?? ret?.phone ?? ""}')
                      .then(
                (value) => {
                  if (value)
                    {
                      launch("https://wa.me/${dist?.phone ?? ret?.phone ?? ""}")
                          .catchError((e, s) => throw "$e,$s")
                    }
                  else
                    {print("CANNOT LAUNCH WHATSAPP")}
                },
              )
                      .catchError((e, s) {
                print("$e,$s");
              }),
              color: Color(0xff25D366),
              icon: Icon(FontAwesomeIcons.whatsapp),
            ),
            IconButton(
              onPressed: () =>
                  canLaunch('tel:${dist?.phone ?? ret?.phone ?? ""}')
                      .then(
                (value) => {
                  if (value)
                    {
                      launch("tel:${dist?.phone ?? ret?.phone ?? ""}")
                          .catchError((e, s) => throw "$e,$s")
                    }
                  else
                    {print("CANNOT LAUNCH CONTACTS")}
                },
              )
                      .catchError((e, s) {
                print("$e,$s");
              }),
              color: Colors.blue,
              icon: Icon(FontAwesomeIcons.phone),
            )
          ],
        ),
      );
  // return Row(
  //   children: [
  //     Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisSize: MainAxisSize.min,
  //       children: <Widget>[
  // Text(
  //   "$name",
  //   style: TextStyle(
  //     fontWeight: FontWeight.w900,
  //   ),
  // ),
  //         SizedBox(height: 5),
  // dist != null && distId == dist!.id
  //     ? Text("ACTIVE DISTRIBUTOR")
  //     : Opacity(opacity: 0),
  // ret != null && distId == ret!.id
  //     ? Text("ACTIVE RETAILER")
  //     : Opacity(opacity: 0)
  //       ],
  //     ),
  //   ],
  // );

}
