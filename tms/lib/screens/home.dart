import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tms/models/transaction.dart';
import 'package:tms/networking.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Transaction>> futureTransaction;
  final _formGlobalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    futureTransaction = fetchTransaction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Transaction Management System'),
      ),
      body: Center(
        child: Column(
          children: [
            //transaction table
            FutureBuilder<List<Transaction>>(
              future: futureTransaction,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Transaction> transactions = snapshot.data!;
                  return DataTable(
                    columnSpacing: 30,
                    columns: [
                      DataColumn(label: Text('Transaction Date')),
                      DataColumn(label: Text('Account Number')),
                      DataColumn(label: Text('Account Holder Name')),
                      DataColumn(label: Text('Amount')),
                      DataColumn(label: Text('Status')),
                    ],
                    rows: transactions.map<DataRow>((transaction) {
                      return DataRow(
                        cells: [
                          DataCell(Text(transaction.transactionDate)),
                          DataCell(Text(transaction.accountNumber)),
                          DataCell(Text(transaction.accountName)),
                          DataCell(Text('${transaction.amount}')),
                          DataCell(Text(transaction.status)),
                        ],
                      );
                    }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return const CircularProgressIndicator();
              },
            ),
            //button for adding a transaction
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Add a Transaction"),
                      content: Form(
                        key: _formGlobalKey,
                        child: Column(
                          children: [
                            //date

                            //account number

                            //account name
                            
                            //amount

                            //submit button
                            FilledButton(
                              onPressed: () {},
                              child: Text('Submit'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              style: TextButton.styleFrom(backgroundColor: Colors.grey[200]),
              child: Text(
                'Add Transaction',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
