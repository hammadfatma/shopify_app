class ProductsModel {
  final String? id;
  final String name;
  final double price;
  final String image;
  final List<String>? colors;
  final List<String>? sizes;
  // final int quantity;
  final String? categoryId;
  // final String description;

  ProductsModel({this.id,
    this.categoryId,
    this.colors,
    this.sizes,
    required this.name,
    required this.price,
    required this.image});
// required this.description,
// required this.quantity});
}
