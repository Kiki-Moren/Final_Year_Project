import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import 'dart:convert';

import 'exceptions.dart';

abstract class Network {
  Future<dynamic> get(
    String route, {
    Map<String, dynamic> incomingHeaders = const {},
  });
  Future<dynamic> post(
    String route, {
    required dynamic form,
    bool isFormData = false,
    List<String>? filePaths,
    List<File>? files,
    Map<String, dynamic> incomingHeaders = const {},
  });
  Future<dynamic> delete(
    String route, {
    Map<String, dynamic> incomingHeaders = const {},
  });
  Future<dynamic> patch(
    String route, {
    required dynamic form,
    bool isFormData = false,
    String? filePath,
    File? file,
    Map<String, dynamic> incomingHeaders = const {},
  });
  Future<dynamic> put(
    String route, {
    required dynamic form,
    bool isFormData = false,
    String? filePath,
    File? file,
    Map<String, dynamic> incomingHeaders = const {},
  });
}

class NetworkImplementation extends Network {
  Map<String, String> createHeaders(Map<String, dynamic> incomingHeaders) {
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      // if (BearerToken.token != null) "authorization": BearerToken.token!,
      ...incomingHeaders,
    };
  }

  dynamic handleResponse(http.Response response) {
    if (!isSuccessResponse(response.statusCode)) {
      var decodedResponse = json.decode(response.body);
      throw CustomException(
        message: decodedResponse["message"] ??
            decodedResponse["Message"] ??
            decodedResponse["messsage"],
        statusCode: response.statusCode,
      );
    } else {
      return json.decode(response.body);
    }
  }

  dynamic handleFormResponse(http.StreamedResponse response) async {
    if (!isSuccessResponse(response.statusCode)) {
      var data = await response.stream.bytesToString();
      var decodedResponse = json.decode(data);
      throw CustomException(
        message: decodedResponse["message"] ?? decodedResponse["Message"],
        statusCode: response.statusCode,
      );
    } else {
      var data = await response.stream.bytesToString();
      return json.decode(data);
    }
  }

  String? checkMediaType(File file) {
    String? mediaType = lookupMimeType(file.path);
    return mediaType;
  }

  bool isSuccessResponse(int number) => number >= 200 && number <= 299;

  @override
  Future delete(
    String route, {
    Map<String, dynamic> incomingHeaders = const {},
  }) async {
    Map<String, String> headers = createHeaders(incomingHeaders);

    Logger().d(route);

    try {
      http.Response response = await http.delete(
        Uri.parse(route),
        headers: headers,
      );

      return handleResponse(response);
    } on CustomException catch (e) {
      throw CustomException(message: e.toString(), statusCode: e.statusCode);
    } on TimeoutException catch (_) {
      throw CustomException(
        message: 'Network error, Connection timed out, please try again',
        statusCode: 499,
      );
    }
  }

  @override
  Future get(
    String route, {
    Map<String, dynamic> incomingHeaders = const {},
  }) async {
    Map<String, String> headers = createHeaders(incomingHeaders);

    Logger().d(route);

    try {
      http.Response response = await http.get(
        Uri.parse(route),
        headers: headers,
      );

      return handleResponse(response);
    } on CustomException catch (e) {
      throw CustomException(message: e.toString(), statusCode: e.statusCode);
    } on TimeoutException catch (_) {
      throw CustomException(
        message: 'Network error, Connection timed out, please try again',
        statusCode: 499,
      );
    }
  }

  @override
  Future patch(
    String route, {
    required form,
    bool isFormData = false,
    String? filePath,
    File? file,
    Map<String, dynamic> incomingHeaders = const {},
  }) async {
    Map<String, String> headers = createHeaders(incomingHeaders);

    Logger().d(route);

    try {
      if (isFormData) {
        var request = http.MultipartRequest(
          'PATCH',
          Uri.parse(route),
        );

        request.headers.addAll(headers);

        request.fields.addAll(form);

        request.files.add(
          await http.MultipartFile.fromPath(filePath!, file!.path),
        );

        http.StreamedResponse response = await request.send().timeout(
              const Duration(seconds: 60),
            );

        return handleFormResponse(response);
      } else {
        http.Response response = await http.patch(
          Uri.parse(route),
          body: json.encode(form),
          headers: headers,
        );

        return handleResponse(response);
      }
    } on CustomException catch (e) {
      throw CustomException(message: e.toString(), statusCode: e.statusCode);
    } on TimeoutException catch (_) {
      throw CustomException(
        message: 'Network error, Connection timed out, please try again',
        statusCode: 499,
      );
    }
  }

  @override
  Future post(
    String route, {
    required form,
    bool isFormData = false,
    List<String>? filePaths,
    List<File>? files,
    Map<String, dynamic> incomingHeaders = const {},
  }) async {
    Map<String, String> headers = createHeaders(incomingHeaders);

    Logger().d(route);

    try {
      if (isFormData) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(route),
        );

        request.fields.addAll(form);

        request.headers.addAll(headers);

        for (int i = 0; i < filePaths!.length; i++) {
          request.files.add(
            await http.MultipartFile.fromPath(
              filePaths[i],
              files![i].path,
              contentType: MediaType.parse(checkMediaType(files[i]) ?? ""),
            ),
          );
        }

        http.StreamedResponse response = await request.send().timeout(
              const Duration(seconds: 60),
            );

        return handleFormResponse(response);
      } else {
        Logger().d(json.encode(form));

        http.Response response = await http.post(
          Uri.parse(route),
          body: json.encode(form),
          headers: headers,
        );

        return handleResponse(response);
      }
    } on CustomException catch (e) {
      throw CustomException(message: e.toString(), statusCode: e.statusCode);
    } on TimeoutException catch (_) {
      throw CustomException(
        message: 'Network error, Connection timed out, please try again',
        statusCode: 499,
      );
    }
  }

  @override
  Future put(
    String route, {
    required form,
    bool isFormData = false,
    String? filePath,
    File? file,
    Map<String, dynamic> incomingHeaders = const {},
  }) async {
    Map<String, String> headers = createHeaders(incomingHeaders);

    Logger().d(route);

    try {
      if (isFormData) {
        var request = http.MultipartRequest(
          'PUT',
          Uri.parse(route),
        );

        request.headers.addAll(headers);

        request.fields.addAll(form);

        request.files.add(
          await http.MultipartFile.fromPath(filePath!, file!.path),
        );

        http.StreamedResponse response = await request.send().timeout(
              const Duration(seconds: 60),
            );

        return handleFormResponse(response);
      } else {
        Logger().d(json.encode(form));

        http.Response response = await http.put(
          Uri.parse(route),
          body: json.encode(form),
          headers: headers,
        );

        return handleResponse(response);
      }
    } on CustomException catch (e) {
      throw CustomException(message: e.toString(), statusCode: e.statusCode);
    } on TimeoutException catch (_) {
      throw CustomException(
        message: 'Network error, Connection timed out, please try again',
        statusCode: 499,
      );
    }
  }
}
