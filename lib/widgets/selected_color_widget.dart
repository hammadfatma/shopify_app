import 'package:flutter/material.dart';
import 'package:shopify_app/models/products_model.dart';

class SelectedColor extends StatefulWidget {
  const SelectedColor({super.key, required this.productsModel, required this.selectedColorCallBack});
  final ProductsModel productsModel;
  final Function(Color) selectedColorCallBack;
  @override
  State<SelectedColor> createState() => _SelectedColorState();
}

class _SelectedColorState extends State<SelectedColor> {
  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    List<Color> colorsList = widget.productsModel.colors?.map((e) => Color(int.parse(e))).toList()??[];
    return SizedBox(
      height: 39,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: colorsList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if(selectedIndex == index){
                  selectedIndex = 0;
                }else{
                  selectedIndex = index;
                }
                widget.selectedColorCallBack.call(colorsList[selectedIndex]);
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 22),
                child: Container(
                  width: 39,
                  height: 39,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19),
                    color: colorsList[index],
                  ),
                  child: Center(
                    child: selectedIndex == index ? Icon(Icons.check,color: Colors.white,): null,
                  ),
                ),
              ),
            );
          }),
    );
  }
}