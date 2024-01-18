import 'package:flutter/material.dart';
import 'package:shopify_app/screens/all_orders_screen.dart';
import 'package:shopify_app/widgets/custom_appbar_widget.dart';
import 'package:shopify_app/widgets/custom_button_icon.dart';

import '../utils/constants.dart';

class OrderPlacedScreen extends StatelessWidget {
  const OrderPlacedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackColor,
      appBar: const CustomAppBarWidget(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 101,
                height: 101,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(51),
                  color: kWhiteColor,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 40,
                  color: kPrimaryColor,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Order Placed!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                  color: kSecondaryColor,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: SizedBox(
                width: 252,
                height: 65,
                child: Text(
                  'Your order was placed successfully, For more details, check All My Orders page under',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: kSecondaryColor,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButtonWidget(
                  txt: 'MY ORDERS',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyOrdersScreen()));
                  },
                  width: 165),
            ),
          ],
        ),
      ),
    );
  }
}
