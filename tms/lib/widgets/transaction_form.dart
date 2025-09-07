import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tms/models/transaction.dart';
import 'package:tms/networking.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}



class _TransactionFormState extends State<TransactionForm> {
  final _formGlobalKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();

  // String _transactionDate = '';
  String _accountNumber = '';
  String _accountName = '';
  double _amount = 0;
  DateTime _selectedDate = DateTime.now();

  Random random = Random();
  List<String> statusList = ["Pending", "Settled", "Failed"];

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) async{
  setState((){
    _dateController.text = args.value.toString().split(' ')[0];
    _selectedDate = args.value;
    Navigator.of(context).pop();
  });
}
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Add Transaction",),
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
              controller: _dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Select Date',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () {
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    content: SizedBox(
                      height: 275,
                      width: 275,
                      child: SfDateRangePicker(
                        onSelectionChanged: _onSelectionChanged,
                        selectionMode: DateRangePickerSelectionMode.single,
                        todayHighlightColor: Colors.teal,
                        selectionColor: Colors.teal,
                        maxDate: DateTime.now(),
                        showNavigationArrow: true,
                        initialDisplayDate: _selectedDate,
                        
                      ),
                    ),
                  );
                });
              },
            ),
            SizedBox(height: 10,),

            //account number
            TextFormField(
              maxLength: 20,
              decoration: const InputDecoration(label: Text('Account Number')),
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
              decoration: const InputDecoration(label: Text('Account Name')),
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
              decoration: const InputDecoration(label: Text('Amount')),
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
              style: FilledButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () {
                if (_formGlobalKey.currentState!.validate()) {
                  _formGlobalKey.currentState!.save();

                  final transaction = Transaction(
                    transactionDate: _dateController.text,
                    accountNumber: _accountNumber,
                    accountName: _accountName,
                    amount: _amount,
                    status: statusList[random.nextInt(3)],
                  );

                  addTransaction(transaction).then((_) {
                    setState(() {
                      Navigator.of(context).pop(true);
                    });
                  });

                  _formGlobalKey.currentState!.reset();
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
