import 'package:flutter/material.dart';

import '../utils/constants.dart';
class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget{
  const CustomAppBarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close_outlined,
            size: 18,
            color: kPrimaryColor,
          ),
        ),
      ],
    );
  }
}
