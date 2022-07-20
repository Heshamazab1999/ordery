

import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/email_checker.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/auth_provider.dart';
import 'package:flutter_grocery/provider/news_letter_provider.dart';
import 'package:flutter_grocery/provider/profile_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/text_hover.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom_snackbar.dart';
class FooterView extends StatelessWidget {
  const FooterView({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    TextEditingController _newsLetterController = TextEditingController();
    final bool isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    return Container(
      color: ColorResources.getAppBarHeaderColor(context),
      width: double.maxFinite,
      child: Center(
        child: Column(
          children: [
            SizedBox(
              width: Dimensions.WEB_SCREEN_WIDTH,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: Dimensions.PADDING_SIZE_LARGE ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Text(Provider.of<SplashProvider>(context).configModel.ecommerceName ?? AppConstants.APP_NAME,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.w800,fontSize: 44,color: Theme.of(context).primaryColor),),
                              ),
                            ],
                          ),
                          const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          Text(getTranslated('news_letter', context), style: poppinsBold.copyWith(color: ColorResources.getFooterTextColor(context),fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),

                          const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          Text(getTranslated('subscribe_to_out_new_channel_to_get_latest_updates', context), style: poppinsRegular.copyWith(color: ColorResources.getFooterTextColor(context),fontSize: Dimensions.FONT_SIZE_DEFAULT)),

                          const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                          Container(
                            width: 400,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SIZE_DEFAULT),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorResources.Black_COLOR.withOpacity(0.05),
                                    blurRadius: 2,
                                  )
                                ]
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 20),
                                Expanded(child: TextField(
                                  controller: _newsLetterController,
                                  style: poppinsRegular.copyWith(color: ColorResources.Black_COLOR),
                                  decoration: InputDecoration(
                                    hintText: getTranslated('your_email_address', context),
                                    hintStyle: poppinsRegular.copyWith(color: ColorResources.getGreyColor(context),fontSize: Dimensions.FONT_SIZE_LARGE),
                                    border: InputBorder.none,
                                  ),
                                  maxLines: 1,

                                )),
                                InkWell(
                                  onTap: (){
                                    String email = _newsLetterController.text.trim().toString();
                                    if (email.isEmpty) {
                                      showCustomSnackBar(getTranslated('enter_email_address', context), context);
                                    }else if (EmailChecker.isNotValid(email)) {
                                      showCustomSnackBar(getTranslated('enter_valid_email', context), context);
                                    }else{
                                      Provider.of<NewsLetterProvider>(context, listen: false).addToNewsLetter(context, email).then((value) {
                                        _newsLetterController.clear();
                                      });
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 2,vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SIZE_DEFAULT),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                                    child: Text(getTranslated('subscribe', context), style: poppinsRegular.copyWith(color: Colors.white,fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                          // const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                          Consumer<SplashProvider>(
                              builder: (context, splashProvider, child) {

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if(splashProvider.configModel.socialMediaLink.length != null && splashProvider.configModel.socialMediaLink.length > 0)  Text(getTranslated('follow_us_on', context), style: poppinsRegular.copyWith(color: ColorResources.getFooterTextColor(context),fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                                    Container(height: 50,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: splashProvider.configModel.socialMediaLink.length,
                                        itemBuilder: (BuildContext context, index){
                                          String name = splashProvider.configModel.socialMediaLink[index].name;
                                          String icon;
                                          if(name == 'facebook'){
                                            icon = Images.facebook;
                                          }else if(name == 'linkedin'){
                                            icon = Images.linked_in_icon;
                                          } else if(name == 'youtube'){
                                            icon = Images.youtube;
                                          }else if(name == 'twitter'){
                                            icon = Images.twitter;
                                          }else if(name == 'instagram'){
                                            icon = Images.in_sta_gram_icon;
                                          }else if(name == 'pinterest'){
                                            icon = Images.pinterest;
                                          }
                                          return  splashProvider.configModel.socialMediaLink.length > 0 ?
                                          InkWell(
                                            onTap: (){
                                              _launchURL(splashProvider.configModel.socialMediaLink[index].link);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: Image.asset(icon,height: Dimensions.PADDING_SIZE_EXTRA_LARGE,width: Dimensions.PADDING_SIZE_EXTRA_LARGE,fit: BoxFit.contain),
                                            ),
                                          ):SizedBox();

                                        },),
                                    ),
                                  ],
                                );
                              }
                          ),

                        ],
                      )),
                  Provider.of<SplashProvider>(context, listen: false).configModel.playStoreConfig.status || Provider.of<SplashProvider>(context, listen: false).configModel.appStoreConfig.status?
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        const SizedBox(height: Dimensions.PADDING_SIZE_LARGE * 2),
                        Text( Provider.of<SplashProvider>(context, listen: false).configModel.playStoreConfig.status && Provider.of<SplashProvider>(context, listen: false).configModel.appStoreConfig.status
                            ? getTranslated('download_our_apps', context) : getTranslated('download_our_app', context), style: poppinsBold.copyWith(color: ColorResources.getFooterTextColor(context),fontSize: Dimensions.FONT_SIZE_LARGE)),
                        const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Provider.of<SplashProvider>(context, listen: false).configModel.playStoreConfig.status?
                            InkWell(onTap:(){
                              _launchURL(Provider.of<SplashProvider>(context, listen: false).configModel.playStoreConfig.link);
                            },child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Image.asset(Images.play_store,height: 50,fit: BoxFit.contain),
                            )):SizedBox(),
                            Provider.of<SplashProvider>(context, listen: false).configModel.appStoreConfig.status?
                            InkWell(onTap:(){
                              _launchURL(Provider.of<SplashProvider>(context, listen: false).configModel.appStoreConfig.link);
                            },child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Image.asset(Images.app_store,height: 50,fit: BoxFit.contain),
                            )):SizedBox(),
                          ],)
                      ],
                    ),
                  ) : SizedBox(),
                  Expanded(flex: 2,child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Dimensions.PADDING_SIZE_LARGE * 2),
                      Text(getTranslated('my_account', context), style: poppinsBold.copyWith(color: ColorResources.getFooterTextColor(context),fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                      const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),


                      Consumer<ProfileProvider>(
                        builder: (context, profileProvider, child) {
                          return TextHover(
                              builder: (hovered) {
                                return InkWell(
                                    onTap: (){
                                      isLoggedIn? Navigator.pushNamed(context,
                                        RouteHelper.getProfileEditRoute(
                                            profileProvider.userInfoModel.fName, profileProvider.userInfoModel.lName,
                                            profileProvider.userInfoModel.email, profileProvider.userInfoModel.phone,
                                            profileProvider.userInfoModel.image ?? ''
                                        ),
                                        // arguments: ProfileEditScreen(userInfoModel: profileProvider.userInfoModel),
                                      ) : Navigator.pushNamed(context, RouteHelper.getLoginRoute());
                                      },
                                    child: Text(getTranslated('profile', context), style: hovered? poppinsMedium.copyWith(color: Theme.of(context).primaryColor) : poppinsRegular.copyWith(color: ColorResources.getFooterTextColor(context),fontSize: Dimensions.FONT_SIZE_DEFAULT)));
                              }
                          );
                        }
                      ),
                      const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      TextHover(
                          builder: (hovered) {
                            return InkWell(
                                onTap: (){
                                  Navigator.pushNamed(context, RouteHelper.address);
                                },
                                child: Text(getTranslated('address', context), style: hovered? poppinsMedium.copyWith(color: Theme.of(context).primaryColor) : poppinsRegular.copyWith(color: ColorResources.getFooterTextColor(context),fontSize: Dimensions.FONT_SIZE_DEFAULT)));
                          }
                      ),
                      const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      TextHover(
                          builder: (hovered) {
                            return InkWell(
                                onTap: (){
                                  Navigator.pushNamed(context, RouteHelper.getChatRoute(orderModel: null));
                                },
                                child: Text(getTranslated('live_chat', context), style: hovered? poppinsMedium.copyWith(color: Theme.of(context).primaryColor) : poppinsRegular.copyWith(color: ColorResources.getFooterTextColor(context),fontSize: Dimensions.FONT_SIZE_DEFAULT)));
                          }
                      ),
                      const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      TextHover(
                          builder: (hovered) {
                            return InkWell(
                                onTap: (){
                                  Navigator.pushNamed(context, RouteHelper.myOrder);
                                },
                                child: Text(getTranslated('my_order', context), style: hovered? poppinsMedium.copyWith(color: Theme.of(context).primaryColor) : poppinsRegular.copyWith(color: ColorResources.getFooterTextColor(context),fontSize: Dimensions.FONT_SIZE_DEFAULT)));
                          }
                      ),

                    ],)),
                  Expanded(flex: 2,child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Dimensions.PADDING_SIZE_LARGE * 2),
                      Text(getTranslated('quick_links', context), style: poppinsBold.copyWith(color: ColorResources.getFooterTextColor(context),fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                      const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                      TextHover(
                          builder: (hovered) {
                            return InkWell(
                                onTap: () =>  Navigator.pushNamed(context, RouteHelper.getContactRoute()),
                                child: Text(getTranslated('contact_us', context), style: hovered? poppinsMedium.copyWith(color: Theme.of(context).primaryColor) : poppinsRegular.copyWith(color: ColorResources.getFooterTextColor(context),fontSize: Dimensions.FONT_SIZE_DEFAULT)));
                          }
                      ),
                      const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      TextHover(
                          builder: (hovered) {
                            return InkWell(
                                onTap: () => Navigator.pushNamed(context, RouteHelper.getPolicyRoute()),
                                child: Text(getTranslated('privacy_policy', context), style: hovered? poppinsMedium.copyWith(color: Theme.of(context).primaryColor) : poppinsRegular.copyWith(color: ColorResources.getFooterTextColor(context),fontSize: Dimensions.FONT_SIZE_DEFAULT)));
                          }
                      ),
                      const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                      TextHover(
                          builder: (hovered) {
                            return InkWell(
                                onTap: () => Navigator.pushNamed(context, RouteHelper.getTermsRoute()),
                                child: Text(getTranslated('terms_and_condition', context), style: hovered? poppinsMedium.copyWith(color: Theme.of(context).primaryColor) : poppinsRegular.copyWith(color: ColorResources.getFooterTextColor(context),fontSize: Dimensions.FONT_SIZE_DEFAULT)));
                          }
                      ),
                      const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      TextHover(
                          builder: (hovered) {
                            return InkWell(
                                onTap: () => Navigator.pushNamed(context, RouteHelper.getAboutUsRoute()),
                                child: Text(getTranslated('about_us', context), style: hovered? poppinsMedium.copyWith(color: Theme.of(context).primaryColor) : poppinsRegular.copyWith(color: ColorResources.getFooterTextColor(context),fontSize: Dimensions.FONT_SIZE_DEFAULT)));
                          }
                      ),

                    ],)),
                ],
              ),
            ),
            Divider(thickness: .5),
            SizedBox(
              width: 500.0,
              child: Text(Provider.of<SplashProvider>(context,listen: false).configModel.footerCopyright ??
                  '${getTranslated('copyright', context)} ${Provider.of<SplashProvider>(context,listen: false).configModel.ecommerceName}',
                  overflow: TextOverflow.ellipsis,maxLines: 1,textAlign: TextAlign.center),
            ),

            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT)
          ],
        ),
      ),
    );
  }
}
_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}