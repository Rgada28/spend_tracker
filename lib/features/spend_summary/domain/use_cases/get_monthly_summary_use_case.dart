import '../entities/monthly_summary_entity.dart';
import '../repositories/spend_summary_repository.dart';

class GetMonthlySummaryUseCase {
  final SpendSummaryRepository repository;

  GetMonthlySummaryUseCase(this.repository);

  Future<MonthlySummaryEntity> call() => repository.getMonthlySummary();
}
