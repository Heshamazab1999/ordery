
import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/address_model.dart';
import 'package:flutter_grocery/data/model/response/config_model.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/location_provider.dart';
import 'package:flutter_grocery/provider/order_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class ButtonsView extends StatelessWidget {
  final LocationProvider locationProvider;
  final bool isEnableUpdate;
  final bool fromCheckout;
  final TextEditingController contactPersonNameController;
  final TextEditingController contactPersonNumberController;
  final AddressModel address;
  const ButtonsView({
    Key key,
    @required this.locationProvider,
    @required this.isEnableUpdate,
    @required this.fromCheckout,
    @required this.contactPersonNumberController,
    @required this.contactPersonNameController,
    @required this.address
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        locationProvider.addressStatusMessage != null ?
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            locationProvider.addressStatusMessage.length > 0 ? CircleAvatar(backgroundColor: Colors.green, radius: 5) : SizedBox.shrink(),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                locationProvider.addressStatusMessage ?? "",
                style:
                Theme.of(context).textTheme.headline2.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.green, height: 1),
              ),
            )
          ],
        )  :
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            locationProvider.errorMessage.length > 0
                ? CircleAvatar(backgroundColor: Colors.red, radius: 5)
                : SizedBox.shrink(),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                locationProvider.errorMessage ?? "",
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.red, height: 1),
              ),
            )
          ],
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
        Container(
          height: 50.0,
          width: 1170,
          margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: !locationProvider.isLoading ? CustomButton(
            buttonText: isEnableUpdate ? getTranslated('update_address', context) : getTranslated('save_location', context),
            onPressed: locationProvider.loading ? null : () {
              List<Branches> _branches = Provider.of<SplashProvider>(context, listen: false).configModel.branches;
              bool _isAvailable = _branches.length == 1 && (_branches[0].latitude == null || _branches[0].latitude.isEmpty);
              if(!_isAvailable) {
                for (Branches branch in _branches) {
                  double _distance = Geolocator.distanceBetween(
                    double.parse(branch.latitude), double.parse(branch.longitude),
                    locationProvider.position.latitude, locationProvider.position.longitude,
                  ) / 1000;
                  if (_distance < branch.coverage) {
                    _isAvailable = true;
                    break;
                  }
                }
              }
              if(!_isAvailable) {
                showCustomSnackBar(getTranslated('service_is_not_available', context), context);
              }else {
                AddressModel addressModel = AddressModel(
                  addressType: locationProvider.getAllAddressType[locationProvider.selectAddressIndex],
                  contactPersonName: contactPersonNameController.text ?? '',
                  contactPersonNumber: contactPersonNumberController.text ?? '',
                  address: locationProvider.locationController.text ?? '',
                  latitude: isEnableUpdate ? locationProvider.position.latitude.toString() ?? address.latitude
                      : locationProvider.position.latitude.toString() ?? '',
                  longitude: locationProvider.position.longitude.toString() ?? '',
                );
                if (isEnableUpdate) {
                  addressModel.id = address.id;
                  addressModel.userId = address.userId;
                  addressModel.method = 'put';
                  locationProvider.updateAddress(context, addressModel: addressModel, addressId: addressModel.id).then((value) {});
                } else {
                  locationProvider.addAddress(addressModel, context).then((value) {
                    if (value.isSuccess) {
                      // Navigator.pop(context);
                      if (fromCheckout) {
                        Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
                        Provider.of<OrderProvider>(context, listen: false).setAddressIndex(-1);
                      } else {
                        showCustomSnackBar(value.message, context, isError: false);
                        Navigator.pop(context);
                      }
                    } else {
                      showCustomSnackBar(value.message, context);
                    }
                  });
                }
              }
            },
          )
              : Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              )),
        )
      ],
    );
  }
}