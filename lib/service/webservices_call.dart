import 'dart:convert';
import 'dart:io';

import 'package:qleedo/service/app_exceptions.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:qleedo/service/base_services.dart';
import 'package:qleedo/index.dart';

class WebService extends BaseService {
  @override
  Future getResponse(String url, var headers) async {
    try {
      final response = await http.get(Uri.parse(qleedoAPIUrl + url), headers: headers);
      return returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } catch (e) {
      throw FetchDataException('Error During Communication: $e');
    }
  }


  @visibleForTesting
  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while communication with server' +
                ' with status code : ${response.statusCode}');
    }
  }

  @override
  Future<http.Response> postResponse(String url, var body, var headers) async {
    //print('headers' + body.toString());
    dynamic responseJson;
    try {
      responseJson = await http.post(
        Uri.parse(qleedoAPIUrl + url),
        body: json.encode(body),
        headers: headers,
      );
      //print('...${responseJson.statusCode}......#########...55....${responseJson.body.toString()}');

    } on Exception catch (e) {
      print(".......response....555555...$e....");
      //throw FetchDataException('No Internet Connection');
      var message = {"status": -1, "message": "request failed"};
      return http.Response(json.encode(message), HttpStatus.unauthorized);
    }

    return responseJson;
  }


  @override
  Future putResponse(String url, var body, var headers) async {
    http.Response responseJson;
    try {
      final response = await http.put(
        Uri.parse(qleedoAPIUrl + url),
        body: body,
        headers: headers,
      );
      //print('response' + body.toString() + response.body.toString());
      if (response.statusCode == 200) {
        responseJson = response;
      } else {
        responseJson = response;
      }
    } on Exception {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  @override
  Future<http.Response> patchResponse(String url, var body, var headers) async {
    http.Response responseJson;
    try {
      final response = await http.patch(
        Uri.parse(qleedoAPIUrl + url),
        body: body,
        headers: headers,
      );
      //print('response' + body.toString() + response.body.toString());
      if (response.statusCode == 200) {
        responseJson = response;
      } else {
        responseJson = response;
      }
    } on Exception {
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  @override
  Future<http.Response> deleteResponse(String url,var headers) async {
    http.Response responseJson;
    try {
      responseJson = await http.delete(
        Uri.parse(qleedoAPIUrl + url),
        headers: headers,
      );
      //print('....$url.......deleteResponse........'+  responseJson.body.toString());
    } on Exception {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }
}
