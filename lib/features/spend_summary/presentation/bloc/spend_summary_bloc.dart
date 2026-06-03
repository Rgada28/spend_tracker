import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/get_monthly_summary_use_case.dart';
import '../../domain/use_cases/get_categories_use_case.dart';
import '../../domain/use_cases/get_recent_transactions_use_case.dart';
import 'spend_summary_event.dart';
import 'spend_summary_state.dart';

class SpendSummaryBloc extends Bloc<SpendSummaryEvent, SpendSummaryState> {
  final GetMonthlySummaryUseCase getMonthlySummary;
  final GetCategoriesUseCase getCategories;
  final GetRecentTransactionsUseCase getRecentTransactions;

  SpendSummaryBloc({
    required this.getMonthlySummary,
    required this.getCategories,
    required this.getRecentTransactions,
  }) : super(const SpendSummaryInitial()) {
    on<SpendSummaryLoadRequested>(_onLoadRequested);
    on<SpendSummaryCategoryFilterChanged>(_onCategoryFilterChanged);
    on<SpendSummaryTransactionAdded>(_onTransactionAdded);
  }

  Future<void> _onLoadRequested(
    SpendSummaryLoadRequested event,
    Emitter<SpendSummaryState> emit,
  ) async {
    emit(const SpendSummaryLoading());
    try {
      final results = await Future.wait([
        getMonthlySummary(),
        getCategories(),
        getRecentTransactions(),
      ]);
      emit(SpendSummaryLoaded(
        summary: results[0] as dynamic,
        categories: results[1] as dynamic,
        transactions: results[2] as dynamic,
      ));
    } catch (e) {
      emit(SpendSummaryError(e.toString()));
    }
  }

  void _onCategoryFilterChanged(
    SpendSummaryCategoryFilterChanged event,
    Emitter<SpendSummaryState> emit,
  ) {
    if (state is SpendSummaryLoaded) {
      final current = state as SpendSummaryLoaded;
      emit(current.copyWith(activeCategoryFilter: event.categoryId));
    }
  }

  Future<void> _onTransactionAdded(
    SpendSummaryTransactionAdded event,
    Emitter<SpendSummaryState> emit,
  ) async {
    add(const SpendSummaryLoadRequested());
  }
}
