
import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/profile_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/footer_view.dart';
import 'package:flutter_grocery/view/screens/menu/widget/sign_out_confirmation_dialog.dart';
import 'package:flutter_grocery/view/screens/notification/notification_screen.dart';
import 'package:provider/provider.dart';

import 'menu_item_web.dart';

class MenuScreenWeb extends StatelessWidget {
  final bool isLoggedIn;
  const MenuScreenWeb({Key key, @required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
            children: [
              Center(
                child: Consumer<ProfileProvider>(
                  builder: (context, profileProvider, child) {
                    return ConstrainedBox(
                      constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.height - 400 : MediaQuery.of(context).size.height),
                      child: SizedBox(
                        width: 1170,
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Container(
                                    height: 150,  color:  Theme.of(context).primaryColor.withOpacity(0.5),
                                 alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 240.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      isLoggedIn ? profileProvider.userInfoModel != null ? Text(
                                        '${profileProvider.userInfoModel.fName ?? ''} ${profileProvider.userInfoModel.lName ?? ''}',
                                        style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: ColorResources.getTextColor(context)),
                                      ) : SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT, width: 150) : Text(
                                        getTranslated('guest', context),
                                        style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: ColorResources.getTextColor(context)),
                                      ),
                                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                      isLoggedIn ? profileProvider.userInfoModel != null ? Text(
                                        '${profileProvider.userInfoModel.email ?? ''}',
                                        style: poppinsRegular.copyWith(color: ColorResources.getTextColor(context)),
                                      ) : SizedBox(height: 15, width: 100) : Text(
                                        'demo@demo.com',
                                        style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: ColorResources.getTextColor(context)),
                                      ),
                                     /* SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                      isLoggedIn ? profileProvider.userInfoModel != null ? Text(
                                        '${getTranslated('points', context)}: ${profileProvider.userInfoModel.point ?? ''}',
                                        style: poppinsRegular.copyWith(color: ColorResources.getWhiteAndBlack(context)),
                                      ) : Container(height: 15, width: 100, color: Colors.white) : SizedBox(),*/


                                    ],
                                  ),

                                ),
                                SizedBox(height: 100),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        MenuItemWeb(image: Images.order_list, title: getTranslated('my_order', context), onTap: () => Navigator.pushNamed(context, RouteHelper.myOrder)),
                                        MenuItemWeb(image: Images.profile, title: getTranslated('profile', context),
                                          onTap: (){
                                            isLoggedIn? Navigator.pushNamed(context,
                                            RouteHelper.getProfileEditRoute(
                                                profileProvider.userInfoModel.fName, profileProvider.userInfoModel.lName,
                                                profileProvider.userInfoModel.email, profileProvider.userInfoModel.phone,
                                                profileProvider.userInfoModel.image ?? ''
                                            ),
                                            // arguments: ProfileEditScreen(userInfoModel: profileProvider.userInfoModel),
                                          ) : Navigator.pushNamed(context, RouteHelper.getLoginRoute());
                                        },),
                                        MenuItemWeb(image: Images.location, title: getTranslated('address', context), onTap: () => Navigator.pushNamed(context, RouteHelper.address)),
                                        MenuItemWeb(image: Images.chat, title: getTranslated('live_chat', context), onTap: () => Navigator.pushNamed(context, RouteHelper.getChatRoute(orderModel: null))),
                                        MenuItemWeb(image: Images.coupon, title: getTranslated('coupon', context), onTap: () => Navigator.pushNamed(context, RouteHelper.coupon)),
                                        MenuItemWeb(image: Images.notification, title: getTranslated('notifications', context), onTap: () => Navigator.pushNamed(context, RouteHelper.notification, arguments: NotificationScreen())),
                                      ],
                                    ),
                                    SizedBox(height: 40),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        MenuItemWeb(image: Images.language, title: getTranslated('contact_us', context),  onTap: () => Navigator.pushNamed(context, RouteHelper.getContactRoute())),
                                        MenuItemWeb(image: Images.order_bag, title: getTranslated('shopping_bag', context), onTap: () => Navigator.pushNamed(context, RouteHelper.cart)),
                                        MenuItemWeb(image: Images.privacy_policy, title: getTranslated('privacy_policy', context), onTap: () => Navigator.pushNamed(context, RouteHelper.getPolicyRoute())),
                                        MenuItemWeb(image: Images.terms_and_conditions, title: getTranslated('terms_and_condition', context), onTap: () => Navigator.pushNamed(context, RouteHelper.getTermsRoute())),
                                        MenuItemWeb(image: Images.about_us, title: getTranslated('about_us', context), onTap: () => Navigator.pushNamed(context, RouteHelper.getAboutUsRoute())),
                                        MenuItemWeb(image: Images.login, title: getTranslated(isLoggedIn ? 'log_out' : 'login', context),
                                         onTap: (){
                                           if(isLoggedIn) {
                                             showDialog(context: context, barrierDismissible: false, builder: (context) => SignOutConfirmationDialog());
                                           }else {
                                             Provider.of<SplashProvider>(context, listen: false).setPageIndex(0);
                                             Navigator.pushNamed(context, RouteHelper.getLoginRoute());
                                           }
                                         },
                                         /* onTap: () => isLoggedIn ? showDialog(context: context, barrierDismissible: false, builder: (context) => SignOutConfirmationDialog()) : Provider.of<SplashProvider>(context, listen: false).setPageIndex(0);
                                            Navigator.pushNamedAndRemoveUntil(context, RouteHelper.getLoginRoute(), (route) => false);,*/
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 50.0)
                                  ],
                                ),
                              ],
                            ),
                            Positioned(
                              left: 30,
                              top: 45,
                              child: Container(
                                height: 180, width: 180,
                                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4),
                                    boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 22, offset: Offset(0, 8.8) )]),
                                child: ClipOval(
                                  child: isLoggedIn ? FadeInImage.assetNetwork(
                                    placeholder: Images.placeholder(context), height: 170, width: 170, fit: BoxFit.cover,
                                    image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/'
                                        '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel.image : ''}',
                                    imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder(context), height: 170, width: 170, fit: BoxFit.cover),
                                  ) : Image.asset(Images.placeholder(context), height: 170, width: 170, fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                ),
              ),
              FooterView(),
            ],
      ),
    );
  }
}
