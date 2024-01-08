import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify_app/screens/cart_screen.dart';
import 'package:shopify_app/utils/constants.dart';

import '../providers/cart_provider.dart';

class IconBadgeWidget extends StatelessWidget {
  const IconBadgeWidget(
      {super.key, required this.txt, required this.con, required this.fl});
  final String txt;
  final IconData con;
  final bool fl;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));
          },
          icon: Transform.flip(
            flipX: fl,
            child: Icon(
              con,
              color: Color(0xff727c8e),
              size: 20,
            ),
          ),
        ),
        Positioned(
          bottom: 6,
          child: StreamBuilder(
              stream: Provider.of<CartProvider>(context).cartStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  int quantity = 0;
                  // deal item as Map<String, dynamic> not as object
                  for (Map<String, dynamic> item
                      in snapshot.data?.data()?['items']) {
                    quantity = quantity + (item['quantity'] as int);
                  } // first data meaning to document , second data meaning to what searching in items list
                  return Badge(
                    smallSize: 15,
                    backgroundColor: kPrimaryColor,
                    label: Text(
                      '$quantity',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
        ),
      ],
    );
  }
}
