import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify_app/screens/order_tracker_screen.dart';
import 'package:shopify_app/widgets/custom_appbar_widget.dart';
import 'package:shopify_app/widgets/custom_button_icon.dart';
import 'package:shopify_app/widgets/order_item_widget.dart';
import '../models/cart_model.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';
import '../utils/constants.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackColor,
      appBar: const CustomAppBarWidget(),
      body: SingleChildScrollView(
        child: Padding(
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
                  return Center(
                      child: Image.network(
                          'https://cdn.dribbble.com/users/9620200/screenshots/17987839/media/fd60cc8251e50a8c54d3dde620ff9460.jpg?resize=400x300&vertical=center'));
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'My orders',
                            style: kHeadLineStyle,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
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
                                        color: kPrimaryColor,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: data.items?.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: FutureBuilder(
                              future: Provider.of<ProductsProvider>(context)
                                  .getProductsById(
                                      productId: data.items![index].productId!),
                              builder: (context, snapShot) {
                                if (snapShot.data != null) {
                                  Provider.of<CartProvider>(context,
                                          listen: false)
                                      .onAddProductToList(snapShot.data!, data);
                                  Provider.of<CartProvider>(
                                    context,
                                  ).calculateTotal(data);
                                }
                                return OrderItemWidget(
                                  imagePath: snapShot.data?.image ??
                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNgzWAan9TYETCLgNxYmJuUgpDKZgWT4FF84GJyo12bZde672xL0l-gsSaeA&s',
                                  nameTxt: snapShot.data?.name ?? 'no name',
                                  typeTxt:
                                      'color: ${data.items?[index].selectColor}, size: ${data.items?[index].valueSize}',
                                  priceTxt:
                                      snapShot.data?.price.toStringAsFixed(2) ??
                                          'no price',
                                  quantity:
                                      'quantity: ${data.items?[index].quantity ?? 0}',
                                );
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomButtonWidget(txt: 'ORDER TRACKER', onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const OrderTrackerScreen()));
                          }, width: 170),
                        ],
                      )
                    ],
                  );
                }
              } else {
                return Text('Connection Statue ${snapshot.connectionState}');
              }
            },
          ),
        ),
      ),
    );
  }
}
