import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shopify_app/models/cart_model.dart';

class CartProvider {
  CartItem? cartItem;
  void createItemInstance() {
    cartItem = CartItem();
  }

  Stream<
      DocumentSnapshot<
          Map<String, dynamic>>> get cartStream => FirebaseFirestore.instance
      .collection('carts')
      .doc(FirebaseAuth.instance.currentUser?.email ?? '')
      .snapshots(); // by opening this stream We can do without notify listener

  // we can update not remove array 'items'
  void onRemoveItemFromCart(
      {required BuildContext context,
      required String itemId,
      required CartModel cart}) async {
    try {
      var result = await QuickAlert.show(
          context: context,
          type: QuickAlertType.confirm,
          onConfirmBtnTap: () => Navigator.pop(context, true));
      if (result ?? false) {
        cart.items?.removeWhere((element) => element.itemId == itemId);
        await FirebaseFirestore.instance
            .collection('carts')
            .doc(FirebaseAuth.instance.currentUser?.email ?? '')
            .update(cart.toJson());
        if (context.mounted) {
          Navigator.pop(context);
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Product Removed Successfully',
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: 'Sorry, something went wrong',
        );
      }
    }
  }

  void onAddItemToCart({required BuildContext context}) async {
    try {
      bool isEqual = false;
      int counter = 0;
      String? updatedItemId;
      QuickAlert.show(context: context, type: QuickAlertType.loading);
      var result = await FirebaseFirestore.instance
          .collection('carts')
          .doc(FirebaseAuth.instance.currentUser?.email ?? '')
          .get();
      if (result.exists) {
        var fireBaseCartItems =
            CartModel.fromJson(result.data() ?? {}); // all items of cart
        for (var item in fireBaseCartItems.items ?? []) {
          if (cartItem?.productId != item.productId) {
            break; // this is meaning new product
          }
          if (cartItem?.selectColor != item.selectColor) {
            break; // different color
          }
          if (cartItem?.selectSize != item.selectSize) break; // different size
          isEqual = false;
          counter = 0; // to go initial state
          if (cartItem?.selectColor == item.selectColor &&
              cartItem?.selectSize == item.selectSize) {
            counter++;
          } // this is meaning same product
          if (counter == 1) {
            isEqual = true;
            updatedItemId = item?.itemId; // to know any item updated 'quantity'
            break; // to avoid repeat check circle
          } else {
            isEqual = false;
          }
        }
        if (isEqual == true && updatedItemId != null) {
          var updatedItem = fireBaseCartItems.items?.firstWhere((element) =>
              element.itemId == updatedItemId); // to get updated item
          fireBaseCartItems.items?.removeWhere(
              (element) => element.itemId == updatedItemId); // remove old item
          updatedItem?.quantity = (updatedItem.quantity ?? 0) +
              (cartItem?.quantity ?? 0); // updated quantity to newest value
          fireBaseCartItems.items
              ?.add(updatedItem!); // add updatedItem to list of items
          await FirebaseFirestore.instance
              .collection('carts')
              .doc(FirebaseAuth.instance.currentUser?.email ?? '')
              .update(fireBaseCartItems.toJson()); // update all items in cart
        } else {
          await FirebaseFirestore.instance
              .collection('carts')
              .doc(FirebaseAuth.instance.currentUser?.email ?? '')
              .update({
            'items': FieldValue.arrayUnion([cartItem?.toJson()])
          });
        }
      } else {
        await FirebaseFirestore.instance
            .collection('carts')
            .doc(FirebaseAuth.instance.currentUser?.email ?? '')
            .set({
          'items': [cartItem?.toJson()]
        });
      }
      if (context.mounted) {
        Navigator.pop(context);
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Product Added Successfully',
        ).then((value) => Navigator.pop(context));
      }
    } catch (e) {
      if (context.mounted) {
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: 'Sorry, something went wrong',
        );
      }
      debugPrint('Error : $e');
      return null;
    }
  }
}
