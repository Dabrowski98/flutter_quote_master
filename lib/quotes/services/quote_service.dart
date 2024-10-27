import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteService {
  String url = 'httHa://api.quotable.io/';

  Future<Map<String, dynamic>> fetchQuotes({int pageNumber = 1}) async {
    final query = "quotes?limit=150&page=$pageNumber";
    final response = await http.get(Uri.parse(url + query));

    if (response.statusCode != 200) {
      throw Exception(
          "Failed to fetch a quote with following status code ${response.statusCode}");
    } else {
      final data = json.decode(response.body);
      return data;
    }
  }
}
