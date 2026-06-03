import 'package:flutter/material.dart';
import '../../domain/entities/monthly_summary_entity.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/animated_counter.dart';
import '../../../../core/widgets/glass_card.dart';
import 'monthly_change_badge.dart';
import 'sparkline_painter.dart';

class HeaderSummaryCard extends StatelessWidget {
  final MonthlySummaryEntity summary;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;

  const HeaderSummaryCard({
    super.key,
    required this.summary,
    required this.fadeAnimation,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: GlassCard(
            borderRadius: AppSpacing.cardBorderRadius,
            padding: const EdgeInsets.all(AppSpacing.lg),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.headerGradientTop, AppColors.headerGradientBottom],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('This Month', style: AppTextStyles.cardLabel),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.glassOverlay,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.glassBorder, width: 1),
                      ),
                      child: Text(
                        summary.monthLabel,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedCounter(
                          targetValue: summary.currentMonthTotal,
                          style: AppTextStyles.displayAmount,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        MonthlyChangeBadge(
                          percentageChange: summary.percentageChange,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 80,
                      height: 50,
                      child: CustomPaint(
                        painter: SparklinePainter(
                          values: summary.weeklyBreakdown,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
