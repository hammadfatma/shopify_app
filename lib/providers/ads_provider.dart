import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/ads_model.dart';
import 'package:quickalert/quickalert.dart';

import '../utils/collections.dart';
class AdsProvider{
  List<AdvertisementsModel> ads = [];
  Future<List<AdvertisementsModel>> getAdvertisements(BuildContext context) async {
    try {
      final adsSnapshot = await FirebaseFirestore.instance
          .collection(CollectionsUtils.ads.name)
          .get();
      ads = adsSnapshot.docs.map((e) {
        return AdvertisementsModel(
            title: e.get('title'), imageURL: e.get('imageURL'), id: e.id);
      }).toList();
      return ads;
    } catch (e) {
      if (context.mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: 'Sorry, something went wrong',
        );
      }
      debugPrint('Error : $e');
      return[];
    }
  }
}