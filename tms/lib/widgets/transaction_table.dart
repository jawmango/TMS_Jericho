import 'package:flutter/material.dart';
import 'package:tms/models/transaction.dart';

class TransactionTable extends StatefulWidget {
  final Future<List<Transaction>> futureTransaction;
  const TransactionTable({super.key, required this.futureTransaction});

  @override
  State<TransactionTable> createState() => _TransactionTableState();
}

class _TransactionTableState extends State<TransactionTable> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Transaction>>(
      future: widget.futureTransaction,
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
    );
  }
}
