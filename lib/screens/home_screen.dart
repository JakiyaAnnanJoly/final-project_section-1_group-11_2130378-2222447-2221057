import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import '../widgets/expense_card.dart';
import '../widgets/filter_chips.dart';
import '../widgets/total_summary_box.dart';
import 'add_edit_expense_screen.dart';
import 'summary_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await Provider.of<AuthProvider>(context, listen: false).signOut();
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = context.watch<ExpenseProvider>();
    final filteredExpenses = expenseProvider.expenses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [

          PopupMenuButton<SortType>(
            icon: const Icon(Icons.sort),
            initialValue: expenseProvider.currentSort,
            onSelected: (SortType result) {
              expenseProvider.setSortType(result);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortType>>[
              const PopupMenuItem<SortType>(
                value: SortType.date_desc,
                child: Text('Date (Newest)'),
              ),
              const PopupMenuItem<SortType>(
                value: SortType.amount_desc,
                child: Text('Amount (Highest)'),
              ),
            ],
          ),


          IconButton( // Log Out Button
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),

      body: Column(
        children: [
          const TotalSummaryBox(),

          const FilterChips(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Expenses',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                // ExpenseProvider
                expenseProvider.setSearchQuery(query);
              },
            ),
          ),

          Expanded(
            child: expenseProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredExpenses.isEmpty
                ? Center(
              child: Text(
                expenseProvider.searchQuery.isNotEmpty
                    ? 'No results found for "${expenseProvider.searchQuery}"'
                    : 'No expenses yet. Add one!',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: filteredExpenses.length,
              itemBuilder: (context, index) {
                final expense = filteredExpenses[index];
                return ExpenseCard(expense: expense);
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Expenses'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Summary'),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SummaryScreen()),
            );
          }
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddEditExpenseScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}