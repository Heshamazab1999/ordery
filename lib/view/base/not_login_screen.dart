import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';

import 'footer_view.dart';


class NotLoggedInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.height - 400 : MediaQuery.of(context).size.height),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  Image.asset(
                    Images.order_placed,
                    width: MediaQuery.of(context).size.height*0.25,
                    height: MediaQuery.of(context).size.height*0.25,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.03),

                  Text(
                    getTranslated('guest_mode', context),
                    style: poppinsRegular.copyWith(fontSize: MediaQuery.of(context).size.height*0.023),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.02),

                  Text(
                    getTranslated('now_you_are_in_guest_mode', context),
                    style: poppinsRegular.copyWith(fontSize: MediaQuery.of(context).size.height*0.0175),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.03),

                  SizedBox(
                    width: 100,
                    height: 45,
                    child: CustomButton(buttonText: getTranslated('login', context), onPressed: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
                      Navigator.pushNamed(context, RouteHelper.login);
                    }),
                  ),
                ],),
              ),
            ),
          ),

          ResponsiveHelper.isDesktop(context) ? FooterView() : SizedBox(),


        ]),
      ),
    );
  }
}
