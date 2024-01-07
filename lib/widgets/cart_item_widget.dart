import 'package:flutter/material.dart';
import 'package:shopify_app/utils/constants.dart';

class CartItemWidget extends StatefulWidget {
  const CartItemWidget(
      {super.key,
      required this.imagePath,
      required this.nameTxt,
      required this.typeTxt,
      required this.priceTxt});
  final String imagePath;
  final String nameTxt, typeTxt;
  final double priceTxt;

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  int value = 1;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 666,
          height: 111,
          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
          padding: EdgeInsets.only(left: 8, right: 8),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    kShadow1,
                  ],
                ),
                child: Center(
                  child: Image.network(
                    widget.imagePath,
                    width: 65,
                    height: 59,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.nameTxt,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Color(0xff515c6f),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.typeTxt,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                          color: Color(0xff515c6f),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '\$${widget.priceTxt.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Color(0xffff6969),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              value--;
                            });
                          },
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Color(0xff727c8e).withOpacity(0.200),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.remove,
                                size: 10,
                                color: Color(0xff727c8e),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '${value}',
                            style: TextStyle(
                                fontSize: 15, color: Color(0xff727c8e)),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              value++;
                            });
                          },
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Color(0xff727c8e).withOpacity(0.200),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                size: 10,
                                color: Color(0xff727c8e),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   width: 222,
                    //   child: Divider(),
                    // ),
                  ],
                ),
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 10, top: 8),
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: 20,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}