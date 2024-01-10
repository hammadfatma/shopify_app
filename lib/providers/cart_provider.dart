import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shopify_app/models/cart_model.dart';
import 'package:shopify_app/models/products_model.dart';

class CartProvider {
  CartItem? cartItem;
  double total = 0;
  List<ProductsModel> products = []; // contains all products in items in cart
  ValueNotifier<double> totalNotifier =
      ValueNotifier(0); // object given to valueNotifierListener
  void onAddProductToList(ProductsModel product, CartModel cart) {
    var index = products.indexWhere(
        (element) => element.id == product.id); // indexWhere deals with object
    //
    if (index == -1) {
      //-1 means this product not found in list
      products.add(product);
    }
  }

  void calculateTotal(CartModel cart) {
    total = 0;
    for (var item in cart.items!) {
      if (products.isEmpty) return; // exits from function
      var product =
          products.firstWhere((product) => product.id == item.productId);
      total += ((product.price) * (item.quantity ?? 0))
          .round(); // calculate total price to all items in cart
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      totalNotifier.value = total; // listen every change of total value
    }); // we need another frame to appear total price
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
          if (cartItem?.selectSize != item.selectSize) {
            break;
          } // different size
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
