import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.0.187:3000';

  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final url = '$baseUrl$endpoint';
      developer.log(
        'API Request - POST $url\nRequest Data: ${jsonEncode(data)}',
        name: 'ApiService',
      );

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      print('=== API Response Details ===');
      print('Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');
      print('========================');

      final responseData = jsonDecode(response.body);
      developer.log(
        'API Response - POST $url\nStatus Code: ${response.statusCode}\nResponse Data: ${jsonEncode(responseData)}',
        name: 'ApiService',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': responseData['data'],
          'message': responseData['message'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? '요청이 실패했습니다',
        };
      }
    } catch (e) {
      developer.log(
        'API Error - POST $endpoint\nError: $e',
        name: 'ApiService',
        error: e,
      );
      return {
        'success': false,
        'message': '서버 연결에 실패했습니다: ${e.toString()}',
      };
    }
  }

  static Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final url = '$baseUrl$endpoint';
      developer.log(
        'API Request - GET $url',
        name: 'ApiService',
      );

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
      );

      print('=== API Response Details (GET) ===');
      print('Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');
      print('========================');

      final responseData = jsonDecode(response.body);
      developer.log(
        'API Response - GET $url\nStatus Code: ${response.statusCode}\nResponse Data: ${jsonEncode(responseData)}',
        name: 'ApiService',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': responseData['data'],
          'message': responseData['message'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? '요청이 실패했습니다',
        };
      }
    } catch (e) {
      developer.log(
        'API Error - GET $endpoint\nError: $e',
        name: 'ApiService',
        error: e,
      );
      return {
        'success': false,
        'message': '서버 연결에 실패했습니다: ${e.toString()}',
      };
    }
  }
}
