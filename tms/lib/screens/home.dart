import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
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

  Random random = Random();
  String _transactionDate = '';
  String _accountNumber = '';
  String _accountName = '';
  double _amount = 0;
  List<String> statusList = ["Pending", "Settled", "Failed"];

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
                          DataCell(
                            Text(
                              transaction.status,
                              style: TextStyle(
                                color: transaction.status == "Pending"
                                    ? Colors.yellow
                                    : transaction.status == "Settled"
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),
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
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Add Transaction",
                            style: TextStyle(color: Colors.teal),
                          ),
                          SizedBox(width: 100),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.close),
                          ),
                        ],
                      ),
                      content: Form(
                        key: _formGlobalKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Divider(),
                            //date
                            TextFormField(
                              maxLength: 10,
                              decoration: const InputDecoration(
                                label: Text('Transaction Date'),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Date cannot be empty.';
                                }
                              },
                              onSaved: (value) {
                                _transactionDate = value!;
                              },
                            ),

                            //account number
                            TextFormField(
                              maxLength: 20,
                              decoration: const InputDecoration(
                                label: Text('Account Number'),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Account number cannot be empty.';
                                }
                              },
                              onSaved: (value) {
                                _accountNumber = value!;
                              },
                            ),

                            //account name
                            TextFormField(
                              maxLength: 20,
                              decoration: const InputDecoration(
                                label: Text('Account Name'),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Account name cannot be empty.';
                                }
                              },
                              onSaved: (value) {
                                _accountName = value!;
                              },
                            ),

                            //amount
                            TextFormField(
                              maxLength: 20,
                              decoration: const InputDecoration(
                                label: Text('Amount'),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Amount cannot be empty';
                                } else if (double.tryParse(value) == null) {
                                  return 'Amount should be a number';
                                }
                              },
                              onSaved: (value) {
                                _amount = double.parse(value!);
                              },
                            ),

                            //submit button
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.teal,
                              ),
                              onPressed: () {
                                if (_formGlobalKey.currentState!.validate()) {
                                  _formGlobalKey.currentState!.save();

                                  final transaction = Transaction(
                                    transactionDate: _transactionDate,
                                    accountNumber: _accountNumber,
                                    accountName: _accountName,
                                    amount: _amount,
                                    status: statusList[random.nextInt(3)],
                                  );

                                  addTransaction(transaction).then((_) {
                                    setState(() {
                                      futureTransaction = fetchTransaction();
                                    });
                                  });

                                  _formGlobalKey.currentState!.reset();
                                  Navigator.of(context).pop();
                                }
                              },
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
                style: TextStyle(color: Colors.teal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
