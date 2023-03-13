import 'dart:io';

import 'package:flutter_manage_cookie/domain/repositories/secure_storage/secure_storage_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

import '../secure_storage/secure_storage_key.dart';

final fetchProvider = Provider((ref) => Fetch(ref));

class Fetch {
  Fetch(this._ref);

  final Ref _ref;
  SecureStorageRepository get _secureStorageRepository =>
      _ref.read(secureStorageRepositoryProvider);

  Future<void> setCookiesFromDevice() async {
    final cookieValues =
        await _secureStorageRepository.fetch(SecureStorageKey.cookies);

    if (cookieValues != null) {
      _setCookiesFromJSON(cookieValues);
    }
  }

  Future<http.Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.https(path, '', queryParameters);

    final response = await http.get(
      uri,
      headers: {...?headers, ..._cookieHeader},
    );

    final setCookie = _extractSetCookie(response.headers);

    if (setCookie.isNotEmpty) {
      await _secureStorageRepository.save(SecureStorageKey.cookies, setCookie);

      _setCookiesFromJSON(setCookie);
    }
    return response;
  }

  Future<http.Response> post(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Object? body,
  }) async {
    final response = await http.post(
      Uri.https(url, '', queryParameters),
      headers: {...?headers, ..._cookieHeader},
      body: body,
    );

    final setCookie = _extractSetCookie(response.headers);

    if (setCookie.isNotEmpty) {
      await _secureStorageRepository.save(SecureStorageKey.cookies, setCookie);

      _setCookiesFromJSON(setCookie);
    }
    return response;
  }

  List<Cookie> cookies = [];

  Map<String, String> get _cookieHeader {
    final cookieValues =
        cookies.map((cookie) => '${cookie.name}=${cookie.value}').join(';');
    return {'Cookie': cookieValues};
  }

  // https://zenn.dev/kato_shinya/articles/how-to-handle-multiple-set-cookie-with-dart
  final _regexSplitSetCookies = RegExp(',(?=[^ ])');

  void _setCookiesFromJSON(String cookieValues) {
    final setCookies = cookieValues
        .split(_regexSplitSetCookies)
        .map((e) => Cookie.fromSetCookieValue(e))
        .toList();
    cookies.removeWhere(
        (element) => setCookies.map((e) => e.name).contains(element.name));

    for (final setCookie in setCookies) {
      cookies.add(setCookie);
    }
  }

  String _extractSetCookie(Map<String, dynamic> headers) {
    for (final key in headers.keys) {
      if (key.toLowerCase() == 'set-cookie') {
        return headers[key] as String;
      }
    }

    return '';
  }
}
