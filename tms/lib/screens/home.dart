import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tms/models/transaction.dart';
import 'package:tms/services/networking.dart';
import 'package:tms/utils/styles.dart';
import 'package:tms/widgets/transaction_form.dart';
import 'package:tms/widgets/transaction_table.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Transaction>> futureTransaction;

  @override
  void initState() {
    super.initState();
    futureTransaction = fetchTransaction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primaryColor.shade50,
      //add Transaction Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await showDialog<bool>(
            context: context,
            builder: (context) => TransactionForm(),
          );

          if (result == true) {
            setState(() {
              futureTransaction = fetchTransaction();
            });
          }
        },
        backgroundColor: AppStyles.secondaryColor.shade600,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Transaction'),
        elevation: 8,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50, 50, 50, 105),
        child: TransactionTable(futureTransaction: futureTransaction),
      ),
    );
  }
}
