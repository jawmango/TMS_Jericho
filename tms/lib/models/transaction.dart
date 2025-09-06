class Transaction {
  final String transactionDate;
  final String accountNumber;
  final String accountName;
  final double amount;
  final String status;

  const Transaction({
    required this.transactionDate,
    required this.accountNumber,
    required this.accountName,
    required this.amount,
    required this.status,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'Transaction Date': String transactionDate,
        'Account Number': String accountNumber,
        'Account Holder Name': String accountName,
        'Amount': double amount,
        'Status': String status,
      } =>
        Transaction(
          transactionDate: transactionDate,
          accountNumber: accountNumber,
          accountName: accountName,
          amount: amount,
          status: status,
        ),
      _ => throw const FormatException('Failed to load transactions.'),
    };
  }

  Map<String, dynamic> toJson(){
    return{
      'Transaction Date': transactionDate,
      'Account Number': accountNumber,
      'Account Holder Name': accountName,
      'Amount': amount,
      'Status': status,
    };
  }
}
