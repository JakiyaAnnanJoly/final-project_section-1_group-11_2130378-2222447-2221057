// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import '../models/expense.dart';
// import '../providers/expense_provider.dart';
// import '../utils/constants.dart';
// import '../screens/add_edit_expense_screen.dart';
//
// class ExpenseCard extends StatelessWidget {
//   final Expense expense;
//
//   const ExpenseCard({super.key, required this.expense});
//
//   Future<bool?> _confirmDelete(BuildContext context) async {
//     final bool? shouldDelete = await showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Confirm Delete'),
//           content: Text('Are you sure you want to delete "${expense.name}"?'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(false),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(true),
//               child: const Text('Delete', style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//
//     if (shouldDelete == true && expense.id != null) {
//       Provider.of<ExpenseProvider>(context, listen: false)
//           .deleteExpense(expense.id!);
//       return true;
//     }
//     return false;
//   }
//
//   void _editExpense(BuildContext context) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => AddEditExpenseScreen(expense: expense),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final categoryColor = CATEGORY_COLORS[expense.category] ?? Colors.grey;
//
//     return Dismissible(
//       key: ValueKey(expense.id),
//       direction: DismissDirection.endToStart,
//       background: Container(
//         color: Colors.red,
//         alignment: Alignment.centerRight,
//         padding: const EdgeInsets.only(right: 20),
//         child: const Icon(Icons.delete, color: Colors.white, size: 30),
//       ),
//       confirmDismiss: (direction) => _confirmDelete(context),
//       onDismissed: (direction) {}, // Deletion handled by confirmDismiss
//       child: Card(
//         margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//         child: ListTile(
//           leading: Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: categoryColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(Icons.shopping_bag, color: categoryColor, size: 20),
//           ),
//           title: Text(expense.name, style: const TextStyle(fontWeight: FontWeight.w600)),
//           subtitle: Text('${DateFormat('MMM d, yyyy').format(expense.date)} | ${expense.category}'),
//           trailing: Text(
//             '₹${expense.amount.toStringAsFixed(2)}',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 16,
//               color: categoryColor,
//             ),
//           ),
//           onTap: () => _editExpense(context),
//         ),
//       ),
//     );
//   }
// }