import 'package:flutter/material.dart';
import 'package:shopify_app/utils/constants.dart';

// ignore: must_be_immutable
class CustomTxtFieldWidget extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final String txt;
  final IconData con;
  bool? obstxt;
  TextInputType? inputType;
  VoidCallback? onTap;
  String? Function(String?)? onValidated;
  final TextEditingController controller;
  CustomTxtFieldWidget(
      {super.key,
      required this.isFirst,
      required this.isLast,
      required this.txt,
      required this.con,
      this.obstxt,
        this.inputType,
      this.onTap,
      required this.controller, this.onValidated});

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius;
    BoxShadow? boxShadow;
    if (isFirst == true && isLast == true) {
      borderRadius = BorderRadius.circular(10);
      boxShadow = kShadow1;
    } else if (isFirst == true) {
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      );
      boxShadow = kShadow1;
    } else if (isLast == true) {
      borderRadius = BorderRadius.only(
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      );
      boxShadow = kShadow1;
    } else {
      borderRadius = BorderRadius.zero;
      boxShadow = null;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: 325,
      height: 59,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: Color(0xffffffff),
        boxShadow: boxShadow != null ? [boxShadow] : null,
      ),
      child: TextFormField(
        validator: onValidated,
        keyboardType: inputType,
        cursorColor: kPrimaryColor,
        obscureText: obstxt ?? false,
        obscuringCharacter: '*',
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: InkWell(
            onTap: onTap,
            child: Icon(
              con,
              size: 20,
              color: Color(
                0xff727c8e,
              ),
            ),
          ),
          label: Text(
            txt,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
              color: kSecondaryColor.withOpacity(0.502),
            ),
          ),
        ),
      ),
    );
  }
}
