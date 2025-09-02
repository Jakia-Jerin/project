class CategoryModel {
  final String id;
  final String title;
  final String handle;
  final String description;
  final CategoryImage? imageUrl;
//  final String? imageUrl;
  final String coverUrl;
  final String? parent;

  CategoryModel({
    required this.id,
    required this.title,
    required this.handle,
    required this.description,
    required this.imageUrl,
    required this.coverUrl,
    this.parent,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? '',
      //id: json['id'] ?? '',
      title: json['title'] ?? '',
      handle: json['slug'] ?? '',
      description: json['description'] ?? '',
      imageUrl:
          json['image'] != null ? CategoryImage.fromJson(json['image']) : null,
      // imageUrl: json['image'] != null ? json['image']['imageName'] : null,
      //  imageUrl: json['image'],
      coverUrl: json['cover'] ?? '',
      parent: json['parent'] ?? '',
    );
  }
}





class CategoryImage {
  final String id;
  final String imageName;

  CategoryImage({required this.id, required this.imageName});

  factory CategoryImage.fromJson(Map<String, dynamic> json) {
    return CategoryImage(
      id: json['_id'],
      imageName: json['imageName'],
    );
  }
}
