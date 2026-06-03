class CategoryEntity {
  final String id;
  final String name;
  final int iconCode;
  final int gradientStartColor;
  final int gradientEndColor;
  final double totalSpend;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.iconCode,
    required this.gradientStartColor,
    required this.gradientEndColor,
    required this.totalSpend,
  });
}
