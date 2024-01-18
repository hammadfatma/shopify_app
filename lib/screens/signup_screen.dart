import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import '../widgets/custom_button_icon.dart';
import '../widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
                  const SizedBox(
                    height: 15,
                  ),
                  CustomButtonWidget(
                    txt: 'SIGN UP',
                    onTap: () async {
                      await value.signUp(context);
                    }, width: 330,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: 231,
                    height: 34,
                    child: RichText(
                      text: const TextSpan(
                        text: 'By creating an account, you agree to our ',
                        style: kStyle1,
                        children: [
                          TextSpan(
                            text: 'Terms of Service',
                            style: kStyle2,
                          ),
                          TextSpan(
                            text: ' and ',
                            style: kStyle1,
                          ),
                          TextSpan(
                            text: 'Privacy Policy',
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