class CategoriesModel {
  final String? id;
  final String title;
  final String backColor1;
  final String backColor2;
  final String? imagePath;
  final String shadowColor;

  // final String description;

  CategoriesModel({this.id,
    required this.title,
    this.imagePath,
    required this.shadowColor,
    required this.backColor1,
    required this.backColor2});
}