import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<void> savePendingSubmission(Map<String, dynamic> submissionData) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('pendingSubmission', jsonEncode(submissionData));
}

Future<void> tryUploadPendingSubmission() async {
  final prefs = await SharedPreferences.getInstance();
  final pending = prefs.getString('pendingSubmission');
  if (pending != null) {
    final data = jsonDecode(pending);
    final response = await http.post(
      Uri.parse('https://webhook.site/5b2896ee-1ad2-453c-947b-95ab4ceaf68a'), // <-- Replace with your actual URL
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      await prefs.remove('pendingSubmission');
    }
  }
}
void setupConnectivityListener() {
  Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
    // Use the last result as the current connectivity status
    if (results.isNotEmpty && results.last != ConnectivityResult.none) {
      tryUploadPendingSubmission();
    }
  });
}