import 'package:flutter/material.dart';
import '../../domain/entities/category_entity.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/gradient_icon.dart';

class CategoryChip extends StatefulWidget {
  final CategoryEntity? category;
  final bool isAll;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    this.category,
    this.isAll = false,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<CategoryChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.92,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnim = _scaleController;
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  String _compactAmount(double amount) {
    if (amount >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(1)}K';
    }
    return '₹${amount.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;
    final gradientColors = widget.isAll
        ? [AppColors.primary, AppColors.primaryLight]
        : [
            Color(widget.category!.gradientStartColor),
            Color(widget.category!.gradientEndColor),
          ];

    return GestureDetector(
      onTapDown: (_) => _scaleController.reverse(),
      onTapUp: (_) {
        _scaleController.forward();
        widget.onTap();
      },
      onTapCancel: () => _scaleController.forward(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (_, child) => Transform.scale(
          scale: isSelected ? 1.05 : _scaleAnim.value,
          child: child,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 76,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.surfaceLight
                : AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.chipBorderRadius),
            border: Border.all(
              color: isSelected
                  ? gradientColors.first.withValues(alpha: 0.5)
                  : AppColors.border,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: gradientColors.first.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppSpacing.chipIconSize,
                height: AppSpacing.chipIconSize,
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
                  child: widget.isAll
                      ? GradientIcon(
                          icon: Icons.grid_view_rounded,
                          colors: gradientColors,
                          size: 22,
                        )
                      : GradientIcon(
                          icon: IconData(
                            widget.category!.iconCode,
                            fontFamily: 'MaterialIcons',
                          ),
                          colors: gradientColors,
                          size: 22,
                        ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.isAll ? 'All' : widget.category!.name,
                style: AppTextStyles.chipLabel.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 2),
              if (!widget.isAll)
                Text(
                  _compactAmount(widget.category!.totalSpend),
                  style: AppTextStyles.chipAmount,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
