import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tms/models/transaction.dart';
import 'package:tms/services/networking.dart';
import 'package:tms/utils/styles.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm({super.key});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  //form state variable
  final _formGlobalKey = GlobalKey<FormState>();
  
  //controller variables
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  //variables for onSaved trigger
  String _accountNumber = '';
  String _accountName = '';
  double _amount = 0;
  DateTime _selectedDate = DateTime.now();
  bool _isSubmitting = false;

  //variables for generating status
  Random random = Random();
  List<String> statusList = ["Pending", "Settled", "Failed"];

  @override
  void initState() {
    super.initState();
    _dateController.text = DateTime.now().toString().split(' ')[0];
  }

  //saves selected date on datepicker
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) async {
    setState(() {
      _dateController.text = args.value.toString().split(' ')[0];
      _selectedDate = args.value;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(maxWidth: 480),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppStyles.primaryColor.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [_buildHeader(), _buildForm()],
        ),
      ),
    );
  }

  //form header
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppStyles.primaryColor.shade50,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        border: Border(bottom: BorderSide(color: AppStyles.primaryColor.shade300)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppStyles.secondaryColor.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.add_box_outlined,
              color: AppStyles.secondaryColor.shade600,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Add New Transaction",
              style: TextStyle(
                fontSize: AppStyles.largeFontSize,
                fontWeight: FontWeight.w600,
                color: AppStyles.primaryColor.shade800,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close, color: AppStyles.primaryColor.shade600, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: AppStyles.primaryColor.shade100,
              padding: EdgeInsets.all(8),
              minimumSize: Size(32, 32),
            ),
          ),
        ],
      ),
    );
  }

  //form content
  Widget _buildForm() {
    return Flexible(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formGlobalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFormField(
                  label: 'Transaction Date',
                  child: TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: AppStyles.inputDecoration(
                      hintText: 'Select transaction date',
                      prefixIcon: Icons.calendar_today_outlined,
                    ),
                    onTap: _showDatePicker,
                  ),
                ),
                const SizedBox(height: 20),

                _buildFormField(
                  label: 'Account Number',
                  child: TextFormField(
                    controller: _accountNumberController,
                    maxLength: 20,
                    decoration: AppStyles.inputDecoration(
                      hintText: 'Enter account number',
                      prefixIcon: Icons.account_balance_outlined,
                    ).copyWith(counterText: ''),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Account number is required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _accountNumber = value!;
                    },
                  ),
                ),
                const SizedBox(height: 20),

                _buildFormField(
                  label: 'Account Holder Name',
                  child: TextFormField(
                    controller: _accountNameController,
                    maxLength: 50,
                    decoration: AppStyles.inputDecoration(
                      hintText: 'Enter account holder name',
                      prefixIcon: Icons.person_outline,
                    ).copyWith(counterText: ''),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Account holder name is required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _accountName = value!;
                    },
                  ),
                ),
                const SizedBox(height: 20),

                _buildFormField(
                  label: 'Amount',
                  child: TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: AppStyles.inputDecoration(
                      hintText: 'Enter amount',
                      prefixIcon: Icons.attach_money_outlined,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Amount is required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid amount';
                      }
                      if (double.parse(value) <= 0) {
                        return 'Amount must be greater than zero';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _amount = double.parse(value!);
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyles.secondaryColor.shade600,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: _isSubmitting
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Add Transaction',
                            style: AppStyles.formButtonsStyle
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: _isSubmitting
                        ? null
                        : () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: AppStyles.primaryColor.shade600,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: AppStyles.primaryColor.shade300),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppStyles.formButtonsStyle
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //form input fields
  Widget _buildFormField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppStyles.primaryColor.shade700,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  //date picker
  void _showDatePicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Select Date',
            style: TextStyle(
              fontSize: AppStyles.largeFontSize,
              fontWeight: FontWeight.w600,
              color: AppStyles.primaryColor.shade800,
            ),
          ),
          content: SizedBox(
            height: 300,
            width: 300,
            child: SfDateRangePicker(
              onSelectionChanged: _onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.single,
              todayHighlightColor: AppStyles.secondaryColor.shade600,
              selectionColor: AppStyles.secondaryColor.shade600,
              maxDate: DateTime.now(),
              showNavigationArrow: true,
              initialDisplayDate: _selectedDate,
              headerStyle: DateRangePickerHeaderStyle(
                textStyle: TextStyle(
                  color: AppStyles.primaryColor.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  //form submission logic
  void _submitForm() async {
    if (_formGlobalKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      _formGlobalKey.currentState!.save();

      try {
        final transaction = Transaction(
          transactionDate: _dateController.text,
          accountNumber: _accountNumber,
          accountName: _accountName,
          amount: _amount,
          status: statusList[random.nextInt(3)],
        );

        await addTransaction(transaction);

        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        setState(() {
          _isSubmitting = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add transaction: ${e.toString()}'),
              backgroundColor: Colors.red.shade600,
            ),
          );
        }
      }
    }
  }

  //disposes controller state
  @override
  void dispose() {
    _dateController.dispose();
    _accountNumberController.dispose();
    _accountNameController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
