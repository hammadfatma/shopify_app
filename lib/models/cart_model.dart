class CartModel {
  List<CartItem>? items;
  CartModel();
  CartModel.fromJson(Map<String, dynamic> data) {
    items = data['items'] != null
        ? List.from(data['items'].map((e) => CartItem.fromJson(e)))
        : null;
  }
  Map<String, dynamic> toJson() => {
        'items': items?.map((e) => e.toJson())
      }; // special to my orders screen to show every items
}

class CartItem {
  String? itemId; // to know any item should updated
  String? selectColor;
  String? valueSize;
  String? productId;
  int? quantity;
  CartItem();
  CartItem.fromJson(Map<String, dynamic> data) {
    itemId = data['itemId'];
    selectColor = data['selectColor'];
    valueSize = data['valueSize'];
    productId = data['productId'];
    quantity = data['quantity'];
  }
  Map<String, dynamic> toJson() => {
        'itemId': itemId,
        'selectColor': selectColor ?? 'Nothing',
        'valueSize': valueSize ?? 'Nothing',
        'productId': productId,
        'quantity': quantity
      };
}
