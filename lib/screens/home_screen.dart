import 'package:flutter/material.dart';
import 'package:shopify_app/screens/part_home_screen.dart';
import 'package:shopify_app/screens/profile_screen.dart';
import 'package:shopify_app/utils/constants.dart';
import '../widgets/icon_badge_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  void onItemTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  List<Widget> widgetOptions = [
    PartHomeScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconBadgeWidget(
            txt: '7',
            con: Icons.shopping_cart_outlined,
            fl: false,
          ),
          // IconBadgeWidget(
          //   txt: '10',
          //   con: Icons.notifications_none_outlined,
          //   fl: false,
          // ),
        ],
      ),
      body: widgetOptions.elementAt(currentIndex),
      bottomNavigationBar: BottomNavigationBar(
          onTap: onItemTap,
          currentIndex: currentIndex,
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: kSecondaryColor,
          selectedIconTheme: IconThemeData(
            // color: Color(0xffff6969),
            size: 20,
          ),
          unselectedIconTheme: IconThemeData(
            // color: Color(0xff515c6f),
            size: 15,
          ),
          selectedLabelStyle: TextStyle(
            fontSize: 11,
            // color: Color(0xffff6969),
            letterSpacing: 0,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 11,
            letterSpacing: 0,
            // color: Color(0xff727c8e),
          ),
          backgroundColor: kWhiteColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_outlined,
                ),
                label: 'Profile'),
          ]),
    );
  }
}
