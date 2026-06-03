import 'package:equatable/equatable.dart';

abstract class SpendSummaryEvent extends Equatable {
  const SpendSummaryEvent();
}

class SpendSummaryLoadRequested extends SpendSummaryEvent {
  const SpendSummaryLoadRequested();
  @override
  List<Object?> get props => [];
}

class SpendSummaryCategoryFilterChanged extends SpendSummaryEvent {
  final String? categoryId;
  const SpendSummaryCategoryFilterChanged(this.categoryId);
  @override
  List<Object?> get props => [categoryId];
}

class SpendSummaryTransactionAdded extends SpendSummaryEvent {
  const SpendSummaryTransactionAdded();
  @override
  List<Object?> get props => [];
}
