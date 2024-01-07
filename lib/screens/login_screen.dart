import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify_app/utils/constants.dart';
import 'package:shopify_app/widgets/custom_button_icon.dart';
import 'package:shopify_app/widgets/custom_text_field.dart';

import '../providers/auth_provider.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  @override
  void initState() {
    Provider.of<AuthProviderApp>(context, listen: false).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProviderApp>(builder: (context, value, child) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Form(
            key: value.formKey,
            child: Center(
              child: Column(
                children: [
                  CustomTxtFieldWidget(
                      isFirst: true,
                      isLast: false,
                      txt: 'EMAIL',
                      con: Icons.email_outlined,
                      inputType: TextInputType.emailAddress,
                      onValidated: (value) {
                        if (value == null || value == '') {
                          return 'Email is required';
                        } else if (!value.split('@').last.contains('gmail')) {
                          return 'Enter Valid Gmail';
                        }
                        return null;
                      },
                      controller: value.emailController!),
                  CustomTxtFieldWidget(
                      isFirst: false,
                      isLast: true,
                      txt: 'PASSWORD',
                      inputType: TextInputType.visiblePassword,
                      onValidated: (value) {
                        if (value == null || value == '') {
                          return 'password is required';
                        }
                        if (value.length < 8) {
                          return 'Password length must be 8';
                        }
                        return null;
                      },
                      con: value.obscureText
                          ? Icons.lock_outline
                          : Icons.lock_open_outlined,
                      onTap: value.toggleObscure,
                      obstxt: value.obscureText,
                      controller: value.passController!),
                  SizedBox(
                    height: 15,
                  ),
                  CustomButtonWidget(
                    txt: 'LOG IN',
                    onTap: () async {
                      await value.logIn(context);
                    }, width: 330,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: 231,
                    height: 34,
                    child: RichText(
                      text: TextSpan(
                        text: 'Don’t have an account? Swipe left to ',
                        style: kStyle1,
                        children: [
                          TextSpan(
                            text: 'create a new account.',
                            style: kStyle2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
