import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getQuoteOfDay() async {
  final response =
      await http.get(Uri.parse('https://quotes.rest/qod?language=en'));
  final quoteJson = jsonDecode(response.body) as Map<String, dynamic>;
  return quoteJson;
}
