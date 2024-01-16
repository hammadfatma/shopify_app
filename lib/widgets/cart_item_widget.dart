import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify_app/models/cart_model.dart';
import 'package:shopify_app/providers/cart_provider.dart';
import 'package:shopify_app/utils/constants.dart';

class CartItemWidget extends StatefulWidget {
  const CartItemWidget(
      {super.key,
      required this.contextDelete,
      required this.itemId,
      required this.cartData,
      required this.imagePath,
      required this.quantity,
      required this.nameTxt,
      required this.typeTxt,
      required this.priceTxt});
  final String imagePath;
  final String nameTxt, typeTxt;
  final String priceTxt;
  final int quantity;
  final String itemId;
  final CartModel cartData;
  final BuildContext contextDelete;

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 666,
          height: 111,
          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
          padding: EdgeInsets.only(left: 8, right: 8),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    kShadow1,
                  ],
                ),
                child: Center(
                  child: Image.network(
                    widget.imagePath,
                    width: 65,
                    height: 59,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.nameTxt,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Color(0xff515c6f),
                        ),
                      ),
                    ),
                    if (widget.typeTxt != 'Nothing, Nothing')
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.typeTxt,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                            color: Color(0xff515c6f),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '\$${widget.priceTxt}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Color(0xffff6969),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Provider.of<CartProvider>(context, listen: false)
                                .onDecreaseItemQuantity(
                                    context: widget.contextDelete,
                                    itemId: widget.itemId,
                                    cart: widget.cartData);
                          }, //
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Color(0xff727c8e).withOpacity(0.200),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.remove,
                                size: 10,
                                color: Color(0xff727c8e),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '${widget.quantity}',
                            style: TextStyle(
                                fontSize: 15, color: Color(0xff727c8e)),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Provider.of<CartProvider>(context, listen: false)
                                .onIncreaseItemQuantity(
                                    context: context,
                                    itemId: widget.itemId,
                                    cart: widget.cartData);
                          },
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Color(0xff727c8e).withOpacity(0.200),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                size: 10,
                                color: Color(0xff727c8e),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 10, top: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: kPrimaryColor),
            child: GestureDetector(
              onTap: () {
                Provider.of<CartProvider>(context, listen: false)
                    .onRemoveItemFromCart(
                        context: widget.contextDelete,
                        itemId: widget.itemId,
                        cart: widget.cartData);
              },
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
