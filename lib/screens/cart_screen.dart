import 'package:flutter/material.dart';
import 'package:shopify_app/screens/order_placed_screen.dart';
import 'package:shopify_app/utils/constants.dart';
import 'package:shopify_app/widgets/custom_button_icon.dart';

import '../models/products_model.dart';
import '../widgets/cart_item_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key, required this.product});
  final ProductsModel product;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Cart',
                      style: kHeadLineStyle,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CartItemWidget(
                    imagePath: product.image,
                    nameTxt: product.name,
                    typeTxt: 'pink, small',
                    priceTxt: product.price,
                  ),
                  CartItemWidget(
                    imagePath: product.image,
                    nameTxt: product.name,
                    typeTxt: 'pink, small',
                    priceTxt: product.price,
                  ),
                  CartItemWidget(
                    imagePath: product.image,
                    nameTxt: product.name,
                    typeTxt: 'pink, small',
                    priceTxt: product.price,
                  ),
                  CartItemWidget(
                    imagePath: product.image,
                    nameTxt: product.name,
                    typeTxt: 'pink, small',
                    priceTxt: product.price,
                  ),
                  CartItemWidget(
                    imagePath: product.image,
                    nameTxt: product.name,
                    typeTxt: 'pink, small',
                    priceTxt: product.price,
                  ),
                  CartItemWidget(
                    imagePath: product.image,
                    nameTxt: product.name,
                    typeTxt: 'pink, small',
                    priceTxt: product.price,
                  ),
                  CartItemWidget(
                    imagePath: product.image,
                    nameTxt: product.name,
                    typeTxt: 'pink, small',
                    priceTxt: product.price,
                  ),
                  CartItemWidget(
                    imagePath: product.image,
                    nameTxt: product.name,
                    typeTxt: 'pink, small',
                    priceTxt: product.price,
                  ),
                  CartItemWidget(
                    imagePath: product.image,
                    nameTxt: product.name,
                    typeTxt: 'pink, small',
                    priceTxt: product.price,
                  ),
                  SizedBox(
                    height: 20,
                    child: Center(
                      child: Divider(),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TOTAL',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: kSecondaryColor.withOpacity(0.502),
                            ),
                          ),
                          Text(
                            '\$81.57',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: kSecondaryColor,
                            ),
                          ),
                          Text(
                            'Free Domestic Shipping',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff727c8e),
                            ),
                          ),
                        ],
                      ),
                      CustomButtonWidget(
                          txt: 'PLACE ORDER',
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderPlacedScreen()));
                          },
                          width: 165),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
