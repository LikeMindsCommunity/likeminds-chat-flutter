import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// Mock function to initiate user
Future<(String, String)> mockInitiateUser({
  required String apiKey,
  required String userName,
  required String userId,
}) async {
  String host = "https://betaauth.likeminds.community";
  final dio = Dio();
  try {
    final Response response = await dio.post(
      options: Options(
        headers: {
          'x-api-key': apiKey,
        },
      ),
      "$host/sdk/initiate",
      data: {
        'user_name': userName,
        'user_unique_id': userId,
        "token_expiry_beta": 1,
        "rtm_token_expiry_beta": 2
      },
    );
    if (response.data['success'] && response.data['data'] != null) {
      return (
        response.data['data']['access_token'] as String,
        response.data['data']['refresh_token'] as String
      );
    }

    throw Exception("Failed to initiate user");
  } on DioException catch (e) {
    debugPrint("Error: ${e.message}");
    throw Exception("Failed to initiate user");
  } finally {
    dio.close();
  }
}
