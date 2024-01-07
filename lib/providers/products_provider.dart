import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

import '../models/products_model.dart';
import '../utils/collections.dart';

class ProductsProvider {
  List<ProductsModel> products = [];
  Future<List<ProductsModel>> getProducts(BuildContext context,
      {int? limit}) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> productsSnapshot;
      if (limit != null) {
        productsSnapshot = await FirebaseFirestore.instance
            .collection(CollectionsUtils.products.name)
            .orderBy('createdAt')
            .limit(limit)
            .get();
      } else {
        productsSnapshot = await FirebaseFirestore.instance
            .collection(CollectionsUtils.products.name)
            .orderBy('createdAt')
            .get();
      }
      products = productsSnapshot.docs.map((e) {
        return ProductsModel(
            id: e.id,
            categoryId: e.get('categoryId'),
            colors: e.get('colors') != null
                ? List<String>.from(e.get('colors').map((e) => e))
                : [],
            sizes: e.get('sizes') != null
                ? List<String>.from(e.get('sizes').map((e) => e))
                : [],
            name: e.get('name'),
            image: e.get('image'),
            price: e.get('price') is int
                ? (e.get('price') as int).toDouble()
                : e.get('price'));
      }).toList();
      return products;
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
      return [];
    }
  }
}
