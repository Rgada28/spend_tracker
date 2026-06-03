import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.iconCode,
    required super.gradientStartColor,
    required super.gradientEndColor,
    required super.totalSpend,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as String,
      name: map['name'] as String,
      iconCode: map['iconCode'] as int,
      gradientStartColor: map['gradientStartColor'] as int,
      gradientEndColor: map['gradientEndColor'] as int,
      totalSpend: (map['totalSpend'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'iconCode': iconCode,
      'gradientStartColor': gradientStartColor,
      'gradientEndColor': gradientEndColor,
      'totalSpend': totalSpend,
    };
  }
}
