import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../models/category_model.dart';
import '../models/monthly_summary_model.dart';

class SpendSummaryMockSource {
  final List<TransactionModel> _transactions = List.from(_initialTransactions);

  MonthlySummaryModel getMonthlySummary() {
    return const MonthlySummaryModel(
      currentMonthTotal: 24850,
      lastMonthTotal: 21320,
      percentageChange: 16.56,
      monthLabel: 'June 2026',
      weeklyBreakdown: [5200, 7400, 6800, 5450],
    );
  }

  List<CategoryModel> getCategories() {
    final totals = <String, double>{};
    for (final t in _transactions) {
      totals[t.categoryId] = (totals[t.categoryId] ?? 0) + t.amount;
    }
    return _categoryDefs.map((c) {
      return CategoryModel(
        id: c.id,
        name: c.name,
        iconCode: c.iconCode,
        gradientStartColor: c.gradientStartColor,
        gradientEndColor: c.gradientEndColor,
        totalSpend: totals[c.id] ?? 0,
      );
    }).toList();
  }

  List<TransactionModel> getRecentTransactions({int limit = 57}) {
    final sorted = List<TransactionModel>.from(_transactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(limit).toList();
  }

  void addTransaction(TransactionModel transaction) {
    _transactions.insert(0, transaction);
  }
}

// Category definitions (icon codes from Icons class)
final List<_CategoryDef> _categoryDefs = [
  _CategoryDef('food', 'Food', Icons.restaurant.codePoint, 0xFFFF6B6B, 0xFFFF8E53),
  _CategoryDef('travel', 'Travel', Icons.flight_takeoff.codePoint, 0xFF4ECDC4, 0xFF44A08D),
  _CategoryDef('shopping', 'Shopping', Icons.shopping_bag.codePoint, 0xFFA855F7, 0xFF6366F1),
  _CategoryDef('entertainment', 'Entertainment', Icons.movie.codePoint, 0xFFFBBF24, 0xFFF59E0B),
  _CategoryDef('health', 'Health', Icons.favorite.codePoint, 0xFF34D399, 0xFF10B981),
  _CategoryDef('utilities', 'Utilities', Icons.bolt.codePoint, 0xFF60A5FA, 0xFF3B82F6),
  _CategoryDef('groceries', 'Groceries', Icons.local_grocery_store.codePoint, 0xFF86EFAC, 0xFF22C55E),
  _CategoryDef('subscriptions', 'Subscriptions', Icons.subscriptions.codePoint, 0xFFF472B6, 0xFFEC4899),
];

class _CategoryDef {
  final String id;
  final String name;
  final int iconCode;
  final int gradientStartColor;
  final int gradientEndColor;

  const _CategoryDef(this.id, this.name, this.iconCode, this.gradientStartColor, this.gradientEndColor);
}

final List<TransactionModel> _initialTransactions = [
  // Food (14)
  TransactionModel(id: 'txn_001', title: 'Breakfast at Cafe', categoryId: 'food', amount: 280, date: DateTime(2026, 6, 1)),
  TransactionModel(id: 'txn_002', title: 'Lunch — Biryani House', categoryId: 'food', amount: 450, date: DateTime(2026, 6, 2)),
  TransactionModel(id: 'txn_003', title: 'Coffee & Snacks', categoryId: 'food', amount: 120, date: DateTime(2026, 6, 3)),
  TransactionModel(id: 'txn_004', title: 'Dinner with Family', categoryId: 'food', amount: 650, date: DateTime(2026, 6, 4)),
  TransactionModel(id: 'txn_005', title: 'Quick Bite — Subway', categoryId: 'food', amount: 280, date: DateTime(2026, 6, 5)),
  TransactionModel(id: 'txn_006', title: 'Morning Chai', categoryId: 'food', amount: 80, date: DateTime(2026, 6, 7)),
  TransactionModel(id: 'txn_007', title: 'Pizza Night', categoryId: 'food', amount: 540, date: DateTime(2026, 6, 8)),
  TransactionModel(id: 'txn_008', title: 'Street Food', categoryId: 'food', amount: 95, date: DateTime(2026, 6, 10)),
  TransactionModel(id: 'txn_009', title: 'Office Canteen', categoryId: 'food', amount: 180, date: DateTime(2026, 6, 12)),
  TransactionModel(id: 'txn_010', title: 'Burger & Fries', categoryId: 'food', amount: 320, date: DateTime(2026, 6, 14)),
  TransactionModel(id: 'txn_011', title: 'Ice Cream', categoryId: 'food', amount: 110, date: DateTime(2026, 6, 16)),
  TransactionModel(id: 'txn_012', title: 'South Indian Thali', categoryId: 'food', amount: 240, date: DateTime(2026, 6, 18)),
  TransactionModel(id: 'txn_013', title: 'Bakery Treats', categoryId: 'food', amount: 160, date: DateTime(2026, 6, 21)),
  TransactionModel(id: 'txn_014', title: 'Chinese Takeout', categoryId: 'food', amount: 480, date: DateTime(2026, 6, 24)),

  // Travel (9)
  TransactionModel(id: 'txn_015', title: 'Ola Cab — Office', categoryId: 'travel', amount: 180, date: DateTime(2026, 6, 1)),
  TransactionModel(id: 'txn_016', title: 'Metro Card Recharge', categoryId: 'travel', amount: 500, date: DateTime(2026, 6, 3)),
  TransactionModel(id: 'txn_017', title: 'Weekend Road Trip', categoryId: 'travel', amount: 2800, date: DateTime(2026, 6, 6)),
  TransactionModel(id: 'txn_018', title: 'Auto Rickshaw', categoryId: 'travel', amount: 120, date: DateTime(2026, 6, 9)),
  TransactionModel(id: 'txn_019', title: 'Uber Pool', categoryId: 'travel', amount: 220, date: DateTime(2026, 6, 11)),
  TransactionModel(id: 'txn_020', title: 'Train Ticket — Pune', categoryId: 'travel', amount: 650, date: DateTime(2026, 6, 15)),
  TransactionModel(id: 'txn_021', title: 'Cab to Airport', categoryId: 'travel', amount: 780, date: DateTime(2026, 6, 19)),
  TransactionModel(id: 'txn_022', title: 'Petrol Refill', categoryId: 'travel', amount: 1200, date: DateTime(2026, 6, 22)),
  TransactionModel(id: 'txn_023', title: 'Bus Pass — Monthly', categoryId: 'travel', amount: 350, date: DateTime(2026, 6, 25)),

  // Shopping (8)
  TransactionModel(id: 'txn_024', title: 'Nike Sneakers', categoryId: 'shopping', amount: 4500, date: DateTime(2026, 6, 2)),
  TransactionModel(id: 'txn_025', title: 'T-Shirts — H&M', categoryId: 'shopping', amount: 1200, date: DateTime(2026, 6, 5)),
  TransactionModel(id: 'txn_026', title: 'Book — Atomic Habits', categoryId: 'shopping', amount: 299, date: DateTime(2026, 6, 8)),
  TransactionModel(id: 'txn_027', title: 'Headphones', categoryId: 'shopping', amount: 2800, date: DateTime(2026, 6, 10)),
  TransactionModel(id: 'txn_028', title: 'Jeans — Levi\'s', categoryId: 'shopping', amount: 3200, date: DateTime(2026, 6, 13)),
  TransactionModel(id: 'txn_029', title: 'Stationery Set', categoryId: 'shopping', amount: 450, date: DateTime(2026, 6, 17)),
  TransactionModel(id: 'txn_030', title: 'Phone Case & Stand', categoryId: 'shopping', amount: 599, date: DateTime(2026, 6, 20)),
  TransactionModel(id: 'txn_031', title: 'Backpack', categoryId: 'shopping', amount: 1800, date: DateTime(2026, 6, 26)),

  // Entertainment (6)
  TransactionModel(id: 'txn_032', title: 'Movie Tickets — IMAX', categoryId: 'entertainment', amount: 800, date: DateTime(2026, 6, 4)),
  TransactionModel(id: 'txn_033', title: 'Concert Tickets', categoryId: 'entertainment', amount: 999, date: DateTime(2026, 6, 7)),
  TransactionModel(id: 'txn_034', title: 'Board Game Night', categoryId: 'entertainment', amount: 350, date: DateTime(2026, 6, 11)),
  TransactionModel(id: 'txn_035', title: 'Bowling Alley', categoryId: 'entertainment', amount: 499, date: DateTime(2026, 6, 14)),
  TransactionModel(id: 'txn_036', title: 'Escape Room', categoryId: 'entertainment', amount: 650, date: DateTime(2026, 6, 18)),
  TransactionModel(id: 'txn_037', title: 'Comedy Show', categoryId: 'entertainment', amount: 199, date: DateTime(2026, 6, 22)),

  // Health (5)
  TransactionModel(id: 'txn_038', title: 'Gym Membership', categoryId: 'health', amount: 2200, date: DateTime(2026, 6, 1)),
  TransactionModel(id: 'txn_039', title: 'Doctor Consultation', categoryId: 'health', amount: 800, date: DateTime(2026, 6, 6)),
  TransactionModel(id: 'txn_040', title: 'Medicines', categoryId: 'health', amount: 450, date: DateTime(2026, 6, 9)),
  TransactionModel(id: 'txn_041', title: 'Protein Powder', categoryId: 'health', amount: 1800, date: DateTime(2026, 6, 15)),
  TransactionModel(id: 'txn_042', title: 'Blood Test — Thyrocare', categoryId: 'health', amount: 150, date: DateTime(2026, 6, 20)),

  // Utilities (5)
  TransactionModel(id: 'txn_043', title: 'Electricity Bill', categoryId: 'utilities', amount: 1800, date: DateTime(2026, 6, 3)),
  TransactionModel(id: 'txn_044', title: 'Internet Bill', categoryId: 'utilities', amount: 999, date: DateTime(2026, 6, 5)),
  TransactionModel(id: 'txn_045', title: 'Water Bill', categoryId: 'utilities', amount: 400, date: DateTime(2026, 6, 8)),
  TransactionModel(id: 'txn_046', title: 'Gas Cylinder', categoryId: 'utilities', amount: 950, date: DateTime(2026, 6, 12)),
  TransactionModel(id: 'txn_047', title: 'Mobile Recharge', categoryId: 'utilities', amount: 499, date: DateTime(2026, 6, 17)),

  // Groceries (6)
  TransactionModel(id: 'txn_048', title: 'Big Basket Order', categoryId: 'groceries', amount: 1200, date: DateTime(2026, 6, 2)),
  TransactionModel(id: 'txn_049', title: 'Dairy & Eggs', categoryId: 'groceries', amount: 380, date: DateTime(2026, 6, 6)),
  TransactionModel(id: 'txn_050', title: 'Vegetables — Local', categoryId: 'groceries', amount: 180, date: DateTime(2026, 6, 9)),
  TransactionModel(id: 'txn_051', title: 'Fruits Basket', categoryId: 'groceries', amount: 320, date: DateTime(2026, 6, 13)),
  TransactionModel(id: 'txn_052', title: 'Dry Fruits', categoryId: 'groceries', amount: 750, date: DateTime(2026, 6, 18)),
  TransactionModel(id: 'txn_053', title: 'Spices & Condiments', categoryId: 'groceries', amount: 420, date: DateTime(2026, 6, 23)),

  // Subscriptions (4)
  TransactionModel(id: 'txn_054', title: 'Netflix', categoryId: 'subscriptions', amount: 499, date: DateTime(2026, 6, 1)),
  TransactionModel(id: 'txn_055', title: 'Spotify Premium', categoryId: 'subscriptions', amount: 119, date: DateTime(2026, 6, 1)),
  TransactionModel(id: 'txn_056', title: 'YouTube Premium', categoryId: 'subscriptions', amount: 189, date: DateTime(2026, 6, 5)),
  TransactionModel(id: 'txn_057', title: 'iCloud Storage', categoryId: 'subscriptions', amount: 99, date: DateTime(2026, 6, 10)),
];
