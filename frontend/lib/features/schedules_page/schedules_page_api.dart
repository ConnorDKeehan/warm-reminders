import 'dart:convert';
import 'package:warmreminders/clients/auth_http_client.dart';
import 'package:warmreminders/features/schedules_page/models/requests/patch_schedule_request.dart';
import 'package:warmreminders/features/schedules_page/models/requests/post_schedule_request.dart';
import 'package:warmreminders/models/entities/schedule.dart';
import 'package:warmreminders/utils/storage_util.dart';

Future<void> postSchedule(PostScheduleRequest request) async {
  final url = Uri.parse('$configApiBaseUrl/Schedule');

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
    throw Exception('Failed to add schedule: ${response.reasonPhrase}');
  }
}

Future<List<Schedule>> getSchedules() async {
  final url = Uri.parse('$configApiBaseUrl/Schedule');
  final accessToken = await getAccessToken();

  final headers = {
    'Content-Type': 'application/json',
    if (accessToken != null) 'Authorization': 'Bearer $accessToken',
  };

  final response = await authHttpClient.get(url, headers: headers);

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((json) => Schedule.fromJson(json)).toList();
  } else {
    throw Exception('Failed to retrieve schedules: ${response.reasonPhrase}');
  }
}

Future<void> patchSchedule(int id, PatchScheduleRequest command) async {
  final url = Uri.parse('$configApiBaseUrl/Schedule/$id');
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
    throw Exception('Failed to patch schedule: ${response.reasonPhrase}');
  }
}

Future<void> deleteSchedule(int id) async {
  final url = Uri.parse('$configApiBaseUrl/Schedule/$id');
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
    throw Exception('Failed to delete schedule: ${response.reasonPhrase}');
  }
}