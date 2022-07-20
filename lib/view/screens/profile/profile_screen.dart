
import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/auth_provider.dart';
import 'package:flutter_grocery/provider/profile_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/footer_view.dart';
import 'package:flutter_grocery/view/base/not_login_screen.dart';
import 'package:flutter_grocery/view/base/web_app_bar/web_app_bar.dart';
import 'package:flutter_grocery/view/screens/profile/profile_edit_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: ResponsiveHelper.isDesktop(context)? ColorResources.getTryBgColor(context) : Theme.of(context).cardColor,
      appBar: ResponsiveHelper.isDesktop(context)? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120)): AppBar(
        backgroundColor: Theme.of(context).cardColor,
        leading: IconButton(
            icon: Image.asset(Images.more_icon, color: Theme.of(context).primaryColor),
            onPressed: () {
              Provider.of<SplashProvider>(context, listen: false).setPageIndex(0);
              Navigator.of(context).pop();
            }),
        title: Text(getTranslated('profile', context),
            style: poppinsMedium.copyWith(
              fontSize: Dimensions.FONT_SIZE_SMALL,
              color: Theme.of(context).textTheme.bodyText1.color,
            )),
      ),
      body: SafeArea(
        child: _isLoggedIn ? Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Scrollbar(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: ResponsiveHelper.isDesktop(context)
                    ? Center(
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.7),
                        child: SizedBox(
                          width: 1170,
                          child: Column(
                            children: [
                              Stack(
                                clipBehavior: Clip.none, children: [
                                  Container(
                                    height: 150,  color:  Theme.of(context).primaryColor.withOpacity(0.5),
                                  ),
                                  Positioned(
                                    left: 30,
                                    top: 45,
                                    child: Container(
                                      height: 180, width: 180,
                                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4),
                                          boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 22, offset: Offset(0, 8.8) )]),
                                      child: ClipOval(
                                        child: FadeInImage.assetNetwork(
                                          placeholder: Images.placeholder(context), height: 170, width: 170, fit: BoxFit.cover,
                                          image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/'
                                              '${profileProvider.userInfoModel != null ? profileProvider.userInfoModel.image : ''}',
                                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder(context), height: 170, width: 170, fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                  ),
                                Positioned(
                                    bottom: -10,
                                    right: 10,
                                    child: InkWell(
                                      onTap: (){
                                        Navigator.pushNamed(
                                          context,
                                          RouteHelper.getProfileEditRoute(
                                            profileProvider.userInfoModel.fName, profileProvider.userInfoModel.lName,
                                            profileProvider.userInfoModel.email, profileProvider.userInfoModel.phone,
                                            profileProvider.userInfoModel.image ?? ''
                                          ),
                                          // arguments: ProfileEditScreen(userInfoModel: profileProvider.userInfoModel),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        padding: EdgeInsets.all(5),
                                        child: Row(
                                        children: [
                                            Icon(Icons.edit,size: 16,color: Colors.white),
                                            Text(getTranslated('edit', context),
                                              style: poppinsMedium.copyWith(
                                                fontSize: Dimensions.FONT_SIZE_SMALL,
                                                color: Colors.white
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ))
                                ],
                              ),

                              /*Center(
                                  child: Text(
                                    '${profileProvider.userInfoModel.fName ?? ''} ${profileProvider.userInfoModel.lName ?? ''}',
                                    style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                                  )),*/

                              //mobileNumber,email,gender
                              SizedBox(height: 100),
                             profileProvider.isLoading ? CircularProgressIndicator() : Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getTranslated('mobile_number', context),
                                      style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: ColorResources.getHintColor(context)),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      '${profileProvider.userInfoModel.fName ?? ''} ${profileProvider.userInfoModel.lName ?? ''}',
                                      style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),
                                    ),
                                    Divider(),
                                    SizedBox(height: 25),
                                    // for first name section
                                    Text(
                                      getTranslated('mobile_number', context),
                                      style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: ColorResources.getHintColor(context)),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      '${profileProvider.userInfoModel.phone ?? ''}',
                                      style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),
                                    ),
                                    Divider(),
                                    SizedBox(height: 25),

                                    // for email section
                                    Text(
                                      getTranslated('email', context),
                                      style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: ColorResources.getHintColor(context)),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      '${profileProvider.userInfoModel.email ?? ''}',
                                      style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),
                                    ),
                                    Divider(),
                                    SizedBox(height: 25),

                                  ],
                                ),
                              ),


                            ],
                          ),
                        ),
                      ),
                      FooterView(),
                    ],
                  ),
                )
                : Center(
                  child: SizedBox(
                    width: 1170,
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 12, bottom: 12),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: ColorResources.getGreyColor(context), width: 2),
                                shape: BoxShape.circle),

                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: profileProvider.file == null ? FadeInImage.assetNetwork(
                                      placeholder: Images.placeholder(context),
                                      width: 100, height: 100, fit: BoxFit.cover,
                                      image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/${profileProvider.userInfoModel.image}',
                                        imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder(context), height: 100, width: 100, fit: BoxFit.cover)
                                    ) : Image.file(profileProvider.file, width: 100, height: 100, fit: BoxFit.fill),
                                  )
                            ),
                            Positioned(
                              right: -10,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    RouteHelper.getProfileEditRoute(
                                      profileProvider.userInfoModel.fName, profileProvider.userInfoModel.lName,
                                      profileProvider.userInfoModel.email, profileProvider.userInfoModel.phone,
                                      profileProvider.userInfoModel.image??''
                                    ),
                                    // arguments: ProfileEditScreen(userInfoModel: profileProvider.userInfoModel),
                                  );
                                 // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileEditScreen(userInfoModel: profileProvider.userInfoModel)));
                                },
                                child: Text(
                                  getTranslated('edit', context),
                                  style: poppinsMedium.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // for name
                        Center(
                            child: Text(
                          '${profileProvider.userInfoModel.fName ?? ''} ${profileProvider.userInfoModel.lName ?? ''}',
                          style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                        )),

                        //mobileNumber,email,gender
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // for first name section
                              Text(
                                getTranslated('mobile_number', context),
                                style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: ColorResources.getHintColor(context)),
                              ),
                              SizedBox(height: 6),
                              Text(
                                '${profileProvider.userInfoModel.phone ?? ''}',
                                style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),
                              ),
                              Divider(),
                              SizedBox(height: 25),

                              // for email section
                              Text(
                                getTranslated('email', context),
                                style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: ColorResources.getHintColor(context)),
                              ),
                              SizedBox(height: 6),
                              Text(
                                '${profileProvider.userInfoModel.email ?? ''}',
                                style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT),
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ) : NotLoggedInScreen()
      ),
    );
  }
}
