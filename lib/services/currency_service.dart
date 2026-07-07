import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyService {
  static const String _baseUrl =
      'https://api.exchangerate-api.com/v4/latest/INR';

  // This function should:
  // 1. Make a GET request to _baseUrl
  // 2. Check if response statusCode == 200
  // 3. Decode the JSON
  // 4. Return only the 'rates' map
  // 5. Throw an Exception if something goes wrong

  Future<Map<String, dynamic>> fetchRates() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode != 200) {
      debugPrint("Can't fetch rates:${response.body}");
      return {};
    }
    final data = jsonDecode(response.body);
    return data['rates'];
  }
}
