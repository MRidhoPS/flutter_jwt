import 'package:consume_jwt/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices{
  final Dio _dio = Dio();
  final String _baseUrl = 'http://10.0.2.2:2000';

  Future<LoginResponse> login(String username, String password) async{
    try {
      final response = await _dio.post(
        '$_baseUrl/login',
        data: {'username':username, 'password':password},
      );
      final loginResponse = LoginResponse.fromJson(response.data); // untuk menangkap response dari api yang mana isinya ada token dan items
      final token = loginResponse.token;

      if(token.isNotEmpty){
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
      }
      return loginResponse;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String?> getToken()async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}