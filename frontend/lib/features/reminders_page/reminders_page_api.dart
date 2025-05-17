import 'dart:convert';
import 'package:warmreminders/clients/auth_http_client.dart';
import 'package:warmreminders/features/reminders_page/models/requests/patch_reminder_request.dart';
import 'package:warmreminders/features/reminders_page/models/requests/post_reminder_request.dart';
import 'package:warmreminders/models/entities/reminder.dart';
import 'package:warmreminders/utils/storage_util.dart';

Future<List<Reminder>> getReminders() async {
  final url = Uri.parse('$configApiBaseUrl/Reminder');
  final accessToken = await getAccessToken();

  final headers = {
    'Content-Type': 'application/json',
    if (accessToken != null) 'Authorization': 'Bearer $accessToken',
  };

  final response = await authHttpClient.get(url, headers: headers);

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((item) => Reminder.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load reminders data: ${response.reasonPhrase}');
  }
}

Future<void> postReminder(PostReminderRequest request) async {
  final url = Uri.parse('$configApiBaseUrl/Reminder');

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
    throw Exception('Failed to add reminder: ${response.reasonPhrase}');
  }
}

// Add a new route


// Add a new route
Future<void> updateReminder(int id, PatchReminderRequest command) async {
  final url = Uri.parse('$configApiBaseUrl/Reminder/$id');

  // Retrieve the access token
  final accessToken = await getAccessToken();

  final headers = {
    'Content-Type': 'application/json',
    if (accessToken != null) 'Authorization': 'Bearer $accessToken',
  };

  final response = await authHttpClient.patch(
      url,
      body: jsonEncode(command.toJson()),
      headers: headers
  );

  if (configApiSuccessResponses.contains(response.statusCode)) {
    return;
  } else {
    throw Exception('Failed to update reminder: ${response.reasonPhrase}');
  }
}

// Add a new route
Future<void> deleteReminder(int id) async {
  final url = Uri.parse('$configApiBaseUrl/Reminder/$id');

  // Retrieve the access token
  final accessToken = await getAccessToken();

  final headers = {
    'Content-Type': 'application/json',
    if (accessToken != null) 'Authorization': 'Bearer $accessToken',
  };

  final response = await authHttpClient.delete(
      url,
      headers: headers
  );

  if (configApiSuccessResponses.contains(response.statusCode)) {
    return;
  } else {
    throw Exception('Failed to delete reminder: ${response.reasonPhrase}');
  }
}



