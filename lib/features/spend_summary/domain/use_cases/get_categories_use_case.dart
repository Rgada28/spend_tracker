import '../entities/category_entity.dart';
import '../repositories/spend_summary_repository.dart';

class GetCategoriesUseCase {
  final SpendSummaryRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<CategoryEntity>> call() => repository.getCategories();
}
