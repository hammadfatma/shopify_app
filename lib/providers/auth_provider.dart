import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shopify_app/services/notification_service.dart';
import '../screens/home_screen.dart';
import '../screens/splash_screen.dart';

class AuthProviderApp extends ChangeNotifier {
  bool obscureText = true;
  GlobalKey<FormState>? formKey;
  TextEditingController? emailController;
  TextEditingController? passController;
  void init() {
    formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    passController = TextEditingController();
  }

  void providerDispose() {
    emailController = null;
    passController = null;
    formKey = null;
  }

  void toggleObscure() {
    obscureText = !obscureText;
    notifyListeners();
  }

  Future<void> logIn(BuildContext context) async {
    if (formKey?.currentState?.validate() ?? false) {
      try {
        var credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController?.text ?? '',
            password: passController?.text ?? '');
        if (credential.user != null) {
          if (context.mounted) {
            await QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: 'Log In Completed Successfully!',
            );
          }
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          if (context.mounted) {
            await QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'Oops...',
              text: 'Sorry, user not found, Go to Sign Up Page',
            );
          }
        } else if (e.code == 'wrong-password') {
          if (context.mounted) {
            await QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'Oops...',
              text: 'Sorry, wrong password',
            );
          }
        } else {
          if (context.mounted) {
            await QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'Oops...',
              text:
                  'Sorry, some thing is wrong, Please check email or password',
            );
          }
        }
      }
    }
  }

  Future<void> signUp(BuildContext context) async {
    if (formKey?.currentState?.validate() ?? false) {
      try {
        var credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController?.text ?? '',
                password: passController?.text ?? '');
        if (credential.user != null) {
          if (context.mounted) {
            await QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: 'Sign Up Completed Successfully!, Go to Log In Page',
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          if (context.mounted) {
            await QuickAlert.show(
              context: context,
              type: QuickAlertType.warning,
              text: 'Email already exists',
            );
          }
        } else if (e.code == 'weak-password') {
          if (context.mounted) {
            await QuickAlert.show(
              context: context,
              type: QuickAlertType.warning,
              text: 'Weak Password',
            );
          }
        }
      }
    }
  }

  Future<void> resendEmail(BuildContext context) async {
    if (formKey?.currentState?.validate() ?? false) {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController?.text ?? '');
        if (context.mounted) {
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Resend Email Completed Successfully!',
          );
        }
      } catch (e) {
        if (context.mounted) {
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Oops...',
            text: 'Sorry, some thing is wrong, Please try again',
          );
        }
      }
    }
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    NotificationService.onPushNotificationClosed();
    if (context.mounted) {
      await QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Sign Out Completed Successfully!',
      );
    }
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SplashScreen(),
        ),
      );
    }
  }
}
