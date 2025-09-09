import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppHelpers {
  //formats amount to Philippine money
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(symbol: '₱', decimalDigits: 2);
    return formatter.format(amount);
  }

  //color assignment for status
  static MaterialColor statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.yellow;
      case 'settled':
        return Colors.green;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  //icon assignment for status
  static IconData statusIcon(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return Icons.schedule;
    case 'settled':
      return Icons.check_circle;
    case 'failed':
      return Icons.cancel;
    default:
      return Icons.help;
  }
}
}
