import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shopify_app/models/cart_model.dart';
import 'package:shopify_app/models/products_model.dart';

class CartProvider {
  CartItem? cartItem;
  List<ProductsModel> products = [];

  double _total = 0;

  ValueNotifier<double> totalNotifier = ValueNotifier(0);

  void onAddProductToList(ProductsModel product, CartModel cart) {
    var index = products.indexWhere((element) => (element.id == product.id));
    if (index == -1) {
      products.add(product);
    }
  }

  // this function that used instead of previous when i need also check quantity of product in it
  // Future<void> onAddProductToList(BuildContext context,ProductsModel product, CartModel cart) async {
  //   var index = products.indexWhere((element) => (element.id == product.id));
  //   int productQuantity = product.quantity ?? 0;
  //   if (cart.items != null) {
  //     for (var item in cart.items!) {
  //       if (item.productId == product.id) {
  //         productQuantity -= item.quantity ?? 0;
  //         break;
  //       }
  //     }
  //   }
  //   if (productQuantity>0) {
  //     if (index == -1) {
  //       products.add(product);
  //     }
  //   }else{
  //     if (context.mounted) {
  //       await QuickAlert.show(
  //         context: context,
  //         type: QuickAlertType.error,
  //         title: 'Oops...',
  //         text: 'Sorry, this product is out of stock.',
  //       );
  //     }
  //   }
  // }

  void calculateTotal(CartModel cart) {
    _total = 0;
    for (var item in cart.items!) {
      if (products.isEmpty) return;
      var product =
          products.where((product) => product.id == item.productId).firstOrNull;

      if (product != null) {
        _total += ((product.price) * (item.quantity ?? 0)).round();
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      totalNotifier.value = _total;
    });
  }

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
        if (context.mounted) {
          QuickAlert.show(context: context, type: QuickAlertType.loading);
          cart.items?.removeWhere((element) => element.itemId == itemId);
          await FirebaseFirestore.instance
              .collection('carts')
              .doc(FirebaseAuth.instance.currentUser?.email ?? '')
              .update(cart.toJson());
          if (context.mounted) {
            Navigator.pop(context);
            calculateTotal(cart); //update total after remove item
            await QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: 'Product Removed Successfully',
            );
          }
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

  void onIncreaseItemQuantity(
      {required BuildContext context,
      required String itemId,
      required CartModel cart}) async {
    try {
      if (context.mounted) {
        QuickAlert.show(context: context, type: QuickAlertType.loading);
        var updatedItem =
            cart.items?.firstWhere((element) => element.itemId == itemId);
        var index = cart.items?.indexOf(updatedItem!);
        cart.items?.removeWhere((element) => element.itemId == itemId);
        updatedItem!.quantity = (updatedItem.quantity ?? 0) + 1;
        cart.items?.insert(index!, updatedItem);
        await FirebaseFirestore.instance
            .collection('carts')
            .doc(FirebaseAuth.instance.currentUser?.email ?? '')
            .update(cart.toJson())
            .then((value) => Navigator.pop(context));
        calculateTotal(cart); //update total after increase quantity of item
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

  void onDecreaseItemQuantity(
      {required BuildContext context,
      required String itemId,
      required CartModel cart}) async {
    try {
      if (context.mounted) {
        var updatedItem =
            cart.items?.firstWhere((element) => element.itemId == itemId);
        var index = cart.items?.indexOf(updatedItem!);
        if (updatedItem?.quantity == 1) {
          onRemoveItemFromCart(context: context, itemId: itemId, cart: cart);
          return; // this point to give order to exit from code after do function
        }
        QuickAlert.show(context: context, type: QuickAlertType.loading);
        cart.items?.removeWhere((element) => element.itemId == itemId);
        updatedItem!.quantity = (updatedItem.quantity ?? 0) - 1;
        cart.items?.insert(index!, updatedItem);
        await FirebaseFirestore.instance
            .collection('carts')
            .doc(FirebaseAuth.instance.currentUser?.email ?? '')
            .update(cart.toJson())
            .then((value) => Navigator.pop(context));
        calculateTotal(cart); //update total after decrease quantity of item
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
          if (cartItem?.productId == item.productId &&
              (cartItem?.valueSize ?? 'Nothing') ==
                  (item.valueSize ?? 'Nothing') &&
              (cartItem?.selectColor ?? 'Nothing') ==
                  (item.selectColor ?? 'Nothing')) {
            isEqual = true;
            updatedItemId = item.itemId;
            break;
          }
        }
        if (isEqual && updatedItemId != null) {
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
