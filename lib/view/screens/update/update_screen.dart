import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final _splashProvider =  Provider.of<SplashProvider>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

            Image.asset(Images.update,
              width: MediaQuery.of(context).size.height*0.4,
              height: MediaQuery.of(context).size.height*0.4,
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.01),

            Text(getTranslated('your_app_is_deprecated', context),
              style: poppinsRegular.copyWith(fontSize: MediaQuery.of(context).size.height*0.0175, color: Theme.of(context).disabledColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.04),

             CustomButton(buttonText: getTranslated('update_now', context), onPressed: () async {
              String _appUrl = 'https://google.com';
              if(Platform.isAndroid) {
                _appUrl = _splashProvider.configModel.playStoreConfig.link;
              }else if(Platform.isIOS) {
                _appUrl = _splashProvider.configModel.appStoreConfig.link;
              }
              if(await canLaunch(_appUrl)) {
                launch(_appUrl);
              }else {
                showCustomSnackBar('${getTranslated('can_not_launch', context)} $_appUrl', context);
              }
            }),

          ]),
        ),
      ),
    );
  }
}
