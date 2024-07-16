import 'package:auto_route/auto_route.dart';
import 'package:biz_mobile_app/core/routes/app_router.gr.dart';
import 'package:biz_mobile_app/core/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/Category/CategoryModel.dart';

//categories
class ViewCategories extends StatelessWidget {
  const ViewCategories({
    Key? key,
    required this.categories,
  }) : super(key: key);

  final List<CategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Categories",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              categories.isEmpty
                  ? Opacity(opacity: 0)
                  : MaterialButton(
                      onPressed: () => AutoRouter.of(context)
                          .push(AllCategoriesRoute(categories: categories)),
                      child: Text(
                        "View All",
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
            ],
          ),
          //!hapa
          Container(
            height: 120,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ListView.builder(
                    itemCount: categories.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () =>
                          AutoRouter.of(context).push(CategoriesScreenRoute(
                        categoryModel: categories[index],
                      )),
                      child: Card(
                        margin: EdgeInsets.symmetric(horizontal: 3),
                        child: Container(
                          width: 120,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.all(20),
                                  width: 120,
                                  child: categories[index].category_pic != null
                                      ? FadeInImage.assetNetwork(
                                          placeholder:
                                              "assets/images/placeholder.png",
                                          image: IMAGE_URL +
                                              categories[index].category_pic!,
                                          imageErrorBuilder: (c, o, s) =>
                                              Image.asset(
                                            'assets/images/placeholder.png',
                                          ),
                                        )
                                      : Image.asset(
                                          "assets/images/placeholder.png",
                                        ),
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  children: [
                                    Text(
                                      categories[index].name ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "${categories[index].productcount} items",
                                      overflow: TextOverflow.ellipsis,
                                      // maxLines: 2,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
