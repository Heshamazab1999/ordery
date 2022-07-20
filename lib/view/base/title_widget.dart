import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final Function onTap;
  TitleWidget({@required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ResponsiveHelper.isDesktop(context) ? ColorResources.getAppBarHeaderColor(context) : Theme.of(context).canvasColor,
      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 12),
      margin: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.symmetric(horizontal: 5) : EdgeInsets.zero,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: ResponsiveHelper.isDesktop(context) ?  poppinsSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_OVER_LARGE, color: ColorResources.getTextColor(context)) : poppinsMedium),
        onTap != null ? InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
            child: Text(
              getTranslated('view_all', context),
              style: ResponsiveHelper.isDesktop(context) ?  poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).primaryColor) : poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).primaryColor.withOpacity(0.8)),
            ),
          ),
        ) : SizedBox(),
      ]),
    );
  }
}
