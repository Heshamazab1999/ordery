import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../helper/responsive_helper.dart';
import '../../../localization/language_constrants.dart';
import '../../../provider/splash_provider.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/images.dart';
import '../../../utill/styles.dart';
import '../../base/custom_button.dart';
import '../../base/footer_view.dart';
import '../../base/web_app_bar/web_app_bar.dart';
import '../product/widget/details_app_bar.dart';

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120)) : DetailsAppBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.height - 400 : MediaQuery.of(context).size.height),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                    child: Container(
                      width: _width > 700 ? 700 : _width,
                      padding: _width > 700 ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT) : null,
                      decoration: _width > 700 ? BoxDecoration(
                        color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 5, spreadRadius: 1)],
                      ) : null,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        Align(alignment: Alignment.center, child: Image.asset(Images.support,height: 300,width: 300,)),
                        SizedBox(height: 20),

                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.location_on, color: Theme.of(context).primaryColor, size: 25),
                          Text(getTranslated('restaurant_address', context), style: poppinsMedium),
                        ]),
                        SizedBox(height: 10),

                        Text(
                          Provider.of<SplashProvider>(context, listen: false).configModel.ecommerceAddress ?? 'no address',
                          style: poppinsRegular, textAlign: TextAlign.center,
                        ),
                        Divider(thickness: 2),
                        SizedBox(height: 50),

                        Padding(
                          padding: ResponsiveHelper.isDesktop(context) ?  const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE) : EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: Row(children: [
                            Expanded(child: TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(width: 2, color: Theme.of(context).primaryColor)),
                                minimumSize: Size(1, 50),
                              ),
                              onPressed: () {
                                launch('tel:${Provider.of<SplashProvider>(context, listen: false).configModel.ecommercePhone}');
                              },
                              child: Text(getTranslated('call_now', context), style: Theme.of(context).textTheme.headline3.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontSize: Dimensions.FONT_SIZE_LARGE,
                              )),
                            )),
                            SizedBox(width: 10),
                            Expanded(child: SizedBox(
                              height: 50,
                              child: CustomButton(
                                buttonText: getTranslated('send_a_message', context),
                                onPressed: () async {
                                  Navigator.pushNamed(context, RouteHelper.getChatRoute(orderModel: null));
                                },
                              ),
                            )),
                          ]),
                        ),

                      ]),
                    ),
                  ),
                ),
              ),
              if(ResponsiveHelper.isDesktop(context)) FooterView(),
            ],
          ),
        ),
      ),
    );
  }
}
