import 'dart:convert';
import 'package:warmreminders/clients/auth_http_client.dart';
import 'package:warmreminders/features/remembers_page/models/post_remember_request.dart';
import 'package:warmreminders/features/reminders_page/models/requests/post_reminder_request.dart';
import 'package:warmreminders/models/entities/remember.dart';
import 'package:warmreminders/utils/storage_util.dart';

Future<List<Remember>> getRemembers() async {
  final url = Uri.parse('$configApiBaseUrl/Remember');
  final accessToken = await getAccessToken();

  final headers = {
    'Content-Type': 'application/json',
    if (accessToken != null) 'Authorization': 'Bearer $accessToken',
  };

  final response = await authHttpClient.get(url, headers: headers);

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((item) => Remember.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load remembers data: ${response.reasonPhrase}');
  }
}

Future<void> postRemember(PostRememberRequest request) async {
  final url = Uri.parse('$configApiBaseUrl/Remember');

  // Retrieve the access token
  final accessToken = await getAccessToken();

  final headers = {
    'Content-Type': 'application/json',
    if (accessToken != null) 'Authorization': 'Bearer $accessToken',
  };

  final response = await authHttpClient.post(
      url,
      body: jsonEncode(request.toJson()),
      headers: headers
  );

  if (configApiSuccessResponses.contains(response.statusCode)) {
    return;
  } else {
    throw Exception('Failed to add remember: ${response.reasonPhrase}');
  }
}


