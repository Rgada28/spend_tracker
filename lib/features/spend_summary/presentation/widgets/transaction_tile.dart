import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_icon.dart';

class TransactionTile extends StatelessWidget {
  final TransactionEntity transaction;
  final CategoryEntity? category;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.category,
    required this.fadeAnimation,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColors = category != null
        ? [
            Color(category!.gradientStartColor),
            Color(category!.gradientEndColor),
          ]
        : [AppColors.primary, AppColors.primaryLight];

    final dateStr = DateFormat('MMM d').format(transaction.date);
    final amountStr =
        '₹${transaction.amount.toStringAsFixed(transaction.amount % 1 == 0 ? 0 : 0)}';

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          gradientColors.first.withValues(alpha: 0.2),
                          gradientColors.last.withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: category != null
                          ? GradientIcon(
                              icon: IconData(
                                category!.iconCode,
                                fontFamily: 'MaterialIcons',
                              ),
                              colors: gradientColors,
                              size: 20,
                            )
                          : const Icon(
                              Icons.receipt_long_rounded,
                              color: AppColors.textSecondary,
                              size: 20,
                            ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.title,
                          style: AppTextStyles.transactionTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Text(dateStr, style: AppTextStyles.caption),
                            if (category != null) ...[
                              const SizedBox(width: 6),
                              Container(
                                width: 3,
                                height: 3,
                                decoration: BoxDecoration(
                                  color: AppColors.textMuted,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                category!.name,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(amountStr, style: AppTextStyles.amountBold),
                ],
              ),
            ),
            Container(
              height: 1,
              margin: const EdgeInsets.only(left: 78),
              color: AppColors.border,
            ),
          ],
        ),
      ),
    );
  }
}
