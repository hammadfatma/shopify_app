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

  Future<ProductsModel?> getProductsById({required String productId}) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> productsSnapshot;
      productsSnapshot = await FirebaseFirestore.instance
          .collection(CollectionsUtils.products.name)
          .doc(productId)
          .get();
      if (productsSnapshot.exists) {
        return ProductsModel(
            id: productsSnapshot.id,
            categoryId: productsSnapshot.get('categoryId'),
            colors: productsSnapshot.get('colors') != null
                ? List<String>.from(
                    productsSnapshot.get('colors').map((e) => e))
                : [],
            sizes: productsSnapshot.get('sizes') != null
                ? List<String>.from(productsSnapshot.get('sizes').map((e) => e))
                : [],
            name: productsSnapshot.get('name'),
            image: productsSnapshot.get('image'),
            price: productsSnapshot.get('price') is int
                ? (productsSnapshot.get('price') as int).toDouble()
                : productsSnapshot.get('price'));
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error : $e');
      return null;
    }
  }
}
