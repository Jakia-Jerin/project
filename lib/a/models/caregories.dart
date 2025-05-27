class CategoryModel {
  final String id;
  final String title;
  final String handle;
  final String description;
  final String imageUrl;
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
      id: json['id'],
      title: json['title'],
      handle: json['handle'],
      description: json['description'],
      imageUrl: json['image'],
      coverUrl: json['cover'],
      parent: json['parent'],
    );
  }
}
