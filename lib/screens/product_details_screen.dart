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
  void initState(){
    Provider.of<CartProvider>(context,listen: false).createItemInstance();
    super.initState(); // every time open details create instance of cartItem was empty but adding was in firebase
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
          icon: Icon(
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
              Text(widget.product.name, textAlign: TextAlign.center, style: kStyle1),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$${widget.product.price.toStringAsFixed(2)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: kSecondaryColor,
                    ),
                  ),
                  Container(
                    width: 42,
                    height: 19,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kPrimaryColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          size: 12,
                          color: kWhiteColor,
                        ),
                        Text(
                          '4.9',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: kWhiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        actions: [
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
              padding: EdgeInsets.all(8),
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
                  SizedBox(height: 8),
                  SelectedColor(productsModel: widget.product,selectedColorCallBack: (color){
                    String colorString = color.toString();
                    if(colorString == 'Color(0xffed5199)'){
                      colorString = 'Brilliant Rose';
                    }else if(colorString == 'Color(0xffff8c69)'){
                      colorString = 'Salmon';
                    }else if(colorString == 'Color(0xff67b5f7)'){
                      colorString = 'Malibu';
                    }
                    else if(colorString == 'Color(0xffffffff)'){
                      colorString = 'White';
                    }
                    else if(colorString == 'Color(0xffc9c9c9)'){
                      colorString = 'Silver';
                    }
                    else if(colorString == 'Color(0xff3e3a3a)'){
                      colorString = 'Mine Shaft';
                    }else{
                      colorString = 'No Found';
                    }
                    print("============${color.toString()}========");
                    Provider.of<CartProvider>(context, listen: false).cartItem?.selectColor = colorString;
                  },),
                  SizedBox(height: 8),
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
                  SizedBox(height: 8),
                  SelectedSize(productsModel: widget.product,selectedSizeCallBack: (size){
                    print("============${size}========");
                    Provider.of<CartProvider>(context,listen: false).cartItem?.selectSize = size;
                  },),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButtonWidget(
                        txt: 'ADD TO CART',
                        onTap: () {
                          Provider.of<CartProvider>(context,listen: false).cartItem?.productId = widget.product.id;
                          Provider.of<CartProvider>(context, listen: false).cartItem?.quantity = 1;
                          // uuid to generate random id and not repeat any more
                          Provider.of<CartProvider>(context,listen: false).cartItem?.itemId = Uuid().v4();
                          Provider.of<CartProvider>(context,listen: false).onAddItemToCart(context: context);
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => CartScreen(
                          //         product: widget.product,
                          //       ),
                          //     ));
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
