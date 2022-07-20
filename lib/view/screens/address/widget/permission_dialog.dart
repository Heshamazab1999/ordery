
import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:geolocator/geolocator.dart';

class PermissionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Container(
          width: 300,
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            Icon(Icons.add_location_alt_rounded, color: Theme.of(context).primaryColor, size: 100),
            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

            Text(
              getTranslated('you_denied_location_permission', context), textAlign: TextAlign.center,
              style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

            Row(children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(width: 2, color: Theme.of(context).primaryColor)),
                    minimumSize: Size(1, 50),
                  ),
                  child: Text(getTranslated('no', context)),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
              Expanded(child: CustomButton(buttonText: getTranslated('yes', context), onPressed: () async {
               if(ResponsiveHelper.isMobilePhone()) {
                 await Geolocator.openAppSettings();
               }
                Navigator.pop(context);
              })),
            ]),

          ]),
        ),
      ),
    );
  }
}
