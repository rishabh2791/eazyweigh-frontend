import 'dart:convert';
import 'dart:io';

import 'package:eazyweigh/infrastructure/utilities/constants.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';
import 'package:http/http.dart' as http;

NetworkAPIProvider networkAPIProvider = NetworkAPIProvider();

class NetworkAPIProvider {
  Future<Map<String, dynamic>> get(
      String url, Map<String, String> headers) async {
    var responseJSON = <String, dynamic>{};

    try {
      var uri = Uri.parse(baseURL + url);
      isLoadingServerData = true;
      await http.get(uri, headers: headers).then((response) {
        isLoadingServerData = false;
        responseJSON = json.decode(response.body.toString());
      });
    } on SocketException {
      responseJSON = {"error": "Socket Exception"};
    } on FormatException {
      responseJSON = {"error": "Format Exception"};
    } on HttpException {
      responseJSON = {"error": "HTTP Exception"};
    }
    return responseJSON;
  }

  Future<Map<String, dynamic>> post(
      String url, dynamic payload, Map<String, String> headers) async {
    var responseJSON = <String, dynamic>{};

    headers["Content-Type"] = "application/text";
    try {
      var uri = Uri.parse(baseURL + url);
      isLoadingServerData = true;
      await http
          .post(uri, headers: headers, body: json.encode(payload))
          .then((response) {
        isLoadingServerData = false;
        responseJSON = json.decode(response.body.toString());
      });
    } on Exception {
      responseJSON = {"error": "Network Exception"};
    }
    return responseJSON;
  }

  Future<Map<String, dynamic>> patch(String url, Map<String, dynamic> payload,
      Map<String, String> headers) async {
    var responseJSON = <String, dynamic>{};

    headers["Content-Type"] = "application/text";
    try {
      var uri = Uri.parse(baseURL + url);
      isLoadingServerData = true;
      await http
          .patch(uri, headers: headers, body: json.encode(payload))
          .then((response) {
        isLoadingServerData = false;
        responseJSON = json.decode(response.body.toString());
      });
    } on Exception {
      responseJSON = {"error": "Network Exception"};
    }
    return responseJSON;
  }

  Future<Map<String, dynamic>> put(String url, Map<String, dynamic> payload,
      Map<String, String> headers) async {
    var responseJSON = <String, dynamic>{};

    headers["Content-Type"] = "application/text";
    try {
      var uri = Uri.parse(baseURL + url);
      isLoadingServerData = true;
      await http
          .put(uri, headers: headers, body: json.encode(payload))
          .then((response) {
        isLoadingServerData = false;
        responseJSON = json.decode(response.body.toString());
      });
    } on Exception {
      responseJSON = {"error": "Network Exception"};
    }
    return responseJSON;
  }

  Future<Map<String, dynamic>> delete(
      String url, String id, Map<String, String> headers) async {
    var responseJSON = <String, dynamic>{};

    headers["Content-Type"] = "application/text";
    try {
      var uri = Uri.parse(baseURL + url);
      isLoadingServerData = true;
      await http.delete(uri).then((response) {
        isLoadingServerData = false;
        responseJSON = json.decode(response.body.toString());
      });
    } on Exception {
      responseJSON = {"error": "Network Exception"};
    }
    return responseJSON;
  }
}
