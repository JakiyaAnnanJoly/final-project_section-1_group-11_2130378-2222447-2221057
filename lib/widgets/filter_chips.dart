import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../utils/constants.dart';

class FilterChips extends StatelessWidget {
  const FilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseProvider = context.watch<ExpenseProvider>();
    final currentFilter = expenseProvider.currentCategoryFilter;

    final allCategories = ['All', ...DEFAULT_CATEGORIES];

    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: allCategories.length,
        itemBuilder: (context, index) {
          final category = allCategories[index];
          final isSelected = currentFilter == category;

          return Padding(
            padding: const  EdgeInsets.symmetric(horizontal: 4.0),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (bool selected) {
                if (selected) {
                  expenseProvider.setCategoryFilter(category);
                }
              },
              backgroundColor: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.2) : Colors.grey[200],
              selectedColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }
}