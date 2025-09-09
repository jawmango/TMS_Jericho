

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tms/models/transaction.dart';

//fetch the transaction data from API
Future<List<Transaction>> fetchTransaction() async {
  final response = await http.get(
    Uri.parse('http://127.0.0.1:5000/transactions'),
  );

  if (response.statusCode == 200) {
    List<dynamic> jsonList = jsonDecode(response.body);

    return jsonList.map((json) => Transaction.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load transaction data: ${response.statusCode}');
  }
}

//POST request on api for adding transaction
Future<void> addTransaction(Transaction transaction) async{
  final url = Uri.parse('http://127.0.0.1:5000/transactions');

  final response = await http.post(
    url,
    headers: {
      'Content-Type':'application/json',
      'Accept': 'application/json',
    },
    body: json.encode(transaction.toJson()),
  );

  if (response.statusCode==201){
    null;
  }
  else{
    throw Exception('Failed to create new transaction data: ${response.statusCode}');
  }

}