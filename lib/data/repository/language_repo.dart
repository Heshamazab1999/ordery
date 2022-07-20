import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/language_model.dart';
import 'package:flutter_grocery/utill/app_constants.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({BuildContext context}) {
    return AppConstants.languages;
  }
}
