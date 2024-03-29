import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify_app/providers/cart_provider.dart';
import 'package:shopify_app/utils/constants.dart';
import 'package:shopify_app/widgets/custom_button_icon.dart';
import 'package:shopify_app/widgets/selected_color_widget.dart';
import 'package:shopify_app/widgets/selected_size_widget.dart';
import 'package:uuid/uuid.dart';
import '../models/products_model.dart';
import '../widgets/icon_badge_widget.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});
  final ProductsModel product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    Provider.of<CartProvider>(context, listen: false).createItemInstance();
    super
        .initState(); // every time open details create instance of cartItem was empty but adding was in firebase
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: kPrimaryColor,
            size: 18,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.product.name,
                  textAlign: TextAlign.center, style: kStyle1),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$${widget.product.price.toStringAsFixed(2)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kSecondaryColor,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        actions: const [
          IconBadgeWidget(
            txt: '7',
            con: Icons.shopping_cart_outlined,
            fl: false,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              widget.product.image,
              height: MediaQuery.of(context).size.height / 1.5,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'SELECT COLOR',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: kSecondaryColor.withOpacity(0.502),
                          letterSpacing: 1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SelectedColor(
                    productsModel: widget.product,
                    selectedColorCallBack: (color) {
                      String colorString = color.toString();
                      if (colorString == 'Color(0xffed5199)') {
                        colorString = 'Soft pink';
                      } else if (colorString == 'Color(0xffff8c69)') {
                        colorString = 'Light red';
                      } else if (colorString == 'Color(0xff67b5f7)') {
                        colorString = 'Soft blue';
                      } else if (colorString == 'Color(0xffffffff)') {
                        colorString = 'White';
                      } else if (colorString == 'Color(0xffc9c9c9)') {
                        colorString = 'Light gray';
                      } else if (colorString == 'Color(0xff3e3a3a)') {
                        colorString = 'Dark gray';
                      } else {
                        colorString = 'Nothing';
                      }
                      Provider.of<CartProvider>(context, listen: false)
                          .cartItem
                          ?.selectColor = colorString;
                    },
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'SELECT SIZE',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: kSecondaryColor.withOpacity(0.502),
                          letterSpacing: 1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SelectedSize(
                    productsModel: widget.product,
                    selectedSizeCallBack: (sizeValue) {
                      String sizeString = sizeValue.toString();
                      Provider.of<CartProvider>(context, listen: false)
                          .cartItem
                          ?.valueSize = sizeString;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButtonWidget(
                        txt: 'ADD TO CART',
                        onTap: () {
                          Provider.of<CartProvider>(context, listen: false)
                              .cartItem
                              ?.productId = widget.product.id;
                          Provider.of<CartProvider>(context, listen: false)
                              .cartItem
                              ?.quantity = 1;
                          // uuid to generate random id and not repeat any more
                          Provider.of<CartProvider>(context, listen: false)
                              .cartItem
                              ?.itemId = const Uuid().v4();
                          Provider.of<CartProvider>(context, listen: false)
                              .onAddItemToCart(context: context);
                        },
                        width: 165,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
