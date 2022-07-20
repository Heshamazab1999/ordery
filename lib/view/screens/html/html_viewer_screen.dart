import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/html_type.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/footer_view.dart';
import 'package:flutter_grocery/view/base/web_app_bar/web_app_bar.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_ui/universal_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class HtmlViewerScreen extends StatelessWidget {
  final HtmlType htmlType;
  HtmlViewerScreen({@required this.htmlType});
  
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    String _data = htmlType == HtmlType.TERMS_AND_CONDITION ? Provider.of<SplashProvider>(context, listen: false).configModel.termsAndConditions
        : htmlType == HtmlType.ABOUT_US ? Provider.of<SplashProvider>(context, listen: false).configModel.aboutUs
        : htmlType == HtmlType.PRIVACY_POLICY ? Provider.of<SplashProvider>(context, listen: false).configModel.privacyPolicy : null;

    if(_data != null && _data.isNotEmpty) {
      _data = _data.replaceAll('href=', 'target="_blank" href=');
    }

    String _viewID = htmlType.toString();
    if(ResponsiveHelper.isWeb()) {
      try{
        ui.platformViewRegistry.registerViewFactory(_viewID, (int viewId) {
          html.IFrameElement _ife = html.IFrameElement();
          _ife.width = '1170';
          _ife.height = MediaQuery.of(context).size.height.toString();
          _ife.srcdoc = _data;
          _ife.contentEditable = 'false';
          _ife.style.border = 'none';
          _ife.allowFullscreen = true;
          return _ife;
        });
      }catch(e) {}
    }
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120))  : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.height - 400 : MediaQuery.of(context).size.height),
              child: Container(
                width: 1170,
                color: Theme.of(context).canvasColor,
                child:  SingleChildScrollView(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [

                      ResponsiveHelper.isDesktop(context)
                          ? Text(htmlType.name.replaceAll('_', ' '),style: poppinsBold.copyWith(fontSize: 28,color: ColorResources.getTextColor(context)))
                          : SizedBox.shrink(),
                      Padding(
                        padding: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT,vertical: Dimensions.PADDING_SIZE_SMALL) : const EdgeInsets.all(0.0),
                        child: HtmlWidget(
                          _data ?? '',
                          key: Key(htmlType.toString()),
                          textStyle: poppinsRegular.copyWith(color: ColorResources.getTextColor(context)),
                          onTapUrl: (String url){
                           return launch(url);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ResponsiveHelper.isDesktop(context) ? FooterView() : SizedBox(),
          ],
        ),
      ),
    );
  }
}
