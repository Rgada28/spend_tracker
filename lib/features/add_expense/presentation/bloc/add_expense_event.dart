import 'package:equatable/equatable.dart';
import '../../../spend_summary/domain/entities/transaction_entity.dart';

abstract class AddExpenseEvent extends Equatable {
  const AddExpenseEvent();
}

class AddExpenseSubmitted extends AddExpenseEvent {
  final TransactionEntity transaction;
  const AddExpenseSubmitted(this.transaction);
  @override
  List<Object?> get props => [transaction];
}

class AddExpenseReset extends AddExpenseEvent {
  const AddExpenseReset();
  @override
  List<Object?> get props => [];
}
