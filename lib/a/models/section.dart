enum SectionType { bannerCarousal, horizontalBrochure, collage, faq }

class SectionModel {
  final SectionType? type;
  final int index;
  final Map<String, dynamic> data;

  SectionModel({
    required this.type,
    required this.index,
    required this.data,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      type: parseSectionType(json['type']),
      index: json['index'] ?? 0,
      data: json['data'],
    );
  }

  static SectionType? parseSectionType(String? type) {
    switch (type?.toLowerCase()) {
      case 'banner_carousel':
        return SectionType.bannerCarousal;
      case 'horizontal_brochure':
        return SectionType.horizontalBrochure;
      case 'collage':
        return SectionType.collage;
      case 'faq':
        return SectionType.faq;
      default:
        return null;
    }
  }
}
