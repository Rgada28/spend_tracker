import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/app_router.dart';

import 'features/spend_summary/data/sources/spend_summary_mock_source.dart';
import 'features/spend_summary/data/repositories/spend_summary_repository_impl.dart';
import 'features/spend_summary/domain/use_cases/get_monthly_summary_use_case.dart';
import 'features/spend_summary/domain/use_cases/get_categories_use_case.dart';
import 'features/spend_summary/domain/use_cases/get_recent_transactions_use_case.dart';
import 'features/spend_summary/presentation/bloc/spend_summary_bloc.dart';
import 'features/spend_summary/presentation/bloc/spend_summary_event.dart';

import 'features/add_expense/domain/use_cases/add_expense_use_case.dart';
import 'features/add_expense/presentation/bloc/add_expense_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const SpendTrackerApp());
}

class SpendTrackerApp extends StatelessWidget {
  const SpendTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final mockSource = SpendSummaryMockSource();
    final repository = SpendSummaryRepositoryImpl(mockSource);

    return MultiBlocProvider(
      providers: [
        BlocProvider<SpendSummaryBloc>(
          create: (_) => SpendSummaryBloc(
            getMonthlySummary: GetMonthlySummaryUseCase(repository),
            getCategories: GetCategoriesUseCase(repository),
            getRecentTransactions: GetRecentTransactionsUseCase(repository),
          )..add(const SpendSummaryLoadRequested()),
        ),
        BlocProvider<AddExpenseBloc>(
          create: (_) => AddExpenseBloc(
            addExpense: AddExpenseUseCase(repository),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Spend Tracker',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
