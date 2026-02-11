import 'hue_category.dart';

class Template {
  const Template({
    required this.id,
    required this.category,
    required this.text,
    required this.isDefault,
    required this.isHidden,
    required this.order,
  });

  final String id;
  final HueCategory category;
  final String text;
  final bool isDefault;
  final bool isHidden;
  final int order;

  Template copyWith({
    String? id,
    HueCategory? category,
    String? text,
    bool? isDefault,
    bool? isHidden,
    int? order,
  }) {
    return Template(
      id: id ?? this.id,
      category: category ?? this.category,
      text: text ?? this.text,
      isDefault: isDefault ?? this.isDefault,
      isHidden: isHidden ?? this.isHidden,
      order: order ?? this.order,
    );
  }
}
