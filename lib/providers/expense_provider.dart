// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
// import 'dart:async';
// import '../models/expense.dart';
// import '../services/firebase_service.dart';
// import '../utils/constants.dart';
//
// class ExpenseProvider with ChangeNotifier {
//
//   final FirebaseService _firebaseService = FirebaseService();
//   StreamSubscription? _expenseSubscription;
//
//   List<Expense> _allExpenses = [];
//   String _currentCategoryFilter = 'All';
//   SortType _currentSort = SortType.date_desc;
//   String _searchQuery = '';
//   bool _isLoading = false;
//
//   String _currentUserId = '';
//
//   // Getters
//   List<Expense> get expenses => _applyFiltersAndSort();
//   String get currentCategoryFilter => _currentCategoryFilter;
//   SortType get currentSort => _currentSort;
//   String get searchQuery => _searchQuery;
//   bool get isLoading => _isLoading;
//
//   ExpenseProvider();
//
//   void updateUid(String newUid) {
//     if (_currentUserId != newUid) {
//       _currentUserId = newUid;
//       if (newUid.isNotEmpty) {
//         _isLoading = true;
//         notifyListeners();
//         _loadExpenses();
//       } else {
//         _allExpenses = [];
//         _expenseSubscription?.cancel();
//         notifyListeners();
//       }
//     }
//   }
//
//   // --- Data Loading and Cleanup ---
//   void _loadExpenses() {
//     if (_currentUserId.isEmpty) return;
//
//     _expenseSubscription?.cancel();
//
//     _expenseSubscription = _firebaseService.streamExpenses(userId: _currentUserId).listen((expenses) {
//       _allExpenses = expenses;
//       _isLoading = false;
//       notifyListeners();
//     }, onError: (error) {
//       debugPrint("Error loading expenses stream: $error");
//       _isLoading = false;
//       notifyListeners();
//     });
//   }
//
//   // Dispose method
//   @override
//   void dispose() {
//     _expenseSubscription?.cancel();
//     super.dispose();
//   }
//
//   // --- CRUD Operations ---
//
//   Future<void> addExpense(Expense expense) async {
//     if (_currentUserId.isEmpty) {
//       debugPrint('ERROR: Cannot add expense. User ID is empty.');
//       return;
//     }
//
//     final updatedExpense = expense.copyWith(userId: _currentUserId);
//
//     try {
//       await _firebaseService.createExpense(updatedExpense);
//       debugPrint('--- EXPENSE ADDED SUCCESSFULLY VIA PROVIDER ---');
//     } catch (e) {
//       debugPrint('--- EXPENSE ADD ERROR (PROVIDER) ---: $e');
//       rethrow;
//     }
//   }
//
//   Future<void> updateExpense(Expense expense) {
//     if (_currentUserId.isEmpty) return Future.value();
//     final updatedExpense = expense.copyWith(userId: _currentUserId);
//     return _firebaseService.updateExpense(updatedExpense);
//   }
//
//   Future<void> deleteExpense(String expenseId) {
//     if (_currentUserId.isEmpty) return Future.value();
//     return _firebaseService.deleteExpense(expenseId, userId: _currentUserId);
//   }
//
//
//   void setCategoryFilter(String category) {
//     _currentCategoryFilter = category;
//     notifyListeners();
//   }
//
//   void setSearchQuery(String query) {
//     _searchQuery = query.toLowerCase();
//     notifyListeners();
//   }
//
//   void setSortType(SortType sortType) {
//     _currentSort = sortType;
//     notifyListeners();
//   }
//
//   List<Expense> _applyFiltersAndSort() {
//     List<Expense> workingList = _allExpenses.where((expense) {
//       final categoryMatch = _currentCategoryFilter == 'All' || expense.category == _currentCategoryFilter;
//       final searchMatch = _searchQuery.isEmpty || expense.name.toLowerCase().contains(_searchQuery);
//       return categoryMatch && searchMatch;
//     }).toList();
//
//     workingList.sort((a, b) {
//       if (_currentSort == SortType.date_desc) {
//         return b.date.compareTo(a.date);
//       } else if (_currentSort == SortType.amount_desc) {
//         return b.amount.compareTo(a.amount);
//       }
//       return 0;
//     });
//
//     return workingList;
//   }
//
//   // --- Summary/Calculations ---
//
//   double getTotalExpense() {
//     return _allExpenses.fold(0.0, (sum, item) => sum + item.amount);
//   }
//
//   double getCategoryTotal(String category) {
//     return _allExpenses
//         .where((exp) => exp.category == category)
//         .fold(0.0, (sum, item) => sum + item.amount);
//   }
// }