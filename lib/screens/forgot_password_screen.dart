import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify_app/utils/constants.dart';

import '../providers/auth_provider.dart';
import '../widgets/custom_button_icon.dart';
import '../widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
                  SizedBox(
                    width: 297,
                    height: 61,
                    child: Text(
                      'Enter the email address you used to create your account and we will email you a link to reset your password',
                      textAlign: TextAlign.center,
                      style: kStyle1,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  CustomTxtFieldWidget(
                      isFirst: true,
                      isLast: true,
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
                  SizedBox(
                    height: 15,
                  ),
                  CustomButtonWidget(
                    txt: 'SEND EMAIL',
                    onTap: () async {
                      await value.resendEmail(context);
                    }, width: 330,
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
