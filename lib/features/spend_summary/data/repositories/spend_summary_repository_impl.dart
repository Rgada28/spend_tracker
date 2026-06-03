import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/monthly_summary_entity.dart';
import '../../domain/repositories/spend_summary_repository.dart';
import '../models/transaction_model.dart';
import '../sources/spend_summary_mock_source.dart';

class SpendSummaryRepositoryImpl implements SpendSummaryRepository {
  final SpendSummaryMockSource _source;

  SpendSummaryRepositoryImpl(this._source);

  @override
  Future<MonthlySummaryEntity> getMonthlySummary() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _source.getMonthlySummary();
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    return _source.getCategories();
  }

  @override
  Future<List<TransactionEntity>> getRecentTransactions({int limit = 57}) async {
    return _source.getRecentTransactions(limit: limit);
  }

  @override
  Future<void> addTransaction(TransactionEntity transaction) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _source.addTransaction(
      TransactionModel(
        id: transaction.id,
        title: transaction.title,
        categoryId: transaction.categoryId,
        amount: transaction.amount,
        date: transaction.date,
        note: transaction.note,
      ),
    );
  }
}
