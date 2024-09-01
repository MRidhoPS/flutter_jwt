import 'package:consume_jwt/api/auth.dart';
import 'package:consume_jwt/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiServices {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://10.0.2.2:2000'; // Ganti dengan URL API Anda
  AuthServices authServices = AuthServices();

  Future<ApiResponse> getItems() async {

    final token = await authServices.getToken();

    if (token == null) {
      return throw Exception('Error');
    }

    try {
      final response = await _dio.get(
        '$_baseUrl/get',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return ApiResponse.fromJson(response.data);
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response != null) {
        if (kDebugMode) {
          print('Dio error: ${e.response?.data}');
        }
        if (e.response?.statusCode == 401) {
          await AuthServices().logout(); // Clear expired token
        }
      } else {
        if (kDebugMode) {
          print('Dio error: $e');
        }
      }
      return throw Exception('Failed to get items: ${e.message}');
    } catch (e) {
      // Handle other errors
      if (kDebugMode) {
        print('Unexpected error: $e');
      }
      return throw Exception('Unexpected error occurred');
    }
  }
}
