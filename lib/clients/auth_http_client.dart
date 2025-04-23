import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:warmreminders/apis/common_api.dart';
import 'package:warmreminders/features/auth/login_page/login_page.dart';
import 'package:warmreminders/main.dart';
import 'package:warmreminders/utils/storage_util.dart';

final authHttpClient = AuthHttpClient();

class AuthHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Attach access token
    final accessToken = await getAccessToken();
    if (accessToken != null) {
      request.headers['Authorization'] = 'Bearer $accessToken';
    }

    // Send request
    http.StreamedResponse response = await _inner.send(request);

    // If unauthorized, try refresh token logic
    if (response.statusCode == 401) {
      await _refreshTokens();

      final newAccessToken = await getAccessToken();
      if (newAccessToken != null) {
        request.headers['Authorization'] = 'Bearer $newAccessToken';
        // Need to clone the request for retry
        final retryRequest = _cloneRequest(request);
        return _inner.send(retryRequest);
      }
    }

    return response;
  }

  Future<void> _refreshTokens() async {
    try {
      final tokens = await refreshTokens();
      await setTokens(tokens);
    } catch (e) {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  // Helper: clone the original request
  http.BaseRequest _cloneRequest(http.BaseRequest request) {
    final newRequest = http.Request(request.method, request.url);
    newRequest.headers.addAll(request.headers);
    if (request is http.Request) {
      newRequest.bodyBytes = request.bodyBytes;
    }
    return newRequest;
  }
}



