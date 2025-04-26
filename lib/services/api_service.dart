import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import '../providers/user_provider.dart';

class ApiService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:3000';
    } else {
      return 'http://10.0.2.2:3000';
    }
  }

  static Map<String, String> _getHeaders(String? token) {
    final headers = {
      'Content-Type': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data, {
    String? token,
  }) async {
    try {
      final url = '$baseUrl$endpoint';
      print('=== API Request Details (POST) ===');
      print('URL: $url');
      print('Headers: ${_getHeaders(token)}');
      print('Request Body: ${jsonEncode(data)}');
      print('========================');

      developer.log(
        'API Request - POST $url\nRequest Data: ${jsonEncode(data)}',
        name: 'ApiService',
      );

      final response = await http.post(
        Uri.parse(url),
        headers: _getHeaders(token),
        body: jsonEncode(data),
      );

      print('=== API Response Details ===');
      print('Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');
      print('========================');

      final responseData = jsonDecode(response.body);
      print('=== Raw API Response ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: $responseData');
      print('Response Type: ${responseData.runtimeType}');
      if (responseData is! List) {
        print('Response Keys: ${responseData.keys.toList()}');
      }
      print('========================');

      developer.log(
        'API Response - POST $url\nStatus Code: ${response.statusCode}\nResponse Data: ${jsonEncode(responseData)}',
        name: 'ApiService',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data':
              responseData['meetings'] ?? responseData['data'] ?? responseData,
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
    String? token,
  }) async {
    try {
      final url = '$baseUrl$endpoint';
      print('=== API Request Details (GET) ===');
      print('URL: $url');
      print('Headers: ${_getHeaders(token)}');
      print('========================');

      developer.log(
        'API Request - GET $url',
        name: 'ApiService',
      );

      final response = await http.get(
        Uri.parse(url),
        headers: _getHeaders(token),
      );

      print('=== API Response Details (GET) ===');
      print('Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');
      print('========================');

      final responseData = jsonDecode(response.body);
      print('=== Raw API Response ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: $responseData');
      print('Response Type: ${responseData.runtimeType}');
      if (responseData is! List) {
        print('Response Keys: ${responseData.keys.toList()}');
      }
      print('========================');

      developer.log(
        'API Response - GET $url\nStatus Code: ${response.statusCode}\nResponse Data: ${jsonEncode(responseData)}',
        name: 'ApiService',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData is List) {
          return {
            'success': true,
            'data': responseData,
            'message': null,
          };
        }
        return {
          'success': true,
          'data':
              responseData['meetings'] ?? responseData['data'] ?? responseData,
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

  static Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data, {
    String? token,
  }) async {
    try {
      final url = '$baseUrl$endpoint';
      print('=== API Request Details (PUT) ===');
      print('URL: $url');
      print('Headers: ${_getHeaders(token)}');
      print('Request Body: ${jsonEncode(data)}');
      print('========================');

      developer.log(
        'API Request - PUT $url\nRequest Data: ${jsonEncode(data)}',
        name: 'ApiService',
      );

      final response = await http.put(
        Uri.parse(url),
        headers: _getHeaders(token),
        body: jsonEncode(data),
      );

      print('=== API Response Details ===');
      print('Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');
      print('========================');

      final responseData = jsonDecode(response.body);
      print('=== Raw API Response ===');
      print('Status Code: ${response.statusCode}');
      print('Response Body: $responseData');
      print('Response Type: ${responseData.runtimeType}');
      if (responseData is! List) {
        print('Response Keys: ${responseData.keys.toList()}');
      }
      print('========================');

      developer.log(
        'API Response - PUT $url\nStatus Code: ${response.statusCode}\nResponse Data: ${jsonEncode(responseData)}',
        name: 'ApiService',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': responseData['data'] ?? responseData,
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
        'API Error - PUT $endpoint\nError: $e',
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
