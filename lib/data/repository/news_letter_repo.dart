
import 'package:flutter/material.dart';
import '../../utill/app_constants.dart';
import '../datasource/remote/dio/dio_client.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/response/base/api_response.dart';

class NewsLetterRepo {
  final DioClient dioClient;

  NewsLetterRepo({@required this.dioClient});

  Future<ApiResponse> addToNewsLetter(String  email) async {
    try {
      final response = await dioClient.post(AppConstants.EMAIL_SUBSCRIBE_URI, data: {'email':email});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

}
