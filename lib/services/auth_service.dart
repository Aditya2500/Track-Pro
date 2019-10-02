import 'dart:developer';
import 'dart:async';

import './firebase_auth_service.dart';
import '../constants/api.dart' as constants;
import './http_request.dart';
import './access_token.dart';

class AuthService {
  static Future<bool> isAuthenticated() async {
    try {
      AccessToken accessToken = await AccessToken().retrieve();
      String url = constants.SMLS_API_SERVICE_AUTH;
      Map<String, String> headers = {
        'Authorization': 'Bearer ' + accessToken.toString()
      };
      RequestResult result = await Request.get(url, headers: headers);
      return result.success;
    }
    catch (exception) {}
    return false;
  }

  static Future<RequestResultBody> check(String username, String password) async {
    try {
      String url = constants.SMLS_API_SERVICE_AUTH_CHECK;
      Map<String, String> body = {
        "username": username,
        "password": password
      };
      RequestResult result = await Request.post(url, body: body);
      if (result.success) {
        return result.body;
      }
    }
    catch (exception) {
      log("AuthService.check: "+exception.toString());
    }
    return RequestResultBody('');
  }

  static Future<bool> authenticate(String username, String password) async {
    try {
      String url = constants.SMLS_API_SERVICE_AUTH;
      Map<String, String> body = {
        "username": username,
        "password": password
      };
      RequestResult result = await Request.post(url, body: body);
      if (result.success) {
        await AccessToken.fromRequestResult(result).save();
      }
      return result.success;
    }
    catch (exception) {
      log("AuthService.authenticate: "+exception.toString());
    }
    return false;
  }

  static Future<void> destroySession() async {
    AccessToken accessToken;
    try {
      accessToken = await AccessToken().retrieve();
      String url = constants.SMLS_API_SERVICE_AUTH;
      Map<String, String> headers = {'Authorization': 'Bearer ' + accessToken.toString()};
      await Request.delete(url, headers: headers);
    }
    catch (exception) {
      log("AuthService.destroySession: "+exception.toString());
    }
    finally {
      await accessToken.destroy();
    }
  }

  static Future<bool> authenticateUsingGoogle() async {
    try {
      FirebaseAuthResult firebaseAuthResult = await FirebaseAuthService().signInWithGoogle();
      if (firebaseAuthResult != null) {
        return AuthService.authenticateUsingFirebaseAuthResult(firebaseAuthResult);
      }
    }
    catch (exception) {
      log("AuthService.authenticateUsingGoogle: "+exception.toString());
    }
    return false;
  }

  static Future<bool> authenticateUsingFirebaseAuthResult(FirebaseAuthResult firebaseAuthResult) async {
    try {
      String url = constants.SMLS_API_SERVICE_AUTH_FIREBASE;
      Map<String, String> body = {
        "idToken": firebaseAuthResult.idToken,
        "uid": firebaseAuthResult.uid,
        "email": firebaseAuthResult.email
      };
      RequestResult result = await Request.post(url, body: body);
      if (result.success) {
        await AccessToken.fromRequestResult(result).save();
      }
      return result.success;
    }
    catch (exception) {
      log("AuthService.authenticateUsingFirebaseAuthResult: "+exception.toString());
    }
    return false;
  }
}
