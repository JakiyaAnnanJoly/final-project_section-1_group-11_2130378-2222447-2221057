import 'package:flutter/material.dart';

const List<String> DEFAULT_CATEGORIES = [
  'Food',
  'Transport',
  'Entertainment',
  'Shopping',
  'Bills',
  'Other',
];

// Enum for sorting options
enum SortType {
  date_desc, // Newest first (Default)
  amount_desc, // Highest amount first
}

// Map categories to colors for better UI
const Map<String, Color> CATEGORY_COLORS = {
  'Food': Colors.red,
  'Transport': Colors.blue,
  'Entertainment': Colors.purple,
  'Shopping': Colors.green,
  'Bills': Colors.orange,
  'Other': Colors.grey,
};