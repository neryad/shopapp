class CategoryModel {
  int? id;
  String name;
  String icon; // emoji or short icon label

  CategoryModel({
    this.id,
    this.name = '',
    this.icon = '🛒',
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'] as int?,
        name: json['name'] as String? ?? '',
        icon: json['icon'] as String? ?? '🛒',
      );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'name': name,
      'icon': icon,
    };
    if (id != null) {
      json['id'] = id;
    }
    return json;
  }
}
