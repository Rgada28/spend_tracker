import 'package:equatable/equatable.dart';

abstract class AddExpenseState extends Equatable {
  const AddExpenseState();
}

class AddExpenseInitial extends AddExpenseState {
  const AddExpenseInitial();
  @override
  List<Object?> get props => [];
}

class AddExpenseSubmitting extends AddExpenseState {
  const AddExpenseSubmitting();
  @override
  List<Object?> get props => [];
}

class AddExpenseSuccess extends AddExpenseState {
  const AddExpenseSuccess();
  @override
  List<Object?> get props => [];
}

class AddExpenseError extends AddExpenseState {
  final String message;
  const AddExpenseError(this.message);
  @override
  List<Object?> get props => [message];
}
