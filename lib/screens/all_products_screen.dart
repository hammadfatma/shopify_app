import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify_app/screens/product_details_screen.dart';
import 'package:shopify_app/utils/constants.dart';
import '../providers/products_provider.dart';
import '../widgets/products_card_widget.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key, required this.categoryId});
  final String categoryId;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            children: [
              Center(
                child: Text(
                  'Products',
                  style: kHeadLineStyle,
                ),
              ),
            ],
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
                      return const Text('Error While Get Data');
                    } else if (snapshot.hasData) {
                      final filteredProducts = snapshot.data!
                          .where((product) => product.categoryId == categoryId)
                          .toList();
                      if (filteredProducts.isNotEmpty) {
                        return SizedBox(
                          height: 666,
                          width: MediaQuery.of(context).size.width*0.55,
                          child: FlexibleGridView(
                              axisCount: GridLayoutEnum.twoElementsInRow,
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
                                  .toList()),
                        );
                      } else {
                        return const Center(
                          child: Text('No Product Found'),
                        );
                      }
                    } else {
                      return const Text('No Data Found');
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
    );
  }
}
