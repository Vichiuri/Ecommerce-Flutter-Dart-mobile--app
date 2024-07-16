import 'package:biz_mobile_app/features/presentation/bloc/add_to_cart/add_to_cart_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/new_arrivals/new_arrivals_bloc.dart';
import 'package:biz_mobile_app/features/presentation/bloc/product_paginated/product_paginated_bloc.dart';
import 'package:biz_mobile_app/features/presentation/widgets/cart_icon_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:biz_mobile_app/features/domain/models/Products/ProductsModel.dart';

//single cart
class CartSingleWidget extends StatefulWidget {
  const CartSingleWidget({
    Key? key,
    required int cartQty,
    required int id,
    required this.product,
  })  : _cartQty = cartQty,
        _id = id,
        super(key: key);
  final int _cartQty;
  final ProductModel product;
  final int _id;
  @override
  _CartSingleWidgetState createState() => _CartSingleWidgetState();
}

class _CartSingleWidgetState extends State<CartSingleWidget> {
  bool _isLoading = false;
  int _quantity = 0;
  @override
  void initState() {
    super.initState();
    _quantity = widget._cartQty;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddToCartBloc, AddToCartState>(
          listener: (context, state) {
            if (state is AddToCartSuccess) {
              _isLoading = false;
            }
            if (state is AddToCartInitial) {
              _isLoading = true;
            }
            if (state is AddToCartLoading) {
              _isLoading = true;
            }
            if (state is AddToCartError) {
              _isLoading = false;
              if (_quantity > widget._cartQty) {
                _quantity--;
              } else {
                _quantity = widget._cartQty;
              }
            }
          },
        ),
        BlocListener<NewArrivalsBloc, NewArrivalsState>(
          listener: (context, state) {
            if (state is NewArrivalsSuccess) {
              setState(() {
                _quantity = widget._cartQty;
              });
            }
          },
        ),
        BlocListener<ProductPaginatedBloc, ProductPaginatedState>(
          listener: (context, state) {
            if (state is ProductPaginatedSuccess) {
              setState(() {
                _quantity = widget._cartQty;
              });
            }
          },
        ),
      ],
      child: BlocBuilder<AddToCartBloc, AddToCartState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.zero,
            child: IconButton(
                onPressed: () {
                  if (_isLoading) {
                    print("Tulia msee inaload");
                  } else {
                    context.read<AddToCartBloc>().add(AddToCartSingle(
                          prodId: widget._id,
                          product: widget.product,
                        ));

                    setState(() {
                      _quantity++;
                    });
                  }
                },
                icon: Container(
                  alignment: Alignment.center,
                  child: Center(
                    child: CartIconBadge(
                      icon: Icons.shopping_cart,
                      qty: _quantity,
                      size: 15,
                    ),
                  ),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0),
                  ], color: Colors.blue[300], shape: BoxShape.circle),
                )),
            // width: 20.0,
            // child: RawMaterialButton(
            //   padding: EdgeInsets.zero,
            // onPressed: () {
            //   if (_isLoading) {
            //     print("Tulia msee inaload");
            //   } else {
            //     context
            //         .read<AddToCartBloc>()
            //         .add(AddToCartSingle(prodId: widget._id));

            //     setState(() {
            //       _quantity++;
            //     });
            //   }
            // },
            //   fillColor: Colors.blue[300],
            //   shape: CircleBorder(),
            //   elevation: 4.0,
            //   child: CartIconBadge(
            //     icon: Icons.shopping_cart,
            //     qty: _quantity,
            //     size: 15,
            //   ),
            // ),
          );
        },
      ),
    );
  }
}
