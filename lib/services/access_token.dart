import 'dart:developer';
import 'package:localstorage/localstorage.dart';

import './http_request.dart';

class AccessToken {
  final LocalStorage storage = LocalStorage('access_token');

  String _token = '';

  AccessToken([String value]) {
    if (value != null) {
      this._token = value;
    }
  }

  toString() => this._token;

  Future save() async {
    String value = this._token;
    return storage.setItem('value', value);
  }

  Future<AccessToken> retrieve() async {
    String value = await storage.getItem('value');
    return AccessToken(value);
  }

  Future destroy() async {
    this._token = '';
    return this.save();
  }

  static AccessToken fromRequestResult(RequestResult result) {
    String value = result.body.toJson()['token'];
    return AccessToken(value);
  }
}
