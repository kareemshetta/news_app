import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioHelper {
  static late Dio dio;
  // here we initialize our dio variable this method we be triggered in runApp()
  static init() {
    // we make instance of dio with the base url
    dio = Dio(
      BaseOptions(
          baseUrl: 'https://newsapi.org/', receiveDataWhenStatusError: true),
    );
  }

//api key: 1f24543a14e54e83845d980f830e1e57

  // here we create static method to get data from api this method takes url:method
  // and map of string ,dynamic
  static Future<Response> getData(
      {required String url, required Map<String, dynamic> queries}) async {
    // here we wait until get method get data
    return await dio.get(url, queryParameters: queries);
  }
}
