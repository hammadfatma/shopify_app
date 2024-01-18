import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order_tracker_zen/order_tracker_zen.dart';
import 'package:shopify_app/utils/constants.dart';

class OrderTrackerScreen extends StatefulWidget {
  const OrderTrackerScreen({super.key});

  @override
  State<OrderTrackerScreen> createState() => _OrderTrackerScreenState();
}

class _OrderTrackerScreenState extends State<OrderTrackerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text('Order Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: OrderTrackerZen(
          success_color: kPrimaryColor,
          background_color: kSecondaryColor,
          tracker_data: [
            TrackerData(
              title: "Order Placed",
              date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
              tracker_details: [
                TrackerDetails(
                  title: "Your order has been placed",
                  datetime: DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now()),
                ),
                TrackerDetails(
                  title: "Seller ha processed your order",
                  datetime: DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now().add(const Duration(days: 1, hours: 1))),
                ),
                TrackerDetails(
                  title: "Your item has been picked up by courier partner.",
                  datetime: DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now().add(const Duration(days: 2, hours: 2))),
                ),
              ],
            ),
            TrackerData(
              title: "Shipped",
              date: DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 3))),
              tracker_details: [
                TrackerDetails(
                  title: "Your order has been shipped",
                  datetime: DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now().add(const Duration(days: 3, hours: 3))),
                ),
                TrackerDetails(
                  title: "Your item has been received in the nearest hub to you.",
                  datetime: '',
                ),
              ],
            ),
            TrackerData(
              title: "Out of delivery",
              date: DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 4))),
              tracker_details: [
                TrackerDetails(
                  title: "Your order is out for delivery",
                  datetime: DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now().add(const Duration(days: 4, hours: 4))),
                ),
              ],
            ),
            TrackerData(
              title: "Delivered",
              date: DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 5))),
              tracker_details: [
                TrackerDetails(
                  title: "Your order has been delivered",
                  datetime: DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now().add(const Duration(days: 5, hours: 5))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
