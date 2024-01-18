import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify_app/models/cart_model.dart';
import 'package:shopify_app/providers/cart_provider.dart';
import 'package:shopify_app/providers/products_provider.dart';
import 'package:shopify_app/screens/order_placed_screen.dart';
import 'package:shopify_app/utils/constants.dart';
import 'package:shopify_app/widgets/custom_appbar_widget.dart';
import 'package:shopify_app/widgets/custom_button_icon.dart';
import '../widgets/cart_item_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext screenContext) {
    return Scaffold(
      backgroundColor: kBackColor,
      appBar: const CustomAppBarWidget(),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: StreamBuilder(
          stream: Provider.of<CartProvider>(context).cartStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Text('Error While Get Data');
            } else if (snapshot.hasData) {
              var data = CartModel.fromJson(
                  Map<String, dynamic>.from(snapshot.data?.data() ?? {}));
              if (data.items?.isEmpty ?? false) {
                return Center(child: Image.network('https://www.adasglobal.com/img/empty-cart.png'));
              } else {
                return Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      left: 0,
                      bottom: 0,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              child: Text(
                                'Cart',
                                style: kHeadLineStyle,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: data.items?.length,
                              itemBuilder: (context, index) {
                                return SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: FutureBuilder(
                                      future: Provider.of<ProductsProvider>(context)
                                          .getProductsById(
                                              productId:
                                                  data.items![index].productId!),
                                      builder: (context, snapShot) {
                                        if (snapShot.data != null) {
                                          Provider.of<CartProvider>(context,
                                                  listen: false)
                                              .onAddProductToList(
                                                  snapShot.data!, data);
                                          Provider.of<CartProvider>(
                                            context,
                                          ).calculateTotal(data);
                                        }
                                        return CartItemWidget(
                                          imagePath: snapShot.data?.image ??
                                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNgzWAan9TYETCLgNxYmJuUgpDKZgWT4FF84GJyo12bZde672xL0l-gsSaeA&s',
                                          nameTxt: snapShot.data?.name ?? 'no name',
                                          typeTxt:
                                              '${data.items?[index].selectColor}, ${data.items?[index].valueSize}',
                                          priceTxt: snapShot.data?.price
                                                  .toStringAsFixed(2) ??
                                              'no price',
                                          quantity:
                                              data.items?[index].quantity ?? 0,
                                          itemId: data.items![index].itemId!,
                                          cartData: data,
                                          contextDelete:
                                              screenContext,
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 50,
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
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
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
                                  ValueListenableBuilder(
                                    valueListenable:
                                        Provider.of<CartProvider>(context)
                                            .totalNotifier,
                                    builder: (context, value, child) {
                                      return Text(
                                        '\$$value',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: kSecondaryColor,
                                        ),
                                      );
                                    },
                                  ),
                                  const Text(
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
                                            builder: (context) =>
                                                const OrderPlacedScreen()));
                                  },
                                  width: 165),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            } else {
              return Text('Connection Statue ${snapshot.connectionState}');
            }
          },
        ),
      ),
    );
  }
}
