import 'package:flutter/material.dart';
import 'package:flutter_grocery/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class ColorResources {
  static Color getGreyColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFb2b8bd) : Color(0xFFE4EAEF);
  }
  static Color getProfileMenuHeaderColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ?  FOOTER_COL0R.withOpacity(0.5) : FOOTER_COL0R;
  }
  static Color getTimeColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFFFFFFF) : Color(0xFFE4EAEF);
  }
  static Color getDarkColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF4d5054) : Color(0xFF25282B);
  }
  static Color getCardBgColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF3c3c3c)/*Color(0xFFFFFFFF).withOpacity(0.05)*/ : Color(0xFFFFFFFF);
  }
  static Color getWhiteColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF000000) : Color(0xFFFFFFFF);
  }
  static Color getBlackColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFFFFFFF) : Color(0xFF000000);
  }
  static Color getTryBgColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF011201) : Color(0xFFecfbec);
  }
  static Color getTextColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFFFFFFF).withOpacity(0.6) : Color(0xFF1F1F1F);
  }
  static Color getProductDescriptionColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFFFFFFF) : Color(0xFF1F1F1F);
  }
  static Color getFooterTextColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFFFFFFF) : Color(0xFF515755);
  }
  static Color getHintColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF98a1ab) : Color(0xFF7A7A7A);
  }
  static Color getBackgroundColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF4d5054) : Color(0xFFFAFAFA);
  }
  static Color getGreyLightColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFb2b8bd) : Color(0xFF98a1ab);
  }
  static Color getYellow(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF916129) : Color(0xFFFFAA47);
  }

  static Color getGreen(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF167d3c) : Color(0xFF23CB60);
  }

  static Color getCategoryBgColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFFFFFFFF) : Color(0xFFb2b8bd);
  }

  static Color getOrderColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF4d5054) : Color(0xFFE4EAEF).withOpacity(0.9);
   }

  static Color getAppBarHeaderColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF5c746c) : Color(0xFFEDF4F2);
  }

  static Color getChatAdminColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ?  Color(0xFFa1916c) :Color(0xFFFFDDD9);
  }
  static Color getSearchBg(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? Color(0xFF585a5c) : Color(0xFFF4F7FC);
  }
  static const Color BORDER_COLOR = Color(0xFFDCDCDC);
  static const Color SEARCH_BG = Color(0xFFF4F7FC);
  static const Color RED_COLOR = Color(0xFFFC6A57);
  static const Color Black_COLOR = Color(0xFF000000);
  static const Color CARD_SHADOW_COLOR = Color(0xFFA7A7A7);
  static const Color FOOTER_COL0R = Color(0xFFFFDDD9);
  static const Color Disable_COL0R = Color(0xFF5A5A5A);
  static const Color WHITE_COL0R = Color(0xFFFFFFFF);

}
