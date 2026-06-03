import 'package:equatable/equatable.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/monthly_summary_entity.dart';

abstract class SpendSummaryState extends Equatable {
  const SpendSummaryState();
}

class SpendSummaryInitial extends SpendSummaryState {
  const SpendSummaryInitial();
  @override
  List<Object?> get props => [];
}

class SpendSummaryLoading extends SpendSummaryState {
  const SpendSummaryLoading();
  @override
  List<Object?> get props => [];
}

class SpendSummaryLoaded extends SpendSummaryState {
  final MonthlySummaryEntity summary;
  final List<CategoryEntity> categories;
  final List<TransactionEntity> transactions;
  final String? activeCategoryFilter;

  const SpendSummaryLoaded({
    required this.summary,
    required this.categories,
    required this.transactions,
    this.activeCategoryFilter,
  });

  List<TransactionEntity> get filteredTransactions {
    if (activeCategoryFilter == null) return transactions;
    return transactions
        .where((t) => t.categoryId == activeCategoryFilter)
        .toList();
  }

  static const _none = Object();

  SpendSummaryLoaded copyWith({
    MonthlySummaryEntity? summary,
    List<CategoryEntity>? categories,
    List<TransactionEntity>? transactions,
    Object? activeCategoryFilter = _none,
  }) {
    return SpendSummaryLoaded(
      summary: summary ?? this.summary,
      categories: categories ?? this.categories,
      transactions: transactions ?? this.transactions,
      activeCategoryFilter: activeCategoryFilter == _none
          ? this.activeCategoryFilter
          : activeCategoryFilter as String?,
    );
  }

  @override
  List<Object?> get props => [
        summary,
        categories,
        transactions,
        activeCategoryFilter,
      ];
}

class SpendSummaryError extends SpendSummaryState {
  final String message;
  const SpendSummaryError(this.message);
  @override
  List<Object?> get props => [message];
}
