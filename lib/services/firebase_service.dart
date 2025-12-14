import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/expense.dart';
// import '../models/expense_model.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  // --- Helper Function: Get the correct subcollection path ---
  CollectionReference<Map<String, dynamic>> _getExpenseCollection({required String userId}) {
    return _db.collection('users').doc(userId).collection('expenses');
  }


  // --- CREATE ---
  Future<void> createExpense(Expense expense) async {
    if (expense.userId.isEmpty) {
      debugPrint('ERROR: Expense model is missing User ID.');
      throw Exception("User ID is missing in Expense model.");
    }

    final expenseCollection = _getExpenseCollection(userId: expense.userId);
    final expenseMap = expense.toMap();

    expenseMap['timestamp'] = FieldValue.serverTimestamp();

    try {
      debugPrint('Attempting to save expense for UID: ${expense.userId}');
      await expenseCollection.add(expenseMap);
      debugPrint('--- FIRESTORE EXPENSE CREATION SUCCESS ---');

    } on FirebaseException catch (e) {
      debugPrint('--- FIRESTORE EXPENSE ERROR (FirebaseException) --- Code: ${e.code}');
      rethrow;
    } catch (e) {
      debugPrint('Error creating expense (General): $e');
      rethrow;
    }
  }


  // --- READ (STREAM) ---
  Stream<List<Expense>> streamExpenses({required String userId}) {
    if (userId.isEmpty) {
      return Stream.value([]);
    }

    final expenseCollection = _getExpenseCollection(userId: userId);

    return expenseCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Expense.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }


  // --- UPDATE ---
  Future<void> updateExpense(Expense expense) async {
    if (expense.id == null || expense.userId.isEmpty) return;

    final expenseCollection = _getExpenseCollection(userId: expense.userId);

    try {
      await expenseCollection.doc(expense.id).update(expense.toMap());
      debugPrint('--- FIRESTORE EXPENSE UPDATE SUCCESS ---');
    } on FirebaseException catch (e) {
      debugPrint('Error updating expense (FirebaseException): ${e.code}');
      rethrow;
    } catch (e) {
      debugPrint("Error updating expense (General): $e");
      rethrow;
    }
  }


  // --- DELETE ---
  Future<void> deleteExpense(String expenseId, {required String userId}) async {
    if (userId.isEmpty) return;

    final expenseCollection = _getExpenseCollection(userId: userId);

    try {
      await expenseCollection.doc(expenseId).delete();
      debugPrint('--- FIRESTORE EXPENSE DELETE SUCCESS ---');
    } on FirebaseException catch (e) {
      debugPrint('Error deleting expense (FirebaseException): ${e.code}');
      rethrow;
    } catch (e) {
      debugPrint("Error deleting expense (General): $e");
      rethrow;
    }
  }
}