import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../error/exceptions.dart';

/// HTTP Client wrapper for API calls
class HttpClient {
  final http.Client _client;

  HttpClient({http.Client? client}) : _client = client ?? http.Client();

  /// GET request
  Future<dynamic> get(String endpoint) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final response = await _client
          .get(uri)
          .timeout(ApiConstants.timeout);

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException();
    } on http.ClientException {
      throw const NetworkException();
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  /// Handle HTTP response
  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return json.decode(response.body);
      case 404:
        throw const NotFoundException();
      case 500:
        throw const ServerException(
          message: 'Error interno del servidor',
          statusCode: 500,
        );
      default:
        throw ServerException(
          message: 'Error: ${response.statusCode}',
          statusCode: response.statusCode,
        );
    }
  }

  void dispose() {
    _client.close();
  }
}