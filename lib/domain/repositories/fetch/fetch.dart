import 'package:flutter_manage_cookie/domain/repositories/shared_preferences/shared_preferences_key.dart';
import 'package:flutter_manage_cookie/domain/repositories/shared_preferences/shared_preferences_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

final fetchProvider = Provider((ref) => Fetch(ref.read));

class Fetch {
  Fetch(this._read);

  final Reader _read;
  late final _prefs = _read(sharedPreferencesRepositoryProvider);

  // https://zenn.dev/kato_shinya/articles/how-to-handle-multiple-set-cookie-with-dart
  final _regexSplitSetCookies = RegExp(',(?=[^ ])');

  final List<Cookie> cookies = [];
  final cookieManager = CookieManager();

  Future<void> fetchCookiesFromDevice() async {
    final cookieValues =
        _prefs.fetch<List<String>>(SharedPreferencesKey.cookies);
    if (cookieValues != null) {
      _setSetCookies(cookieValues);
    }
  }

  Future<http.Response> getRequest(String url) async {
    final response = await http.get(Uri.parse(
      url,
    ));

    final setCookie = _getSetCookie(response.headers);
    print('cookie: $setCookie');
    if (setCookie.isNotEmpty) {
      final cookieValues = setCookie.split(_regexSplitSetCookies);

      await _prefs.save(SharedPreferencesKey.cookies, cookieValues);

      _setSetCookies(cookieValues);
    }
    return response;
  }

  void _setSetCookies(List<String> cookieValues) {
    for (final cookie in cookieValues) {
      cookies.add(Cookie.fromSetCookieValue(cookie));
    }
  }

  String _getSetCookie(Map<String, dynamic> headers) {
    for (final key in headers.keys) {
      if (key.toLowerCase() == 'set-cookie') {
        return headers[key] as String;
      }
    }

    return '';
  }
}
