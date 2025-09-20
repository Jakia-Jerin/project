import 'package:theme_desiree/a/models/caregories.dart';

class ProductModel {
  final String id;
  final String title;
  final String handle;
  final String description;
  final String? publishedAt;
  final String? createdAt;
  final String? vendor;
  final String? type;
  final CategoryModel? category;
  final List<String> tags;
  final List<String> otherMediaContents;
  final Map<String, dynamic>? priceMap;
  int get price => priceMap?['base'] ?? 0;
  int get compareAtPrice => priceMap?['compareAt'] ?? 0;
//    final Map<String, dynamic> price;
  //final int price;
  final int? priceMin;
  final int? priceMax;
  final bool available;
  final bool? priceVaries;
//  final Map<String, dynamic>? compareAtPrice;
//  final int compareAtPrice;
  final Map<String, String> details;
  final List<VariantModel> variants;
  final List<String> images;
  final String? featuredImage;
  final List<String> options;
  final List<ReviewModel> reviews;
  final String? url;

  ProductModel({
    required this.id,
    required this.title,
    required this.handle,
    required this.description,
    this.publishedAt,
    this.createdAt,
    this.vendor,
    this.type,
    required this.tags,
    required this.otherMediaContents,
    required this.priceMap,
    required this.category,
    this.priceMin,
    this.priceMax,
    required this.available,
    this.priceVaries,
//    required this.compareAtPrice,
    required this.details,
    required this.variants,
    required this.images,
    this.featuredImage,
    required this.options,
    required this.reviews,
    this.url,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      handle: json['handle']?.toString() ?? '',
      category: json["category"] != null
          ? (json["category"] is Map
              ? CategoryModel.fromJson(json["category"])
              : CategoryModel(
                  id: json["category"],
                  title: "",
                  handle: "",
                  description: '',
                  imageUrl: null,
                  coverUrl: '',
                  children: []))
          : null,
      // category: json["category"] != null
      //     ? CategoryModel.fromJson(json["category"])
      //     : null,
      description: json['description']?.toString() ?? '',
      publishedAt: json['published_at']?.toString(),
      createdAt: json['created_at']?.toString(),
      vendor: json['vendor']?.toString(),
      type: json['type']?.toString(),
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      otherMediaContents: (json['other_media_contents'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      priceMap: json['price'] != null
          ? Map<String, dynamic>.from(json['price'])
          : null,
      //  price: json['price'] ?? 0,
      priceMin: json['price_min'],
      priceMax: json['price_max'],
      available: json['available'] ?? false,
      priceVaries: json['price_varies'],
//      compareAtPrice: json['compare_at_price'] ?? 0,
      details: (json['details'] as Map?)
              ?.map((k, v) => MapEntry(k.toString(), v.toString())) ??
          {},
      variants: (json['variants'] as List<dynamic>?)
              ?.map((v) => VariantModel.fromJson(v as Map<String, dynamic>))
              .toList() ??
          [],
      images: (json['gallery'] as List?)
              ?.map((e) => e['fileName']?.toString() ?? '')
              .toList() ??
          [],
      featuredImage: (() {
        final gallery = json['gallery'] as List<dynamic>? ?? [];
        if (gallery.isEmpty) return '';
        final firstImage = gallery.firstWhere(
          (e) => e['position'] == 0,
          orElse: () => {'fileName': ''},
        );
        return firstImage['fileName']?.toString() ?? '';
      })(),
      // featuredImage: (json['gallery'] as List?)
      //         ?.firstWhere(
      //           (e) => e['position'] == 0,
      //           orElse: () => {'fileName': ''},
      //         )['fileName']
      //         ?.toString() ??
      //     '',
      // images: List<String>.from(json['gallery'] ?? []),
      // images:
      //     (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      // featuredImage: json['featured_image']?.toString(),
      options:
          (json['options'] as List?)?.map((e) => e.toString()).toList() ?? [],
      reviews: (json['reviews'] as List?)
              ?.map((r) => ReviewModel.fromJson(r))
              .toList() ??
          [],
      url: json['url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "handle": handle,
      "description": description,
      "published_at": publishedAt,
      "created_at": createdAt,
      "vendor": vendor,
      "type": type,
      "tags": tags,
      "price": price,
      "price_min": priceMin,
      "price_max": priceMax,
      "available": available,
      "price_varies": priceVaries,
      "compare_at_price": compareAtPrice,
      "details": details,
      "variants": variants.map((v) => v.toJson()).toList(),
      "images": images,
      "featured_image": featuredImage,
      "options": options,
      "reviews": reviews.map((r) => r.toJson()).toList(),
      "url": url,
    };
  }
}

class VariantModel {
  final String id;
  final String? title;
  final List<String> options;
//   final String? option1;
//   final String? option2;
//   final String? option3;
  final Map<String, dynamic> price;
// //  final int? price;
//   final int? weight;
//   final int compareAtPrice;
//   final String? inventoryManagement;
  final bool available;
//   final String? sku;
//   final bool? requiresShipping;
//   final bool? taxable;
//   final String? barcode;

  VariantModel({
    required this.id,
    this.title,
    required this.options,
    // this.option1,
    // this.option2,
    // this.option3,
    required this.price,
    // this.weight,
    // required this.compareAtPrice,
    // this.inventoryManagement,
    required this.available,
    // this.sku,
    // this.requiresShipping,
    // this.taxable,
    // this.barcode,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    print("Parsing variant: $json");
    return VariantModel(
      id: json['id'] ?? json['variantId'].toString() ?? '',
      title: json['title']?.toString() ?? json['name']?.toString(),
      //  title: json['title']?.toString(),
      options:
          json['options'] != null ? List<String>.from(json['options']) : [],
      // options:
      //     (json['options'] as List?)?.map((e) => e.toString()).toList() ?? [],
//       option1: json['option1']?.toString(),
//       option2: json['option2']?.toString(),
//       option3: json['option3']?.toString(),
      price: (json['price'] != null && json['price'] is Map<String, dynamic>)
          ? Map<String, dynamic>.from(json['price'])
          : {},
//       // price:
//       //     json['price'] != null ? Map<String, dynamic>.from(json['price']) : {},

// //     price: json['price'],
//       weight: json['weight'],
//       compareAtPrice: json['compare_at_price'] ?? 0,
//       inventoryManagement: json['inventory_management']?.toString(),
      available: json['available'] ?? false,
//       sku: json['sku']?.toString(),
//       requiresShipping: json['requires_shipping'],
//       taxable: json['taxable'],
//       barcode: json['barcode']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": title,
      "options": options,
      // "option1": option1,
      // "option2": option2,
      // "option3": option3,
      "price": price,
      // "weight": weight,
      // "compare_at_price": compareAtPrice,
      // "inventory_management": inventoryManagement,
      "available": available,
      // "sku": sku,
      // "requires_shipping": requiresShipping,
      // "taxable": taxable,
      // "barcode": barcode,
    };
  }
}

class OptionModel {
  final String? name;
  final int? position;

  OptionModel({this.name, this.position});

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      name: json['name']?.toString(),
      position: json['position'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {"name": name, "position": position};
}

class ReviewModel {
  final String? id;
  final String? name;
  final int? star;
  final String? image;
  final String? body;
  final String? time;

  ReviewModel(
      {this.id, this.name, this.star, this.image, this.body, this.time});

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      star: json['star'] ?? 0,
      image: json['image']?.toString(),
      body: json['body']?.toString(),
      time: json['time']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "star": star,
        "image": image,
        "body": body,
        "time": time,
      };
}

// class ProductModel {
//   final String id;
//   final String title;
//   final String handle;
//   final String description;
//   final String publishedAt;
//   final String createdAt;
//   final String vendor;
//   final String type;
//   final List<String> tags;
//   final int price;
//   final int priceMin;
//   final int priceMax;
//   final bool available;
//   final bool priceVaries;
//   final int compareAtPrice;
//   final Map<String, String> details;
//   final List<VariantModel> variants;
//   final List<String> images;
//   final String featuredImage;
//   final List<String> options;
//   final List<ReviewModel> reviews;
//   final String url;

//   ProductModel({
//     required this.id,
//     required this.title,
//     required this.handle,
//     required this.description,
//     required this.publishedAt,
//     required this.createdAt,
//     required this.vendor,
//     required this.type,
//     required this.tags,
//     required this.price,
//     required this.priceMin,
//     required this.priceMax,
//     required this.available,
//     required this.priceVaries,
//     required this.compareAtPrice,
//     required this.details,
//     required this.variants,
//     required this.images,
//     required this.featuredImage,
//     required this.options,
//     required this.reviews,
//     required this.url,
//   });

//   factory ProductModel.fromJson(Map<String, dynamic> json) {
//     return ProductModel(
//       id: json['id']?.toString() ?? '',
//       //id: json['id'] ?? '',
//       title: json['title'] ?? '',
//       handle: json['handle'],
//       description: json['description'],
//       publishedAt: json['published_at'],
//       createdAt: json['created_at'],
//       vendor: json['vendor'],
//       type: json['type'],
//       tags: List<String>.from(json['tags']),
//       price: json['price'],
//       priceMin: json['price_min'],
//       priceMax: json['price_max'],
//       available: json['available'],
//       priceVaries: json['price_varies'],
//       compareAtPrice: json['compare_at_price'] ?? 0,
//       details: Map<String, String>.from(json['details']),
//       variants: (json['variants'] as List)
//           .map((variant) => VariantModel.fromJson(variant))
//           .toList(),
//       images:
//           (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
//       // images: List<String>.from(json['images']),
//       featuredImage: json['featured_image'],
//       options:
//           (json['options'] as List?)?.map((e) => e.toString()).toList() ?? [],
//       //  options: List<String>.from((json['options'])),
//       reviews: (json['reviews'] as List)
//           .map((review) => ReviewModel.fromJson(review))
//           .toList(),
//       url: json['url'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "id": id,
//       "title": title,
//       "handle": handle,
//       "description": description,
//       "published_at": publishedAt,
//       "created_at": createdAt,
//       "vendor": vendor,
//       "type": type,
//       "tags": tags,
//       "price": price,
//       "price_min": priceMin,
//       "price_max": priceMax,
//       "available": available,
//       "price_varies": priceVaries,
//       "compare_at_price": compareAtPrice,
//       "details": details,
//       "variants": variants.map((variant) => variant.toJson()).toList(),
//       "images": images,
//       "featured_image": featuredImage,
//       "options": options,
//       "reviews": reviews.map((review) => review.toJson()).toList(),
//       "url": url,
//     };
//   }
// }

// // ---------------------------------
// // Variant Model
// // ---------------------------------

// class VariantModel {
//   final String id;
//   final String title;
//   final List<String> options;
//   final String option1;
//   final String? option2;
//   final String? option3;
//   final int price;
//   final int weight;
//   final int compareAtPrice;
//   final String inventoryManagement;
//   final bool available;
//   final String sku;
//   final bool requiresShipping;
//   final bool taxable;
//   final String barcode;

//   VariantModel({
//     required this.id,
//     required this.title,
//     required this.options,
//     required this.option1,
//     this.option2,
//     this.option3,
//     required this.price,
//     required this.weight,
//     required this.compareAtPrice,
//     required this.inventoryManagement,
//     required this.available,
//     required this.sku,
//     required this.requiresShipping,
//     required this.taxable,
//     required this.barcode,
//   });

//   factory VariantModel.fromJson(Map<String, dynamic> json) {
//     return VariantModel(
//       id: json['id']?.toString() ?? '',
//       //   id: json['id'],
//       title: json['title'],
//       options:
//           (json['options'] as List?)?.map((e) => e.toString()).toList() ?? [],
// //      options: List<String>.from(json['options']),
//       option1: json['option1'],
//       option2: json['option2'],
//       option3: json['option3'],
//       price: json['price'],
//       weight: json['weight'],
//       compareAtPrice: json['compare_at_price'] ?? 0,
//       inventoryManagement: json['inventory_management'],
//       available: json['available'],
//       sku: json['sku'] ?? "",
//       requiresShipping: json['requires_shipping'],
//       taxable: json['taxable'],
//       barcode: json['barcode'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "id": id,
//       "title": title,
//       "options": options,
//       "option1": option1,
//       "option2": option2,
//       "option3": option3,
//       "price": price,
//       "weight": weight,
//       "compare_at_price": compareAtPrice,
//       "inventory_management": inventoryManagement,
//       "available": available,
//       "sku": sku,
//       "requires_shipping": requiresShipping,
//       "taxable": taxable,
//       "barcode": barcode,
//     };
//   }
// }

// // ---------------------------------
// // Option Model
// // ---------------------------------
// class OptionModel {
//   final String name;
//   final int position;

//   OptionModel({
//     required this.name,
//     required this.position,
//   });

//   factory OptionModel.fromJson(Map<String, dynamic> json) {
//     return OptionModel(
//       name: json['name'],
//       position: json['position'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "name": name,
//       "position": position,
//     };
//   }
// }

// // ---------------------------------
// // Review Model
// // ---------------------------------
// class ReviewModel {
//   final String id;
//   final String name;
//   final int star;
//   final String? image;
//   final String body;
//   final String time;

//   ReviewModel({
//     required this.id,
//     required this.name,
//     required this.star,
//     this.image,
//     required this.body,
//     required this.time,
//   });

//   factory ReviewModel.fromJson(Map<String, dynamic> json) {
//     return ReviewModel(
//       id: json['id'],
//       name: json['name'],
//       star: json['star'],
//       image: json['image'],
//       body: json['body'],
//       time: json['time'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "id": id,
//       "name": name,
//       "star": star,
//       "image": image,
//       "body": body,
//       "time": time,
//     };
//   }
// }
