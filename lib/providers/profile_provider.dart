import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopify_app/models/profile_model.dart';

class ProfileProvider {
  ProfileModel? profileData;
  Stream<
      DocumentSnapshot<
          Map<String, dynamic>>> get profileStream => FirebaseFirestore.instance
      .collection('profiles')
      .doc(FirebaseAuth.instance.currentUser?.email ?? '')
      .snapshots(); // by opening this stream We can do without notify listener
  void createProfileInstance() {
    profileData = ProfileModel();
  }

  void saveDataToProfile({required BuildContext context}) async {
    try {
      QuickAlert.show(context: context, type: QuickAlertType.loading);
      var result = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(FirebaseAuth.instance.currentUser?.email ?? '')
          .get();
      var existingData = result.data() ?? {};

      if (profileData?.imageUrl != '') {
        existingData['imageUrl'] = profileData?.imageUrl;
      } else {
        existingData['imageUrl'] = result.data()?['imageUrl'];
      }

      if (profileData?.name != '') {
        existingData['name'] = profileData?.name;
      } else {
        existingData['name'] = result.data()?['name'];
      }

      if (profileData?.phone != '') {
        existingData['phone'] = profileData?.phone;
      } else {
        existingData['phone'] = result.data()?['phone'];
      }

      if (result.exists) {
        await FirebaseFirestore.instance
            .collection('profiles')
            .doc(FirebaseAuth.instance.currentUser?.email ?? '')
            .update(existingData); // update all data in profile
      } else {
        await FirebaseFirestore.instance
            .collection('profiles')
            .doc(FirebaseAuth.instance.currentUser?.email ?? '')
            .set(existingData);
      }
      if (context.mounted) {
        Navigator.pop(context);
        await QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                title: 'Data Saved Successfully')
            .then((value) => Navigator.pop(context));
      }
    } catch (e) {
      if (context.mounted) {
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: e.toString(),
        );
      }
    }
  }

  Future<ProfileModel?> getDataFromProfile() async {
    try {
      DocumentSnapshot<Map<String, dynamic>>? result;

      result = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(FirebaseAuth.instance.currentUser?.email ?? '')
          .get();

      if (result.exists) {
        return ProfileModel.fromJson(result.data() ?? {});
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
