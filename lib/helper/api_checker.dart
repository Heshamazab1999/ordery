import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/base/api_response.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';
import 'package:flutter_grocery/view/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';

class ApiChecker {
  static void checkApi(BuildContext context, ApiResponse apiResponse) {
    if(apiResponse.error is! String && apiResponse.error.errors[0].message == 'Unauthenticated.') {
      Provider.of<SplashProvider>(context, listen: false).removeSharedData();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
    }else if(apiResponse.response.statusCode==404){

    }
    else {
      String _errorMessage;
      if (apiResponse.error is String) {
        _errorMessage = apiResponse.error.toString();
      } else {
        _errorMessage = apiResponse.error.errors[0].message;
      }
      print(_errorMessage);
      showCustomSnackBar(_errorMessage, context,isError: true);
       }
  }
}