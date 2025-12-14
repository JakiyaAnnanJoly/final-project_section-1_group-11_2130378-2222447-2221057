import 'package:flutter/material.dart';

const List<String> DEFAULT_CATEGORIES = [
  'Food',
  'Transport',
  'Entertainment',
  'Shopping',
  'Bills',
  'Other',
];

enum SortType {
  date_desc,
  amount_desc,
}

const Map<String, Color> CATEGORY_COLORS = {
  'Food': Colors.red,
  'Transport': Colors.blue,
  'Entertainment': Colors.purple,
  'Shopping': Colors.green,
  'Bills': Colors.orange,
  'Other': Colors.grey,
};