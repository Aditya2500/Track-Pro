import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

class Request {
  static get(String url,
    {
      String query = '',
      Map<String, String> headers,
      bool isJSON = true
    }) async {
    try {
      if (headers == null)
        headers = {};

      if (isJSON) {
        headers['Content-Type'] = 'application/json';
      }
      Response response =
        await http.get(
          url + (query != null ? '?' + query : ''),
          headers: headers
        );
      return ResponseParser.parseResponse(response);
    }
    catch (exception) {
      throw RequestException(exception.message);
    }
  }

  static post(String url,
    {
      String query = '',
      Map<String, String> headers,
      Map<String, String> body,
      bool isJSON = true
    }) async {
    try {
      if (headers == null)
        headers = {};
      if (body == null)
        body = {};

      if (isJSON) {
        headers['Content-Type'] = 'application/json';
      }

      Response response =
        await http.post(
          url + (query != null ? '?' + query : ''),
          headers: headers,
          body: isJSON ? json.encode(body) : body
        );
      return ResponseParser.parseResponse(response);
    }
    catch (exception) {
      throw RequestException(exception.message);
    }
  }

  static put(String url,
    {
      String query = '',
      Map<String, String> headers,
      Map<String, String> body,
      bool isJSON = true
    }) async {
    try {
      if (headers == null)
        headers = {};
      if (body == null)
        body = {};

      if (isJSON) {
        headers['Content-Type'] = 'application/json';
      }

      Response response =
        await http.put(
          url + (query != null ? '?' + query : ''),
          headers: headers,
          body: isJSON ? json.encode(body) : body
        );
      return ResponseParser.parseResponse(response);
    }
    catch (exception) {
      throw RequestException(exception.message);
    }
  }

  static patch(String url,
    {
      String query = '',
      Map<String, String> headers,
      Map<String, String> body,
      bool isJSON = true
    }) async {
    try {
      if (headers == null)
        headers = {};
      if (body == null)
        body = {};

      if (isJSON) {
        headers['Content-Type'] = 'application/json';
      }

      Response response =
        await http.patch(
          url + (query != null ? '?' + query : ''),
          headers: headers,
          body: isJSON ? json.encode(body) : body
        );
      return ResponseParser.parseResponse(response);
    }
    catch (exception) {
      throw RequestException(exception.message);
    }
  }

  static delete(String url,
    {
      String query = '',
      Map<String, String> headers = const {},
      bool isJSON = true
    }) async {
    try {
      if (headers == null)
        headers = {};

      if (isJSON) {
        headers['Content-Type'] = 'application/json';
      }

      Response response =
        await http.delete(
          url + (query != null ? '?' + query : ''),
          headers: headers
        );
      return ResponseParser.parseResponse(response);
    }
    catch (exception) {
      throw RequestException(exception.message);
    }
  }
}

class ResponseParser {
  static String detectResponseType(Response response) {
    if (response.statusCode >= 100 && response.statusCode <= 199)
      return "informational";
    if (response.statusCode >= 200 && response.statusCode <= 299)
      return "success";
    if (response.statusCode >= 300 && response.statusCode <= 399)
      return "redirection";
    if (response.statusCode >= 400 && response.statusCode <= 499)
      return "client error";
    if (response.statusCode >= 500 && response.statusCode <= 599)
      return "server error";
    return "unknown";
  }

  static bool isOK(Response response) {
    return (response.statusCode >= 100 && response.statusCode <= 299);
  }

  static bool isSuccess(Response response) {
    return (response.statusCode >= 200 && response.statusCode <= 299);
  }

  static bool isRedirect(Response response) {
    return (response.statusCode >= 300 && response.statusCode <= 399);
  }

  static String resolveRedirectLocation(Response response) {
    return
      response.headers.containsKey('location')
        ? response.headers['location']
        : null;
  }

  static RequestResult parseResponse(Response response) {
    return RequestResult(
      type: ResponseParser.detectResponseType(response),
      ok: ResponseParser.isOK(response),
      success: ResponseParser.isSuccess(response),
      redirect: ResponseParser.isRedirect(response),
      redirectLocation: ResponseParser.resolveRedirectLocation(response),
      statusCode: response.statusCode,
      body: RequestResultBody(response.body),
      headers: response.headers
    );
  }
}

class RequestException implements Exception {
  final String message;

  RequestException(this.message);

  String toString() => this.message;
}

class RequestResult {
  final String type;
  final bool ok;
  final bool success;
  final bool redirect;
  final String redirectLocation;
  final int statusCode;
  final RequestResultBody body;
  final Map<String, String> headers;

  RequestResult({
    this.type = 'unknown',
    this.ok = false,
    this.success = false,
    this.redirect = false,
    this.redirectLocation,
    this.statusCode = 0,
    this.body,
    this.headers = const {}
  });
}

class RequestResultBody {
  final String body;

  RequestResultBody(this.body);

  dynamic toJson() {
    return json.decode(this.body);
  }
}

class TrackerApiService {
  static Future<dynamic> listDevices(String firebaseId, String firebaseEmail) async {
    try {
      String url = "http://13.235.186.224/devices";
      Map<String, String> headers = {
        'Authorization': 'Bearer firebase:'+firebaseEmail+':'+firebaseId
      };
      RequestResult result = await Request.get(url, headers: headers);
     
      return result.body.toJson();
    }
    catch (exception) {}
    return null;
  }

  static Future<bool> addDevice(String deviceId, String firebaseId, String firebaseEmail) async {
    try {
      String url = "http://13.235.186.224/devices";
      Map<String, String> headers = {
        'Authorization': 'Bearer firebase:'+firebaseEmail+':'+firebaseId
      };
      Map<String, String> body = {
        "deviceId": deviceId
      };
      RequestResult result = await Request.post(url, body: body, headers: headers);
      if (result.success) {
        return true;
      }
    }
    catch (exception) {}
    return false;
  }
}
