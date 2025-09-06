

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tms/models/transaction.dart';

Future<List<Transaction>> fetchTransaction() async {
  final response = await http.get(
    Uri.parse('http://127.0.0.1:5000/transactions'),
  );

  if (response.statusCode == 200) {
    List<dynamic> jsonList = jsonDecode(response.body);

    return jsonList.map((json) => Transaction.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load data: ${response.statusCode}');
  }
}