import '../../../spend_summary/domain/entities/transaction_entity.dart';
import '../../../spend_summary/domain/repositories/spend_summary_repository.dart';

class AddExpenseUseCase {
  final SpendSummaryRepository repository;

  AddExpenseUseCase(this.repository);

  Future<void> call(TransactionEntity transaction) =>
      repository.addTransaction(transaction);
}
