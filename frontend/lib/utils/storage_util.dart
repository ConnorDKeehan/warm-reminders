import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:warmreminders/models/responses/token_response.dart';

// Flutter Secure Storage instance
const storage = FlutterSecureStorage();

Future<String?> getAccessToken() async {
  String? accessToken = await storage.read(key: 'accessToken');

  return accessToken;
}

Future<void> setTokens(TokenResponse tokens) async {
  await storage.write(key: 'accessToken', value: tokens.jwtToken);
  await storage.write(key: 'refreshToken', value: tokens.refreshToken);
}

Future<String?> getPushNotificationToken() async {
  return await storage.read(key: 'pushNotificationToken');
}

Future<void> setPushNotificationToken(String token) async {
  await storage.write(key: 'pushNotificationToken', value: token);
}

Future<String?> getRefreshToken() async {
  String? refreshToken = await storage.read(key: 'refreshToken');

  return refreshToken;
}

void setUsersCategories(Iterable<String> categories){
  usersCategories.addAll(categories);
}

Set<String> usersCategories = {"Reminder"};
const configApiBaseUrl = 'https://warm-reminders-dmf8cahmccc8cug8.australiaeast-01.azurewebsites.net';
const configApiSuccessResponses = [200, 201, 204];



