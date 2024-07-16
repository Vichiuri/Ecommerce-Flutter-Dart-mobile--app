import 'package:biz_mobile_app/features/presentation/bloc/add_remove_to_fav/add_remove_to_fav_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/new_arrivals/new_arrivals_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/product_paginated/product_paginated_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//favourite screen page
class FavouriteWidget extends StatefulWidget {
  const FavouriteWidget({Key? key, required bool isFav, required int id})
      : _isFav = isFav,
        _id = id,
        super(key: key);

  final bool _isFav;
  final int _id;

  @override
  _FavouriteWidgetState createState() => _FavouriteWidgetState();
}

class _FavouriteWidgetState extends State<FavouriteWidget> {
  bool _favourite = false;
  @override
  void initState() {
    super.initState();
    _favourite = widget._isFav;
  }

  // @override
  // void didUpdateWidget(covariant FavouriteWidget oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (oldWidget._isFav == widget._isFav) {
  //     print("DidUpdateWidget");
  //     _favourite = widget._isFav;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddRemoveToFavBloc, AddRemoveToFavState>(
          listener: (context, state) {
            if (state is AddRemoveToFavError) {
              _favourite = widget._isFav;
            }
          },
        ),
        BlocListener<NewArrivalsBloc, NewArrivalsState>(
          listener: (context, state) {
            if (state is NewArrivalsSuccess) {
              _favourite = widget._isFav;
            }
          },
        ),
        BlocListener<ProductPaginatedBloc, ProductPaginatedState>(
          listener: (context, state) {
            if (state is ProductPaginatedSuccess) {
              setState(() {
                _favourite = widget._isFav;
              });
            }
          },
        ),
      ],
      child: BlocBuilder<AddRemoveToFavBloc, AddRemoveToFavState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.zero,
            child: IconButton(
              onPressed: () {
                context
                    .read<AddRemoveToFavBloc>()
                    .add(AddRemoveToFavPressed(prodId: widget._id));
                setState(() {
                  _favourite = !_favourite;
                });
              },
              icon: Icon(
                Icons.favorite,
                size: 12,
                color: _favourite ? Colors.red : Colors.black45,
              ),
            ),
          );
          // return Container(
          //   padding: const EdgeInsets.all(0.0),
          //   width: 20.0,
          //   child: IconButton(
          //     padding: EdgeInsets.zero,
          //     icon: Icon(
          //       Icons.favorite,
          //       // color: Colors.red,
          //       color: _favourite ? Colors.red : Colors.black45,
          //       size: 18,
          //     ),
          //     onPressed: () {
          // context
          //     .read<AddRemoveToFavBloc>()
          //     .add(AddRemoveToFavPressed(prodId: widget._id));
          // setState(() {
          //   _favourite = !_favourite;
          // });
          //     },
          //   ),
          // );
        },
      ),
    );
  }
}
