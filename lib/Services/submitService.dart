import 'dart:convert';

import 'package:http/http.dart' as http;

Future<void> submitScoreCard(Map<String, dynamic> data) async {
  final response = await http.post(
    Uri.parse('https://httpbin.org/post'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    print('✅ Submitted!');
    print(response.body); // Confirm JSON received correctly
  } else {
    print('❌ Failed: ${response.statusCode}');
  }
}
