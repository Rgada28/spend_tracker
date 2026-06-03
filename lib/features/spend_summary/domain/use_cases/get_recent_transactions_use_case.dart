import '../entities/transaction_entity.dart';
import '../repositories/spend_summary_repository.dart';

class GetRecentTransactionsUseCase {
  final SpendSummaryRepository repository;

  GetRecentTransactionsUseCase(this.repository);

  Future<List<TransactionEntity>> call({int limit = 57}) =>
      repository.getRecentTransactions(limit: limit);
}
