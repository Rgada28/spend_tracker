class MonthlySummaryEntity {
  final double currentMonthTotal;
  final double lastMonthTotal;
  final double percentageChange;
  final String monthLabel;
  final List<double> weeklyBreakdown;

  const MonthlySummaryEntity({
    required this.currentMonthTotal,
    required this.lastMonthTotal,
    required this.percentageChange,
    required this.monthLabel,
    required this.weeklyBreakdown,
  });
}
