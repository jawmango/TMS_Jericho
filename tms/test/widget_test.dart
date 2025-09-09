import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tms/models/transaction.dart';
import 'package:tms/utils/helpers.dart';
import 'package:flutter/material.dart';

void main() {
  group('Transaction Model Tests', () {
    test('should create transaction with correct values', () {
      Random random = Random();
      List<String> statusList = ["Pending", "Settled", "Failed"];
      final transaction = Transaction(
        transactionDate: '2025-03-01',
        accountNumber: '7289-3445-1121',
        accountName: 'Maria Johnson',
        amount: 150.00,
        status: statusList[random.nextInt(3)],
      );

      expect(transaction.transactionDate, equals('2025-03-01'));
      expect(transaction.accountNumber, equals('7289-3445-1121'));
      expect(transaction.accountName, equals('Maria Johnson'));
      expect(transaction.amount, equals(150.00));
      expect(statusList.contains(transaction.status), isTrue);
    });
  });

  //status color assignment
  group('Status Color Test', () {
    test('should return yellow for pending', () {
      expect(AppHelpers.statusColor('pending'), Colors.yellow);
    });
    test('should return green for settled', () {
      expect(AppHelpers.statusColor('settled'), Colors.green);
    });
    test('should return red for failed', () {
      expect(AppHelpers.statusColor('failed'), Colors.red);
    });
  });
}
