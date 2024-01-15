class ProfileModel {
  String? imageUrl;
  String? name;
  String? phone;

  ProfileModel();
  ProfileModel.fromJson(Map<String, dynamic> data) {
    imageUrl = data['imageUrl'];
    name = data['name'];
    phone = data['phone'];
  }
  Map<String, dynamic> toJson() => {
    'imageUrl': imageUrl,
    'name': name,
    'phone': phone,
  };
}