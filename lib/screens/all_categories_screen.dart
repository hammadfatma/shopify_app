import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify_app/screens/all_products_screen.dart';
import 'package:shopify_app/utils/constants.dart';
import 'package:shopify_app/widgets/categories_circle_widget.dart';
import 'package:shopify_app/widgets/custom_appbar_widget.dart';

import '../providers/categories_provider.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  String id = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackColor,
      appBar: const CustomAppBarWidget(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:8.0),
          child: Column(
            children: [
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Categories',
                          style: kHeadLineStyle,
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
                                    height: 666,
                                    width: MediaQuery.of(context).size.width*0.25,
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        return CategoriesCircleWidget(
                                          category: snapshot.data![index],
                                          onTap: () {
                                            setState(() {
                                              id = snapshot.data![index].id!;
                                            });
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
                  const SizedBox(
                    width: 10,
                  ),
                  if (id != '')
                  AllProductsScreen(categoryId: id),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
