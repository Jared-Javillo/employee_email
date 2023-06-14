import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

const ok = 'ok';
const timeout = Duration(seconds: 30);
const recordLimit = 30;
const postHeaders = <String, String>{
  'Content-Type': 'application/json',
};
const getHeaders = <String, String>{
  'Content-Type': 'application/x-www-form-urlencoded',
};
const uploadHeaders = <String, String>{
  'Content-Type': 'multipart/form-data',
};

typedef SuccessNotifier<T> = Future<T> Function(List<dynamic> json);

typedef ErrorNotifier = Future<String> Function(int code);

class Parser {
  static Future<T> parse<T>({
    required Response response,
    required SuccessNotifier<T> onSuccess,
    required ErrorNotifier onError,
  }) async {
    final headers = response.request?.headers;
    debugPrint('Headers: $headers');
    debugPrint('Body: ${response.body}');
    debugPrint('Code: ${response.statusCode}');
    final code = response.statusCode;
    if (response.statusCode == HttpStatus.ok) {
      final body = json.decode(response.body);
      final init = (body['init'] as List<dynamic>)[0];
      if (init['status'] == ok) {
        final data = body['data'] as List<dynamic>?;
        return await onSuccess(data ?? []);
      } else {
        throw init['message'];
      }
    } else {
      throw await onError(code);
    }
  }
}
