import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/category_entity.dart';
import '../bloc/spend_summary_bloc.dart';
import '../bloc/spend_summary_event.dart';
import '../../../../core/theme/app_spacing.dart';
import 'category_chip.dart';

class CategoryScrollRow extends StatelessWidget {
  final List<CategoryEntity> categories;
  final String? activeCategoryFilter;
  final Animation<double> fadeAnimation;

  const CategoryScrollRow({
    super.key,
    required this.categories,
    required this.activeCategoryFilter,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: SizedBox(
        height: 110,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          itemCount: categories.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CategoryChip(
                  isAll: true,
                  isSelected: activeCategoryFilter == null,
                  onTap: () => context
                      .read<SpendSummaryBloc>()
                      .add(const SpendSummaryCategoryFilterChanged(null)),
                ),
              );
            }
            final category = categories[index - 1];
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CategoryChip(
                category: category,
                isSelected: activeCategoryFilter == category.id,
                onTap: () => context
                    .read<SpendSummaryBloc>()
                    .add(SpendSummaryCategoryFilterChanged(category.id)),
              ),
            );
          },
        ),
      ),
    );
  }
}
