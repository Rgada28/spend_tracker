import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class MonthlyChangeBadge extends StatelessWidget {
  final double percentageChange;

  const MonthlyChangeBadge({super.key, required this.percentageChange});

  @override
  Widget build(BuildContext context) {
    final isPositive = percentageChange >= 0;
    final color = isPositive ? AppColors.danger : AppColors.secondary;
    final icon = isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded;
    final sign = isPositive ? '+' : '';
    final label = '$sign${percentageChange.toStringAsFixed(1)}% vs last month';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label, style: AppTextStyles.badgeText.copyWith(color: color)),
        ],
      ),
    );
  }
}
