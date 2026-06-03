import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../add_expense/domain/use_cases/add_expense_use_case.dart';
import 'add_expense_event.dart';
import 'add_expense_state.dart';

class AddExpenseBloc extends Bloc<AddExpenseEvent, AddExpenseState> {
  final AddExpenseUseCase addExpense;

  AddExpenseBloc({required this.addExpense}) : super(const AddExpenseInitial()) {
    on<AddExpenseSubmitted>(_onSubmitted);
    on<AddExpenseReset>(_onReset);
  }

  Future<void> _onSubmitted(
    AddExpenseSubmitted event,
    Emitter<AddExpenseState> emit,
  ) async {
    emit(const AddExpenseSubmitting());
    try {
      await addExpense(event.transaction);
      emit(const AddExpenseSuccess());
    } catch (e) {
      emit(AddExpenseError(e.toString()));
    }
  }

  void _onReset(AddExpenseReset event, Emitter<AddExpenseState> emit) {
    emit(const AddExpenseInitial());
  }
}
