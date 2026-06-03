import '../entities/transaction_entity.dart';
import '../entities/category_entity.dart';
import '../entities/monthly_summary_entity.dart';

abstract class SpendSummaryRepository {
  Future<MonthlySummaryEntity> getMonthlySummary();
  Future<List<CategoryEntity>> getCategories();
  Future<List<TransactionEntity>> getRecentTransactions({int limit = 57});
  Future<void> addTransaction(TransactionEntity transaction);
}
