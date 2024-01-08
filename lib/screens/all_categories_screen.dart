import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify_app/screens/all_products_screen.dart';
import 'package:shopify_app/utils/constants.dart';
import 'package:shopify_app/widgets/categories_circle_widget.dart';
import 'package:shopify_app/widgets/custom_appbar_widget.dart';

import '../providers/categories_provider.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackColor,
      appBar: const CustomAppBarWidget(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'All Categories',
                style: kHeadLineStyle,
              ),
            ),
          ),
          Consumer<CategoriesProvider>(
            builder: (context, value, child) {
              return FutureBuilder(
                future: value.getCategories(context, limit: null),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text('Error While Get Data');
                    } else if (snapshot.hasData) {
                      return SizedBox(
                        height: 500,
                        child: GridView.builder(
                          itemCount: snapshot.data!.length,
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (context, index) {
                            return CategoriesCircleWidget(
                              category: snapshot.data![index],
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AllProductsScreen(
                                              categoryId:
                                                  snapshot.data![index].id!,
                                            )));
                              },
                            );
                          },
                        ),
                      );
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
    );
  }
}
