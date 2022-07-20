import 'package:flutter/material.dart';
import 'package:flutter_grocery/provider/theme_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:provider/provider.dart';

class ArrayButton extends StatelessWidget {
  final bool isLeft;
  final bool isLarge;
  final Function onTop;
  final bool isVisible;
  const ArrayButton({Key key, @required this.isLeft, @required this.isLarge, @required this.onTop, @required this.isVisible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: isVisible ?  onTop : null,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        decoration: BoxDecoration(color: isVisible ? Theme.of(context).primaryColor.withOpacity(0.7) : ColorResources.getHintColor(context), shape: BoxShape.circle,
          boxShadow: [
            /*BoxShadow(
                color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme? 900 : 200],
                spreadRadius: 0,
                blurRadius: 25,
                offset: Offset(0, 4))*/
          ],),
        child: Padding(
          padding: isLarge ?  const EdgeInsets.all(8.0) : const EdgeInsets.all(4.0),
          child: isLeft ? Icon(Icons.chevron_left_rounded, color: isVisible ? ColorResources.getBlackColor(context)
              : ColorResources.getWhiteColor(context), size: isLarge == null || isLarge ?  30
              : Dimensions.PADDING_SIZE_LARGE) : Icon(Icons.chevron_right_rounded, color: isVisible 
              ? ColorResources.getBlackColor(context)  :  ColorResources.getWhiteColor(context), size: isLarge == null || isLarge ?  30
              : Dimensions.PADDING_SIZE_LARGE),
        ),
      ),
    );
  }
}
