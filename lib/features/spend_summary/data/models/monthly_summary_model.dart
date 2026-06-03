import '../../domain/entities/monthly_summary_entity.dart';

class MonthlySummaryModel extends MonthlySummaryEntity {
  const MonthlySummaryModel({
    required super.currentMonthTotal,
    required super.lastMonthTotal,
    required super.percentageChange,
    required super.monthLabel,
    required super.weeklyBreakdown,
  });

  factory MonthlySummaryModel.fromMap(Map<String, dynamic> map) {
    return MonthlySummaryModel(
      currentMonthTotal: (map['currentMonthTotal'] as num).toDouble(),
      lastMonthTotal: (map['lastMonthTotal'] as num).toDouble(),
      percentageChange: (map['percentageChange'] as num).toDouble(),
      monthLabel: map['monthLabel'] as String,
      weeklyBreakdown: List<double>.from(
        (map['weeklyBreakdown'] as List).map((e) => (e as num).toDouble()),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currentMonthTotal': currentMonthTotal,
      'lastMonthTotal': lastMonthTotal,
      'percentageChange': percentageChange,
      'monthLabel': monthLabel,
      'weeklyBreakdown': weeklyBreakdown,
    };
  }
}
