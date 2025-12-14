// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class Expense {
//   final String? id; // Firestore document ID (optional on creation)
//   final String userId;
//   final String name;
//   final double amount;
//   final DateTime date;
//   final String category;
//   final String? description;
//   final DateTime createdAt;
//
//   Expense({
//     this.id,
//     required this.userId,
//     required this.name,
//     required this.amount,
//     required this.date,
//     required this.category,
//     this.description,
//     required this.createdAt,
//   });
//
//   // Convert Expense object to Firestore Map
//   Map<String, dynamic> toMap() {
//     return {
//       'userId': userId,
//       'name': name,
//       'amount': amount,
//       'date': Timestamp.fromDate(date),
//       'category': category,
//       'description': description,
//       'createdAt': Timestamp.fromDate(createdAt),
//     };
//   }
//
//   // Factory constructor to create Expense object from Firestore Map
//   factory Expense.fromMap(Map<String, dynamic> map, String documentId) {
//     return Expense(
//       id: documentId,
//       userId: map['userId'] ?? '',
//       name: map['name'] ?? 'No Name',
//       amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
//       date: (map['date'] as Timestamp).toDate(),
//       category: map['category'] ?? 'Other',
//       description: map['description'],
//       createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
//     );
//   }
//
//   // Helper method for copying/updating
//   Expense copyWith({
//     String? id,
//     String? userId,
//     String? name,
//     double? amount,
//     DateTime? date,
//     String? category,
//     String? description,
//     DateTime? createdAt,
//   }) {
//     return Expense(
//       id: id ?? this.id,
//       userId: userId ?? this.userId,
//       name: name ?? this.name,
//       amount: amount ?? this.amount,
//       date: date ?? this.date,
//       category: category ?? this.category,
//       description: description ?? this.description,
//       createdAt: createdAt ?? this.createdAt,
//     );
//   }
// }