import 'package:flutter/material.dart';
import 'package:shopify_app/screens/all_categories_screen.dart';

import '../models/categories_model.dart';
import 'categories_circle_widget.dart';

class RowCategoriesWidget extends StatelessWidget {
  const RowCategoriesWidget({super.key, required this.categories});
  final List<CategoriesModel> categories;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...categories.map(
          (item) => CategoriesCircleWidget(
            category: item,
          ),
        ),
        CategoriesCircleWidget(
          category: CategoriesModel(
              title: 'See All',
              backColor1: '0xffffffff',
              backColor2: '0xffffffff',
              imagePath: 'null',
              shadowColor: '0xffe7eaf0'),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AllCategoriesScreen()));
          },
        ),
      ],
    );
  }
}
