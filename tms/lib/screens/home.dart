import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tms/models/transaction.dart';
import 'package:tms/networking.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Transaction Management System',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            //transaction table
            TransactionTable(futureTransaction: futureTransaction),

            //button for adding a transaction
            TextButton(
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
              style: TextButton.styleFrom(backgroundColor: Colors.grey[200]),
              child: Text(
                'Add Transaction',
                style: TextStyle(color: Colors.teal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
