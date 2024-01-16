import 'package:flutter/material.dart';

class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget(
      {super.key,
      required this.imagePath,
      required this.nameTxt,
      required this.typeTxt,
      required this.priceTxt,
      required this.quantity});
  final String imagePath;
  final String nameTxt, typeTxt;
  final String priceTxt;
  final String quantity;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Color(0xffe7eaf0),
                offset: Offset(0, 10),
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Image.network(
              imagePath,
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
                  nameTxt,
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
                  typeTxt,
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
                    '\$$priceTxt',
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
                  Text(
                    quantity,
                    style: TextStyle(fontSize: 15, color: Color(0xff727c8e)),
                  ),
                ],
              ),
              SizedBox(
                width: 222,
                child: Divider(),
              ),
            ],
          ),
        )
      ],
    );
  }
}
