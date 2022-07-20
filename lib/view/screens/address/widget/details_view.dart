
import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/address_model.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/location_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_text_field.dart';
import 'package:flutter_grocery/view/screens/address/widget/buttons_view.dart';

class DetailsView extends StatelessWidget {
  final LocationProvider locationProvider;
  final TextEditingController contactPersonNameController;
  final TextEditingController contactPersonNumberController;
  final FocusNode addressNode;
  final FocusNode nameNode;
  final FocusNode numberNode;
  final bool isEnableUpdate;
  final bool fromCheckout;
  final AddressModel address;
  const DetailsView({
    Key key,
    @required this.locationProvider,
    @required this.contactPersonNameController,
    @required this.contactPersonNumberController,
    @required this.addressNode, @required this.nameNode,
    @required this.numberNode,
    @required this.isEnableUpdate,
    @required this.fromCheckout,
    @required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ResponsiveHelper.isDesktop(context) ?  BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: ColorResources.CARD_SHADOW_COLOR.withOpacity(0.2),
              blurRadius: 10,
            )
          ]
      ) : BoxDecoration(),
      //margin: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL,vertical: Dimensions.PADDING_SIZE_LARGE),
      padding: ResponsiveHelper.isDesktop(context) ?  EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE,vertical: Dimensions.PADDING_SIZE_LARGE) : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
              getTranslated('delivery_address', context),
              style:
              Theme.of(context).textTheme.headline3.copyWith(color: ColorResources.getHintColor(context), fontSize: Dimensions.FONT_SIZE_LARGE),
            ),
          ),
          // for Address Field
          Text(
            getTranslated('address_line_01', context),
            style: poppinsRegular.copyWith(color: ColorResources.getHintColor(context)),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          CustomTextField(
            hintText: getTranslated('address_line_02', context),
            isShowBorder: true,
            inputType: TextInputType.streetAddress,
            inputAction: TextInputAction.next,
            focusNode: addressNode,
            nextFocus: nameNode,
            controller: locationProvider.locationController??'',
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

          // for Contact Person Name
          Text(
            getTranslated('contact_person_name', context),
            style: poppinsRegular.copyWith(color: ColorResources.getHintColor(context)),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          CustomTextField(
            hintText: getTranslated('enter_contact_person_name', context),
            isShowBorder: true,
            inputType: TextInputType.name,
            controller: contactPersonNameController,
            focusNode: nameNode,
            nextFocus: numberNode,
            inputAction: TextInputAction.next,
            capitalization: TextCapitalization.words,
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

          // for Contact Person Number
          Text(
            getTranslated('contact_person_number', context),
            style: poppinsRegular.copyWith(color: ColorResources.getHintColor(context)),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          CustomTextField(
            hintText: getTranslated('enter_contact_person_number', context),
            isShowBorder: true,
            inputType: TextInputType.phone,
            inputAction: TextInputAction.done,
            focusNode: numberNode,
            controller: contactPersonNumberController,
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

          if(ResponsiveHelper.isDesktop(context)) Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
            child: ButtonsView(locationProvider: locationProvider, isEnableUpdate: isEnableUpdate, fromCheckout: fromCheckout, contactPersonNumberController: contactPersonNumberController, contactPersonNameController: contactPersonNameController, address: address),
          )
        ],
      ),
    );
  }
}