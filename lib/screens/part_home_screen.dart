import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify_app/screens/product_details_screen.dart';
import '../providers/ads_provider.dart';
import '../providers/categories_provider.dart';
import '../providers/products_provider.dart';
import '../utils/constants.dart';
import '../widgets/carousel_slider_widget.dart';
import '../widgets/products_card_widget.dart';
import '../widgets/row_categories_widget.dart';

class PartHomeScreen extends StatelessWidget {
  const PartHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Categories',
                style: kHeadLineStyle,
              ),
            ),
            Consumer<CategoriesProvider>(
              builder: (context, value, child) {
                return FutureBuilder(
                  future: value.getCategories(context, limit: 3),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.hasError) {
                        return const Text('Error While Get Data');
                      } else if (snapshot.hasData) {
                        return RowCategoriesWidget(
                            categories: snapshot.data ?? []);
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
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Latest',
                style: kHeadLineStyle,
              ),
            ),
            Consumer<AdsProvider>(
              builder: (context, value, child) {
                return FutureBuilder(
                  future: value.getAdvertisements(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.hasError) {
                        return const Text('Error While Get Data');
                      } else if (snapshot.hasData) {
                        return CarouselSliderWidget(
                          advertisements: snapshot.data ?? [],
                        );
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
            const SizedBox(
              height: 10,
            ),
            Consumer<ProductsProvider>(
              builder: (context, value, child) {
                return FutureBuilder(
                  future: value.getProducts(context,limit: 3),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.hasError) {
                        return const Text('Error While Get Data');
                      } else if (snapshot.hasData) {
                        return FlexibleGridView(
                            axisCount: GridLayoutEnum.threeElementsInRow,
                            shrinkWrap: true,
                            children: snapshot.data
                                ?.map((item) => ProductWidget(
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
                                .toList() ??
                                []);
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
      ),
    );
  }
}
