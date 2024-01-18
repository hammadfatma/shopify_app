import 'package:flutter/material.dart';
import 'package:shopify_app/utils/constants.dart';

class CustomButtonWidget extends StatelessWidget {
  final String txt;
  final double width;
  final VoidCallback onTap;
  const CustomButtonWidget(
      {super.key, required this.txt, required this.onTap, required this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 46,
        decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(23),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(255, 105, 105, 0.4),
                offset: Offset(0, 10),
                blurRadius: 5,
                spreadRadius: 2,
              )
            ]),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Center(
                  child: Text(
                    txt,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
                Container(
                  width: 29,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: const Color(0xffffffff),
                  ),
                  child: const Icon(Icons.arrow_forward_ios_outlined,
                      size: 15, color: kPrimaryColor),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
