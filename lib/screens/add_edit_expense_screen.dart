import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../utils/constants.dart';
import '../providers/auth_provider.dart';

class AddEditExpenseScreen extends StatefulWidget {
  final Expense? expense; // Null for Add, Not null for Edit

  const AddEditExpenseScreen({super.key, this.expense});

  @override
  State<AddEditExpenseScreen> createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends State<AddEditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _amount;
  late DateTime _date;
  late String _category;
  String? _description;

  @override
  void initState() {
    super.initState();
    final isEdit = widget.expense != null;

    _name = isEdit ? widget.expense!.name : '';
    _amount = isEdit ? widget.expense!.amount : 0.0;
    _date = isEdit ? widget.expense!.date : DateTime.now();
    _category = isEdit ? widget.expense!.category : DEFAULT_CATEGORIES.first;
    _description = isEdit ? widget.expense!.description : '';
  }

  // Function to pick date
  Future<void> _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );
    if (pickedDate != null) {
      setState(() {
        _date = pickedDate;
      });
    }
  }

  // Function to submit the form (Updated for Auth)
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final authProvider = context.read<AuthProvider>();
      final expenseProvider = context.read<ExpenseProvider>();

      final String userId = authProvider.currentUser?.uid ?? '';

      if (userId.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: User not authenticated. Please log in.'), backgroundColor: Colors.red),
          );
        }
        return;
      }


      final newOrUpdatedExpense = Expense(
        id: widget.expense?.id, // Keep ID for update
        userId: userId,
        name: _name,
        amount: _amount,
        date: _date,
        category: _category,
        description: _description,
        createdAt: widget.expense?.createdAt ?? DateTime.now(),
      );

      // Save/Update
      if (widget.expense == null) {
        // Add new expense
        await expenseProvider.addExpense(newOrUpdatedExpense);
      } else {
        // Update existing expense
        await expenseProvider.updateExpense(newOrUpdatedExpense);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.expense != null;

    // UI Layout
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Expense' : 'Add New Expense'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Name Field
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a name.' : null,
                onSaved: (value) => _name = value!,
              ),
              const SizedBox(height: 16),
              // 2. Amount Field
              TextFormField(
                initialValue: _amount == 0.0 ? '' : _amount.toString(),
                decoration: const InputDecoration(labelText: 'Amount (₹)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty || double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Please enter a valid amount.';
                  }
                  return null;
                },
                onSaved: (value) => _amount = double.parse(value!),
              ),
              const SizedBox(height: 16),
              // 3. Date Picker
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Date: ${DateFormat('EEE, MMM d, yyyy').format(_date)}',
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _presentDatePicker,
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Change Date'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // 4. Category Dropdown
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: DEFAULT_CATEGORIES.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (value) => setState(() => _category = value!),
                onSaved: (value) => _category = value!,
              ),
              const SizedBox(height: 16),
              // 5. Description Field
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description (Optional)'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                onSaved: (value) => _description = value,
              ),
              const SizedBox(height: 30),
              // Submit Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: Icon(isEdit ? Icons.save : Icons.add),
                  label: Text(isEdit ? 'Save Changes' : 'Add Expense'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}