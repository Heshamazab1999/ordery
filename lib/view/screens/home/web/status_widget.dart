import 'package:flutter/material.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/theme_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:provider/provider.dart';

class StatusWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) => SizedBox(
          height: Dimensions.PADDING_SIZE_DEFAULT,
          child: InkWell(
                onTap: themeProvider.toggleTheme,
                child: themeProvider.darkTheme
                    ? Container(
                        width: 60,
                        height: 29,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ColorResources.getAppBarHeaderColor(context),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              getTranslated('on', context),
                              textAlign: TextAlign.center, style: TextStyle(color: ColorResources.getTextColor(context), fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                            )),
                            CircleAvatar(
                              radius: 13,
                              backgroundColor: ColorResources.getGreyColor(context),
                            )
                          ],
                        ),
                      )
                    : Container(
                        width: 60,
                        height: 29,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ColorResources.getAppBarHeaderColor(context),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 13,
                              backgroundColor: ColorResources.getBackgroundColor(context),
                            ),
                            Expanded(
                                child: Text(getTranslated('off', context),
                                    textAlign: TextAlign.center, style: TextStyle(color: ColorResources.getAppBarHeaderColor(context), fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL)
                            )),
                          ],
                        ),
                      ),
              ),
        ));
  }
}
