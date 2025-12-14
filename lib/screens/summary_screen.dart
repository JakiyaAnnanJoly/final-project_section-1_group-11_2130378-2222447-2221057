import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../utils/constants.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    final totalSpent = expenseProvider.getTotalExpense();

    final categoryTotals = {
      for (var category in DEFAULT_CATEGORIES)
        category: expenseProvider.getCategoryTotal(category)
    };

    final spentCategories = categoryTotals.entries
        .where((entry) => entry.value > 0)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Summary'),
      ),
      body: totalSpent == 0.0
          ? const Center(
        child: Text(
          'No expenses recorded yet.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: spentCategories.length,
        itemBuilder: (context, index) {
          final entry = spentCategories[index];
          final category = entry.key;
          final total = entry.value;
          final color = CATEGORY_COLORS[category] ?? Colors.grey;

          final percentage = (total / totalSpent) * 100;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: ListTile(
              leading: Icon(Icons.circle, color: color, size: 12),
              title: Text(
                category,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                '₹${total.toStringAsFixed(2)} (${percentage.toStringAsFixed(1)}%)',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          );
        },
      ),
    );
  }
}