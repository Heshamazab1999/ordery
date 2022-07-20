import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/utill/dimensions.dart';

void showCustomSnackBar(String message, BuildContext context, {bool isError = true}) {
  final _width = MediaQuery.of(context).size.width;
  ResponsiveHelper.isDesktop(context) ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),
      margin: ResponsiveHelper.isDesktop(context) ?  EdgeInsets.only(right: _width * 0.75, bottom: Dimensions.PADDING_SIZE_LARGE, left: Dimensions.PADDING_SIZE_EXTRA_SMALL) : EdgeInsets.only(bottom:Dimensions.PADDING_SIZE_SMALL),
      behavior: SnackBarBehavior.floating ,
      dismissDirection: DismissDirection.down,
      duration: Duration(milliseconds: ResponsiveHelper.isDesktop(context) ? 1000 : 600),
      backgroundColor: isError ? Colors.red : Colors.green)
  ):
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
         backgroundColor: isError ? Colors.red : Colors.green,
         behavior: SnackBarBehavior.floating ,
         margin: const EdgeInsets.all(10),
         content: Text(message),
         duration: Duration(seconds: 2),
  ));
}
