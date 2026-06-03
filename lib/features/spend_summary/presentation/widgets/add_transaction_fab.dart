import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';

class AddTransactionFab extends StatefulWidget {
  final Animation<double> scaleAnimation;

  const AddTransactionFab({super.key, required this.scaleAnimation});

  @override
  State<AddTransactionFab> createState() => _AddTransactionFabState();
}

class _AddTransactionFabState extends State<AddTransactionFab> {
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: widget.scaleAnimation,
      child: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(context, AppRoutes.addExpense);
        },
        backgroundColor: AppColors.primary,
        elevation: 8,
        label: const Text(
          'Add Expense',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: AppColors.textPrimary,
          ),
        ),
        icon: const Icon(
          Icons.add_rounded,
          size: 22,
          color: AppColors.textPrimary,
        ),
        extendedPadding: const EdgeInsets.symmetric(horizontal: 20),
      ),
    );
  }
}
