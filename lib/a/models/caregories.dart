class CategoryModel {
  final String id;
  final String title;
  final String handle;
  final String description;
  final CategoryImage? imageUrl;
//  final String? imageUrl;
  final String coverUrl;
  final String? parent;
  final List<String> children;

  CategoryModel({
    required this.id,
    required this.title,
    required this.handle,
    required this.description,
    required this.imageUrl,
    required this.coverUrl,
    this.parent,
    required this.children,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    // Featured image = first gallery image
    CategoryImage? featuredImage;
    if (json['image'] != null) {
      featuredImage = CategoryImage.fromJson(json['image']);
    } else {
      featuredImage = CategoryImage(
          id: '0', imageName: 'placeholder.jpg'); // local asset fallback
    }

    // if (json['gallery'] != null && (json['gallery'] as List).isNotEmpty) {
    //   final firstImage = json['gallery'][0];
    //   featuredImage = CategoryImage(
    //     id: firstImage['id']?.toString() ?? '',
    //     imageName: firstImage['fileName']?.toString() ?? '',
    //   );
    // } else {
    //   featuredImage = CategoryImage(
    //       id: '0', imageName: 'placeholder.jpg' // local asset image
    //       );
    // }
    return CategoryModel(
      id: json['id'] ?? json['_id'] ?? "",
      //id: json['id'] ?? '',
      title: json['title'] ?? '',
      handle: json['slug'] ?? '',
      description: json['description'] ?? '',
      imageUrl: featuredImage,

      // imageUrl:
      //     json['image'] != null ? CategoryImage.fromJson(json['image']) : null,
      // imageUrl: json['image'] != null ? json['image']['imageName'] : null,
      //  imageUrl: json['image'],
      coverUrl: json['cover'] ?? '',
      parent: json['parent'] ?? '',
      children:
          json['children'] != null ? List<String>.from(json['children']) : [],
    );
  }
}

class CategoryImage {
  final String id;
  final String imageName;

  CategoryImage({required this.id, required this.imageName});

  factory CategoryImage.fromJson(Map<String, dynamic> json) {
    return CategoryImage(
      id: json['_id']?.toString() ?? '', // backend field
      imageName: json['imageName']?.toString() ?? '', // backend field
    );
  }
}
