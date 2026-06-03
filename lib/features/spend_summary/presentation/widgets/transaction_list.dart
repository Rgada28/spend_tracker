import 'package:flutter/material.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/category_entity.dart';
import 'transaction_tile.dart';

class TransactionList extends StatefulWidget {
  final List<TransactionEntity> transactions;
  final List<CategoryEntity> categories;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.categories,
  });

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList>
    with TickerProviderStateMixin {
  late AnimationController _staggerController;
  final Map<String, CategoryEntity> _categoryMap = {};

  @override
  void initState() {
    super.initState();
    _buildCategoryMap();
    _staggerController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300 + (widget.transactions.length.clamp(0, 20) * 30),
      ),
    )..forward();
  }

  @override
  void didUpdateWidget(TransactionList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.transactions != widget.transactions) {
      _buildCategoryMap();
      _staggerController
        ..reset()
        ..forward();
    }
  }

  void _buildCategoryMap() {
    _categoryMap.clear();
    for (final c in widget.categories) {
      _categoryMap[c.id] = c;
    }
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final tx = widget.transactions[index];
          final category = _categoryMap[tx.categoryId];

          final staggerCount = widget.transactions.length.clamp(1, 20);
          final intervalStart = (index / staggerCount).clamp(0.0, 0.9);
          final intervalEnd = ((index + 1) / staggerCount).clamp(0.1, 1.0);

          final fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _staggerController,
              curve: Interval(intervalStart, intervalEnd, curve: Curves.easeOut),
            ),
          );

          final slideAnim = Tween<Offset>(
            begin: const Offset(0, 0.3),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: _staggerController,
              curve: Interval(intervalStart, intervalEnd, curve: Curves.easeOutCubic),
            ),
          );

          return TransactionTile(
            key: ValueKey(tx.id),
            transaction: tx,
            category: category,
            fadeAnimation: fadeAnim,
            slideAnimation: slideAnim,
          );
        },
        childCount: widget.transactions.length,
      ),
    );
  }
}
