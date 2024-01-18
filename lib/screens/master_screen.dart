import 'package:flutter/material.dart';
import 'package:shopify_app/screens/forgot_password_screen.dart';
import 'package:shopify_app/screens/login_screen.dart';
import 'package:shopify_app/screens/signup_screen.dart';

import '../utils/constants.dart';

class MasterScreen extends StatelessWidget {
  const MasterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: kBackColor,
        body: Column(
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context)
                    .colorScheme
                    .copyWith(surfaceVariant: Colors.transparent),
              ),
              child: SizedBox(
                height: 100,
                child: TabBar(
                  isScrollable: true,
                  unselectedLabelColor: kSecondaryColor.withOpacity(0.200),
                  labelColor: kSecondaryColor,
                  indicator: const BoxDecoration(),
                  tabs: const [
                    Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Forgot Password',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  LogInScreen(),
                  SignUpScreen(),
                  ForgotPasswordScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}