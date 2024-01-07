import 'package:flutter/material.dart';
import 'package:shopify_app/utils/constants.dart';

import '../models/products_model.dart';

class SelectedSize extends StatefulWidget {
  const SelectedSize({super.key, required this.productsModel, required this.selectedSizeCallBack});
  final ProductsModel productsModel;
  final Function(String) selectedSizeCallBack;
  @override
  State<SelectedSize> createState() => _SelectedColorState();
}

class _SelectedColorState extends State<SelectedSize> {
  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    List<String> sizesList = widget.productsModel.sizes?.map((e) => e).toList()??[];
    return SizedBox(
      height: 39,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: sizesList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (selectedIndex == index) {
                  selectedIndex = 0;
                } else {
                  selectedIndex = index;
                }
                widget.selectedSizeCallBack.call(sizesList[selectedIndex]);
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  width: 72,
                  height: 39,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kWhiteColor,
                  ),
                  child: Center(
                    child: Text(
                      sizesList[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: selectedIndex == index
                              ? Color(0xffff6969)
                              : Color(0xff727c8e),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}