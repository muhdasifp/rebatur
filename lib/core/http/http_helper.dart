import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:machine_test/data/local/token.dart';

final httpHelperProvider = Provider<HttpHelper>((ref) {
  return HttpHelper();
});

class HttpHelper {
  final Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<dynamic> get(String endpoint) async {
    final token = await TokenHelper.getToken();
    final response = await http.get(
      Uri.parse(endpoint),
      headers: {
        ..._defaultHeaders,
        ...{"Authorization": "Bearer $token"},
      },
    );
    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    final token = await TokenHelper.getToken();
    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        ..._defaultHeaders,
        ...{"Authorization": "Bearer $token"},
      },
      body: jsonEncode(body ?? {}),
    );
    return _handleResponse(response);
  }

  Future<dynamic> postWithFile(
    String endpoint, {
    Map<String, String>? fields,
    File? file,
  }) async {
    final token = await TokenHelper.getToken();
    var request = http.MultipartRequest('POST', Uri.parse(endpoint));
    print(fields);

    request.headers.addAll({
      ..._defaultHeaders,
      ...{"Authorization": "Bearer $token"},
    });
    if (fields != null) request.fields.addAll(fields);

    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath('photo', file.path));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    return _handleResponse(response);
  }

  Future<dynamic> delete(String endpoint, {Map<String, dynamic>? body}) async {
    final token = await TokenHelper.getToken();
    final response = await http.delete(
      Uri.parse(endpoint),
      headers: {
        ..._defaultHeaders,
        ...{"Authorization": "Bearer $token"},
      },
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    print(body);

    if (statusCode >= 200 && statusCode < 300) {
      return body;
    } else {
      throw body['message'] ?? 'Something went wrong';
    }
  }
}
