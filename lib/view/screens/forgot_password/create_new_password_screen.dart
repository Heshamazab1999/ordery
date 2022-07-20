import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/auth_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_app_bar.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';
import 'package:flutter_grocery/view/base/custom_text_field.dart';
import 'package:flutter_grocery/view/base/footer_view.dart';
import 'package:flutter_grocery/view/base/main_app_bar.dart';
import 'package:flutter_grocery/view/base/web_app_bar/web_app_bar.dart';
import 'package:provider/provider.dart';

class CreateNewPasswordScreen extends StatelessWidget {
  final String resetToken;
  final String email;

  CreateNewPasswordScreen({@required this.resetToken, @required this.email});

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorResources.getCardBgColor(context),
      appBar: ResponsiveHelper.isDesktop(context)? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120)): CustomAppBar(title: getTranslated('create_new_password', context)),
      body: Center(
        child: SingleChildScrollView(
          physics: ResponsiveHelper.isDesktop(context) ? AlwaysScrollableScrollPhysics() : BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.height - 560 : MediaQuery.of(context).size.height),
                child: Container(
                  width: 1170,
                  child: Consumer<AuthProvider>(
                    builder: (context, auth, child) {
                      return Scrollbar(
                        child: Center(
                          child: Container(
                            width: _width > 700 ? 700 : _width,
                            padding: _width > 700 ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT) : null,
                            margin: _width > 700 ? EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_LARGE) : null,
                            decoration: _width > 700 ? BoxDecoration(
                              color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 5, spreadRadius: 1)],
                            ) : null,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 30),
                                Center(child: Image.asset(Images.open_lock, width: 142, height: 142, color: Theme.of(context).primaryColor)),
                                SizedBox(height: 30),
                                Center(
                                    child: Text(
                                  getTranslated('enter_password_to_create', context),
                                  textAlign: TextAlign.center,
                                  style: poppinsRegular.copyWith(color: ColorResources.getHintColor(context)),
                                )),
                                Padding(
                                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // for password section

                                      SizedBox(height: 30),
                                      Text(
                                        getTranslated('new_password', context),
                                        style: poppinsRegular.copyWith(color: ColorResources.getHintColor(context)),
                                      ),
                                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                      CustomTextField(
                                        hintText: getTranslated('password_hint', context),
                                        isShowBorder: true,
                                        isPassword: true,
                                        focusNode: _passwordFocus,
                                        nextFocus: _confirmPasswordFocus,
                                        isShowSuffixIcon: true,
                                        inputAction: TextInputAction.next,
                                        controller: _passwordController,
                                      ),
                                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                                      // for confirm password section
                                      Text(
                                        getTranslated('confirm_password', context),
                                        style: poppinsRegular.copyWith(color: ColorResources.getHintColor(context)),
                                      ),
                                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                      CustomTextField(
                                        hintText: getTranslated('password_hint', context),
                                        isShowBorder: true,
                                        isPassword: true,
                                        isShowSuffixIcon: true,
                                        focusNode: _confirmPasswordFocus,
                                        controller: _confirmPasswordController,
                                        inputAction: TextInputAction.done,
                                      ),

                                      SizedBox(height: 24),
                                      !auth.isForgotPasswordLoading
                                          ? SizedBox(
                                              width: double.infinity,
                                              child: CustomButton(
                                                buttonText: getTranslated('save', context),
                                                onPressed: () {
                                                  String _password = _passwordController.text.trim();
                                                  String _confirmPassword = _confirmPasswordController.text.trim();
                                                  if (_password.isEmpty) {
                                                    showCustomSnackBar(getTranslated('enter_new_password', context), context);
                                                  } else if(_password.length < 6) {
                                                    showCustomSnackBar(getTranslated('password_should_be', context), context);
                                                  } else if (_confirmPassword.isEmpty) {
                                                    showCustomSnackBar(getTranslated('confirm_new_password', context), context);
                                                  } else if (_password != _confirmPassword) {
                                                    showCustomSnackBar(getTranslated('password_did_not_match', context), context);
                                                  } else {
                                                    auth.resetPassword(email, resetToken, _password, _confirmPassword).then((value) {
                                                      if (value.isSuccess) {
                                                        auth.login(email, _password).then((value) {
                                                          Navigator.pushNamedAndRemoveUntil(context, RouteHelper.menu, (route) => false);
                                                        });
                                                      } else {
                                                        showCustomSnackBar(value.message, context);
                                                      }
                                                    });
                                                  }
                                                },
                                              ),
                                            )
                                          : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              ResponsiveHelper.isDesktop(context)? FooterView() : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
