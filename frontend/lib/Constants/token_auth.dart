import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/js.dart';
import 'dart:convert';

import '../Pages/Home/home_page.dart';
import '../Pages/Home/login_page.dart';
import '../Utils/appConstants.dart';

const storage = FlutterSecureStorage();

class TokenVerification extends StatefulWidget {
  const TokenVerification({super.key});

  @override
  State<TokenVerification> createState() => _TokenVerificationState();
}

class _TokenVerificationState extends State<TokenVerification> {
  @override
  void initState() {
    super.initState();
    checkAccessToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> checkAccessToken() async {
    final String? accessToken = await getAccessToken();

    if (accessToken == null) {
      // No access token, navigate to login
      Navigator.pushReplacement(context as BuildContext,
          MaterialPageRoute(builder: (context) => const LoginPage()));
    } else {
      // Check if the token is expired
      final bool isTokenExpired = await isAccessTokenExpired(accessToken);

      if (isTokenExpired) {
        await refreshAccessToken();

        // Check again after refresh
        final String? newAccessToken = await getAccessToken();
        if (newAccessToken == null) {
          Navigator.pushReplacement(context as BuildContext,
              MaterialPageRoute(builder: (context) => const LoginPage()));
        } else {
          await autoLogin(newAccessToken);
        }
      } else {
        // Token is valid
        await autoLogin(accessToken);
      }
    }
  }
}

Future<void> autoLogin(String accessToken) async {
  try {
    final response = await http.post(
      Uri.parse('${AppConstants.BASE_URL}/login'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context as BuildContext,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    } else {
      print('Auto login failed: ${response.statusCode}');
      Navigator.pushReplacement(
        context as BuildContext,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  } catch (e) {
    print('Error during auto login: $e');
    Navigator.pushReplacement(
      context as BuildContext,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}

Future<bool> isAccessTokenExpired(String accessToken) async {
  try {
    final List<String> parts = accessToken.split('.');
    if (parts.length != 3) {
      // Invalid token format
      return true;
    }

    final String payload =
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final Map<String, dynamic> decodedToken = json.decode(payload);

    if (decodedToken.containsKey('exp')) {
      final int expirationTime = decodedToken['exp'];
      final int currentTimeInSeconds =
          DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;

      return expirationTime < currentTimeInSeconds;
    }

    // If the token doesn't have an expiration claim, consider it expired
    return true;
  } catch (e) {
    // Handle decoding errors or missing claims
    print('Error decoding token: $e');
    return true;
  }
}

Future<String?> getAccessToken() async {
  // Retrieve the access token from secure storage
  return await storage.read(key: 'access_token');
}

Future<void> refreshAccessToken() async {
  try {
    final String? refreshToken = await storage.read(key: 'refresh_token');

    if (refreshToken != null) {
      final response = await http.post(
        Uri.parse(
            '${AppConstants.BASE_URL}/token/refresh'), // Replace with your server's token refresh endpoint
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'refresh': refreshToken,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String newAccessToken = responseData['access'];

        // Update the stored access token
        await storage.write(key: 'access_token', value: newAccessToken);

        print('New Access Token: $newAccessToken');
      } else {
        // Handle other refresh token response statuses
        print('Error refreshing access token: ${response.statusCode}');
      }
    } else {
      // No refresh token found, handle accordingly
      print('No refresh token found');
    }
  } catch (e) {
    // Handle refresh token request errors
    print('Error refreshing access token: $e');
  }
}
