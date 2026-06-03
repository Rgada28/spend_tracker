import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/add_expense_bloc.dart';
import '../bloc/add_expense_event.dart';
import '../bloc/add_expense_state.dart';
import '../widgets/amount_input_field.dart';
import '../widgets/category_selector_grid.dart';
import '../widgets/date_picker_field.dart';
import '../../../spend_summary/domain/entities/transaction_entity.dart';
import '../../../spend_summary/presentation/bloc/spend_summary_bloc.dart';
import '../../../spend_summary/presentation/bloc/spend_summary_event.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();

  String? _selectedCategoryId;
  DateTime _selectedDate = DateTime.now();
  String? _amountError;
  String? _titleError;
  String? _categoryError;

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  bool _validate() {
    bool valid = true;
    setState(() {
      _amountError = null;
      _titleError = null;
      _categoryError = null;

      final amount = double.tryParse(_amountController.text);
      if (_amountController.text.isEmpty || amount == null || amount <= 0) {
        _amountError = 'Enter a valid amount';
        valid = false;
      }
      if (_titleController.text.trim().isEmpty) {
        _titleError = 'Enter a description';
        valid = false;
      }
      if (_selectedCategoryId == null) {
        _categoryError = 'Select a category';
        valid = false;
      }
    });
    return valid;
  }

  void _submit(BuildContext context) {
    if (!_validate()) return;

    final transaction = TransactionEntity(
      id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      categoryId: _selectedCategoryId!,
      amount: double.parse(_amountController.text),
      date: _selectedDate,
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
    );

    context.read<AddExpenseBloc>().add(AddExpenseSubmitted(transaction));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddExpenseBloc, AddExpenseState>(
      listener: (context, state) {
        if (state is AddExpenseSuccess) {
          context.read<SpendSummaryBloc>().add(const SpendSummaryLoadRequested());
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Expense added!'),
              backgroundColor: AppColors.secondary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        } else if (state is AddExpenseError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.danger,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Add Expense', style: AppTextStyles.sectionHeading),
          centerTitle: true,
        ),
        body: BlocBuilder<AddExpenseBloc, AddExpenseState>(
          builder: (context, state) {
            final isLoading = state is AddExpenseSubmitting;

            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Amount input
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSpacing.cardBorderRadius),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: AmountInputField(
                        controller: _amountController,
                        errorText: _amountError,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Title field
                    _sectionLabel('Description'),
                    const SizedBox(height: AppSpacing.sm),
                    TextField(
                      controller: _titleController,
                      style: AppTextStyles.transactionTitle,
                      decoration: InputDecoration(
                        hintText: 'e.g. Lunch at Biryani House',
                        errorText: _titleError,
                        prefixIcon: const Icon(
                          Icons.edit_outlined,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                      ),
                      onChanged: (_) {
                        if (_titleError != null) setState(() => _titleError = null);
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Category selector
                    Row(
                      children: [
                        _sectionLabel('Category'),
                        if (_categoryError != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            _categoryError!,
                            style: AppTextStyles.caption
                                .copyWith(color: AppColors.danger),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    BlocBuilder<SpendSummaryBloc, dynamic>(
                      builder: (context, summaryState) {
                        final categories = summaryState?.categories ?? [];
                        return CategorySelectorGrid(
                          categories: categories,
                          selectedCategoryId: _selectedCategoryId,
                          onSelected: (id) {
                            setState(() {
                              _selectedCategoryId = id;
                              _categoryError = null;
                            });
                          },
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Date picker
                    _sectionLabel('Date'),
                    const SizedBox(height: AppSpacing.sm),
                    DatePickerField(
                      selectedDate: _selectedDate,
                      onDateChanged: (date) => setState(() => _selectedDate = date),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Note (optional)
                    _sectionLabel('Note (optional)'),
                    const SizedBox(height: AppSpacing.sm),
                    TextField(
                      controller: _noteController,
                      style: AppTextStyles.transactionTitle,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Add a note...',
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(bottom: 42),
                          child: Icon(
                            Icons.notes_rounded,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                        ),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Save button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : () => _submit(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 8,
                          shadowColor: AppColors.primary.withValues(alpha: 0.4),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: AppColors.textPrimary,
                                ),
                              )
                            : const Text('Save Expense', style: AppTextStyles.button),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.caption.copyWith(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}
