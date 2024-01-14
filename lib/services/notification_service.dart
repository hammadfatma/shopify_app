import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shopify_app/firebase_options.dart';

import '../utils/constants.dart';

class NotificationService {
  static FirebaseMessaging?
      fcm; // to take token of mobile and check states of app(foreground, background , background or killed)
  static bool _isInitalised = false;
  static bool _isTokeninit = false;
  static int _tries = 0;
  static Future init() async {
    if (_isInitalised) {
      await _sendToken();
      return;
    }
    fcm = FirebaseMessaging.instance;
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // Foreground Notification
      handleOnNotificationReceived(message, isForeground: true);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      // App Background Not killed Notification
      handleOnNotificationReceived(message);
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    try {
      await _sendToken();
      _isInitalised = true;
    } catch (e) {
      debugPrint(
          '===Exception while doing operations in push notification init${e.toString()}===');
      _isInitalised = true;
      if (_tries <= 20) {
        init();
        _tries++;
      }
    }
  }

  // used when the user logout call this
  // used because when user logout then login
  // that firebase maybe don't make token Although he is a new user
  static void onPushNotificationClosed() {
    _isTokeninit = false;
  }

  // send userToken to firestore note that token only toke for auth person
  static Future<void> _sendToken() async {
    if (_isTokeninit) return;
    var userToken = await fcm?.getToken();
    await FirebaseFirestore.instance
        .collection('tokens')
        .doc(FirebaseAuth.instance.currentUser?.email)
        .set({"token": userToken});
    // end of update user data
    debugPrint('===== New Token : $userToken =====');
    _isTokeninit = true;
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    debugPrint('A bg message just showed up :  ${message.messageId}');
  }

  //trigger when foreground , background or killed when notification received
  //handle background or killed but as foreground i handle what happend
  static void handleOnNotificationReceived(RemoteMessage message,
      {bool isForeground = false}) async {
    RemoteNotification? notification = message.notification;
    var payLoad;
    debugPrint(
        '====== notification received ${message.data['payload']} ======');
    if (message.data['payLoad'] != null) {
      payLoad = jsonDecode(message.data['payLoad']); // payload come as string
      try {
        switch (payLoad["type"].toString()) {}
      } catch (e) {
        debugPrint('error $e');
      }
    }
    if (notification != null) {
      //local notification or overlay widget
      // show widget to appear notification
      if (isForeground) {
        showSimpleNotification(Text('${message.notification?.title}'),
            subtitle: Text('${message.notification?.body}'),
            background: kPrimaryColor);
      }
    }
  }

  // call when i click on notification It will only be achieved when foreground and what make is in isForeground but if background or killed open app by default
  static void handleOnNotificationClicked(dynamic payLoad) async {
    try {
      switch (payLoad["type"].toString()) {}
    } catch (e) {
      debugPrint('error $e');
    }
  }

  // call this in splash screen
  // when open app from notification
  static void checkNotificationOnKilledApp() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      handleOnNotificationReceived(message);
    }
  }
}
