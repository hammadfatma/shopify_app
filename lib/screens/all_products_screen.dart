import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify_app/screens/product_details_screen.dart';
import 'package:shopify_app/utils/constants.dart';
import 'package:shopify_app/widgets/custom_appbar_widget.dart';
import '../providers/products_provider.dart';
import '../widgets/products_card_widget.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key, required this.categoryId});
  final String categoryId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackColor,
      appBar: const CustomAppBarWidget(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'All Products',
                  style: kHeadLineStyle,
                ),
              ),
            ),
            Consumer<ProductsProvider>(
              builder: (context, value, child) {
                return FutureBuilder(
                  future: value.getProducts(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Text('Error While Get Data');
                      } else if (snapshot.hasData) {
                        final filteredProducts = snapshot.data!
                            .where((product) => product.categoryId == categoryId)
                            .toList();
                        if (filteredProducts.isNotEmpty) {
                          return FlexibleGridView(
                              axisCount: GridLayoutEnum.threeElementsInRow,
                              shrinkWrap: true,
                              children: filteredProducts
                                  .map((item) => ProductWidget(
                                product: item,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetailsScreen(
                                            product: item,
                                          ),
                                    ),
                                  );
                                },
                              ))
                                  .toList());
                        } else {
                          return Center(
                            child: Text('No Product Found'),
                          );
                        }
                      } else {
                        return Text('No Data Found');
                      }
                    } else {
                      return Text(
                          'Connection Statue ${snapshot.connectionState}');
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
