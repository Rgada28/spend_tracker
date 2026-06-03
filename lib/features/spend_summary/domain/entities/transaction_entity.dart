class TransactionEntity {
  final String id;
  final String title;
  final String categoryId;
  final double amount;
  final DateTime date;
  final String? note;

  const TransactionEntity({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.amount,
    required this.date,
    this.note,
  });
}
