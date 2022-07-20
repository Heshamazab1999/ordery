import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_grocery/data/model/response/address_model.dart';
import 'package:flutter_grocery/helper/price_converter.dart';
import 'package:flutter_grocery/provider/localization_provider.dart';
import 'package:flutter_grocery/view/base/custom_divider.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';
import 'package:flutter_grocery/view/base/custom_text_field.dart';
import 'package:flutter_grocery/view/base/footer_view.dart';
import 'package:flutter_grocery/view/screens/checkout/widget/delivery_fee_dialog.dart';
import 'package:flutter_grocery/view/base/web_app_bar/web_app_bar.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_grocery/data/model/body/place_order_body.dart';
import 'package:flutter_grocery/data/model/response/cart_model.dart';
import 'package:flutter_grocery/data/model/response/config_model.dart';
import 'package:flutter_grocery/data/model/response/order_model.dart';
import 'package:flutter_grocery/helper/date_converter.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/auth_provider.dart';
import 'package:flutter_grocery/provider/cart_provider.dart';
import 'package:flutter_grocery/provider/coupon_provider.dart';
import 'package:flutter_grocery/provider/location_provider.dart';
import 'package:flutter_grocery/provider/order_provider.dart';
import 'package:flutter_grocery/provider/product_provider.dart';
import 'package:flutter_grocery/provider/profile_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/provider/theme_provider.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_app_bar.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:flutter_grocery/view/base/not_login_screen.dart';
import 'package:flutter_grocery/view/screens/address/add_new_address_screen.dart';
import 'package:flutter_grocery/view/screens/checkout/order_successful_screen.dart';
import 'package:flutter_grocery/view/screens/checkout/payment_screen.dart';
import 'package:flutter_grocery/view/screens/checkout/widget/custom_check_box.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final double amount;
  final String orderType;
  final double discount;
  final String couponCode;
  CheckoutScreen({@required this.amount, @required this.orderType, @required this.discount, @required this.couponCode});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  final TextEditingController _noteController = TextEditingController();
  GoogleMapController _mapController;
  List<Branches> _branches = [];
  bool _loading = true;
  Set<Marker> _markers = HashSet<Marker>();
  bool _isCashOnDeliveryActive;
  bool _isDigitalPaymentActive;
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn ) {
      Provider.of<OrderProvider>(context, listen: false).setAddressIndex(-1, notify: false);
      Provider.of<OrderProvider>(context, listen: false).initializeTimeSlot(context);
      Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
      _branches = Provider.of<SplashProvider>(context, listen: false).configModel.branches;
    }
    _isCashOnDeliveryActive = Provider.of<SplashProvider>(context, listen: false).configModel.cashOnDelivery == 'true';
    _isDigitalPaymentActive = Provider.of<SplashProvider>(context, listen: false).configModel.digitalPayment == 'true';
  }

  @override
  Widget build(BuildContext context) {
    bool _kmWiseCharge = Provider.of<SplashProvider>(context, listen: false).configModel.deliveryManagement.status == 1;
    bool _selfPickup = widget.orderType == 'self_pickup';

    return Scaffold(
      key: _scaffoldKey,
      appBar: ResponsiveHelper.isDesktop(context)? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120))  : CustomAppBar(title: getTranslated('checkout', context)),
      body:  _isLoggedIn ? Consumer<OrderProvider>(
        builder: (context, order, child) {
          double _deliveryCharge = order.distance
              * Provider.of<SplashProvider>(context, listen: false).configModel.deliveryManagement.shippingPerKm;
          if(_deliveryCharge < Provider.of<SplashProvider>(context, listen: false).configModel.deliveryManagement.minShippingCharge) {
            _deliveryCharge = Provider.of<SplashProvider>(context, listen: false).configModel.deliveryManagement.minShippingCharge;
          }
          if(!_kmWiseCharge || order.distance == -1) {
            _deliveryCharge = 0;
          }

          return Consumer<LocationProvider>(
            builder: (context, address, child) {
              return ResponsiveHelper.isDesktop(context)
                ? SingleChildScrollView(
                  child: Center(
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight:  MediaQuery.of(context).size.height - 560),

                          child: SizedBox(
                             width: 1170,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL,vertical: Dimensions.PADDING_SIZE_LARGE),
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE,vertical: Dimensions.PADDING_SIZE_LARGE),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300],
                                              blurRadius: 5,
                                              spreadRadius: 1,
                                            )
                                          ]
                                      ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                      //Branch
                                      _branches.length > 1 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                          child: Text(getTranslated('select_branch', context), style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                        ),

                                        SizedBox(
                                          height: 50,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                            physics: BouncingScrollPhysics(),
                                            itemCount: _branches.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                                                child: InkWell(
                                                  hoverColor: Colors.transparent,
                                                  onTap: () {
                                                    try {
                                                      order.setBranchIndex(index);
                                                      double.parse(_branches[index].latitude);
                                                      _setMarkers(index);
                                                    }catch(e) {}
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: index == order.branchIndex ? Theme.of(context).primaryColor : ColorResources.getBackgroundColor(context),
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    child: Text(_branches[index].name, maxLines: 1, overflow: TextOverflow.ellipsis, style: poppinsMedium.copyWith(
                                                      color: index == order.branchIndex ? Colors.white : Theme.of(context).textTheme.bodyText1.color,
                                                    )),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),

                                        Container(
                                          height: 200,
                                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                          margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Theme.of(context).cardColor,
                                          ),
                                          child: Stack(children: [
                                            GoogleMap(
                                              mapType: MapType.normal,
                                              initialCameraPosition: CameraPosition(target: LatLng(
                                                double.parse(_branches[0].latitude),
                                                double.parse(_branches[0].longitude),
                                              ), zoom: 8),
                                              zoomControlsEnabled: true,
                                              markers: _markers,
                                              onMapCreated: (GoogleMapController controller) async {
                                                await Geolocator.requestPermission();
                                                _mapController = controller;
                                                _loading = false;
                                                _setMarkers(0);
                                              },
                                            ),
                                            _loading ? Center(child: CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                            )) : SizedBox(),
                                          ]),
                                        ),
                                      ]) : SizedBox(),

                                      // Address
                                      !_selfPickup ? Column(children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                          child: Row(children: [
                                            Text(getTranslated('delivery_address', context), style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                            Expanded(child: SizedBox()),
                                            TextButton.icon(
                                              onPressed: () => Navigator.pushNamed(context, RouteHelper.getAddAddressRoute('checkout', 'add', AddressModel()), arguments: AddNewAddressScreen(fromCheckout: true)),
                                              icon: Icon(Icons.add),
                                              label: Text(getTranslated('add', context), style: poppinsRegular),
                                            ),
                                          ]),
                                        ),
                                        address.addressList != null ? address.addressList.length > 0 ? ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                          itemCount: address.addressList.length,
                                          itemBuilder: (context, index) {
                                            bool _isAvailable = _branches.length == 1 && (_branches[0].latitude == null || _branches[0].latitude.isEmpty);
                                            if(!_isAvailable) {
                                              double _distance = Geolocator.distanceBetween(
                                                double.parse(_branches[order.branchIndex].latitude), double.parse(_branches[order.branchIndex].longitude),
                                                double.parse(address.addressList[index].latitude), double.parse(address.addressList[index].longitude),
                                              ) / 1000;
                                              _isAvailable = _distance < _branches[order.branchIndex].coverage;
                                            }

                                            return Padding(
                                              padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                                              child: InkWell(
                                                onTap: () async {
                                                  if(_isAvailable) {
                                                    order.setAddressIndex(index);
                                                    if(_kmWiseCharge) {
                                                      showDialog(context: context, builder: (context) => Center(child: Container(
                                                        height: 100, width: 100, decoration: BoxDecoration(
                                                        color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                                                      ),
                                                        alignment: Alignment.center,
                                                        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                                                      )), barrierDismissible: false);
                                                      bool _isSuccess = await order.getDistanceInMeter(
                                                        LatLng(
                                                          double.parse(_branches[order.branchIndex].latitude),
                                                          double.parse(_branches[order.branchIndex].longitude),
                                                        ),
                                                        LatLng(
                                                          double.parse(address.addressList[index].latitude),
                                                          double.parse(address.addressList[index].longitude),
                                                        ),
                                                      );
                                                      Navigator.pop(context);
                                                      if(_isSuccess) {
                                                        showDialog(context: context, builder: (context) => DeliveryFeeDialog(
                                                          amount: widget.amount, distance: order.distance,
                                                        ));
                                                      }else {
                                                        showCustomSnackBar(getTranslated('failed_to_fetch_distance', context), context);
                                                      }
                                                    }
                                                  }
                                                },
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                                      decoration: BoxDecoration(
                                                        color: ColorResources.getCardBgColor(context),
                                                        borderRadius: BorderRadius.circular(10),
                                                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: .5, blurRadius: .5)],
                                                      ),
                                                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                          child: Container(
                                                            width: 20, height: 20,
                                                            decoration: BoxDecoration(
                                                              color: Theme.of(context).cardColor,
                                                              border: Border.all(
                                                                color: index == order.addressIndex ? Theme.of(context).primaryColor
                                                                    : ColorResources.getHintColor(context).withOpacity(0.6),
                                                                width: index == order.addressIndex ? 7 : 5,
                                                              ),
                                                              shape: BoxShape.circle,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                                          Text(address.addressList[index].addressType, style: poppinsBold.copyWith(
                                                            fontSize: Dimensions.FONT_SIZE_SMALL,
                                                            color: index == order.addressIndex ? ColorResources.getTextColor(context)
                                                                : ColorResources.getHintColor(context).withOpacity(.8),
                                                          )),
                                                          Text(address.addressList[index].address, style: poppinsRegular.copyWith(
                                                            color: index == order.addressIndex ? ColorResources.getTextColor(context)
                                                                : ColorResources.getHintColor(context).withOpacity(.8),
                                                          ), maxLines: 2, overflow: TextOverflow.ellipsis),
                                                        ])),
                                                      ]),
                                                    ),

                                                    !_isAvailable ? Positioned(
                                                      top: 0, left: 0, bottom: 10, right: 0,
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black.withOpacity(0.6)),
                                                        child: Text(
                                                          getTranslated('out_of_coverage_for_this_branch', context),
                                                          textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
                                                          style: poppinsRegular.copyWith(color: Colors.white, fontSize: 10),
                                                        ),
                                                      ),
                                                    ) : SizedBox(),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ) : Center(child: Text(getTranslated('no_address_found', context)))
                                            : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                                        SizedBox(height: 20),
                                      ]) : SizedBox(),

                                      // Time Slot
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                        child: Text(getTranslated('preference_time', context), style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        height: 52,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.symmetric(horizontal: 15),
                                          physics: BouncingScrollPhysics(),
                                          itemCount: 3,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: EdgeInsets.only(right: 18, bottom: 2, top: 2),
                                              child: InkWell(
                                                onTap: () => order.updateDateSlot(index),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: order.selectDateSlot == index ? Theme.of(context).primaryColor
                                                        : ColorResources.getTimeColor(context),
                                                    borderRadius: BorderRadius.circular(7),
                                                    boxShadow: [ BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 100], spreadRadius: .5, blurRadius: .5)],),
                                                  child: Text(
                                                    index == 0 ? getTranslated('today', context) : index == 1 ? getTranslated('tomorrow', context)
                                                        : DateConverter.estimatedDate(DateTime.now().add(Duration(days: 2))),
                                                    style: poppinsRegular.copyWith(
                                                      fontSize: Dimensions.FONT_SIZE_LARGE,
                                                      color: order.selectDateSlot == index ? Colors.white : Colors.grey[500]
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),

                                      // Preference Time
                                      SizedBox(height: 12),
                                      Container(
                                        height: 52,
                                        child: order.timeSlots != null ? order.timeSlots.length > 0 ? ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.symmetric(horizontal: 15),
                                          physics: BouncingScrollPhysics(),
                                          itemCount: order.timeSlots.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: EdgeInsets.only(right: 18, bottom: 2, top: 2),
                                              child: InkWell(
                                                onTap: () => order.updateTimeSlot(index),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: order.selectTimeSlot == index ? Theme.of(context).primaryColor : ColorResources.getTimeColor(context),
                                                      borderRadius: BorderRadius.circular(7),
                                                      boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 100], spreadRadius: .5, blurRadius: .5)]),
                                                  child: Text(
                                                    '${DateConverter.stringToStringTime(order.timeSlots[index].startTime)} '
                                                        '- ${DateConverter.stringToStringTime(order.timeSlots[index].endTime)}',
                                                    style: poppinsRegular.copyWith(
                                                        fontSize: Dimensions.FONT_SIZE_LARGE,
                                                        color: order.selectTimeSlot == index ? Colors.white : Colors.grey[500]
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }

                                        ) : Center(child: Text(getTranslated('no_slot_available', context)))
                                            : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                                      ),
                                    ],),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL,vertical: Dimensions.PADDING_SIZE_LARGE),
                                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE,vertical: Dimensions.PADDING_SIZE_LARGE),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 900 : 300],
                                              blurRadius: 5,
                                              spreadRadius: 1,
                                            )
                                          ]
                                      ),
                                        child: Column(children: [
                                        // Payment Method
                                            SizedBox(height: 20),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                              child: Text(getTranslated('payment_method', context), style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                            ),
                                            _isCashOnDeliveryActive ? CustomCheckBox(title: getTranslated('cash_on_delivery', context), index: 0) : SizedBox(),
                                            _isDigitalPaymentActive
                                                ? CustomCheckBox(title: getTranslated('digital_payment', context), index: _isCashOnDeliveryActive ? 1 : 0)
                                                : SizedBox(),

                                                Padding(
                                                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                                  child: CustomTextField(
                                                    controller: _noteController,
                                                    hintText: getTranslated('additional_note', context),
                                                    maxLines: 5,
                                                    inputType: TextInputType.multiline,
                                                    inputAction: TextInputAction.newline,
                                                    capitalization: TextCapitalization.sentences,
                                                  ),
                                                ),

                                                _kmWiseCharge ? Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                                  child: Column(children: [
                                                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                      Text(getTranslated('subtotal', context), style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                                      Text(PriceConverter.convertPrice(context, widget.amount), style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                                    ]),
                                                    SizedBox(height: 10),

                                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                      Text(
                                                        getTranslated('delivery_fee', context),
                                                        style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                                                      ),
                                                      Text(
                                                        (_selfPickup || order.distance != -1) ? '(+) ${PriceConverter.convertPrice(context, _selfPickup ? 0 : _deliveryCharge)}'
                                                            : getTranslated('not_found', context),
                                                        style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                                                      ),
                                                    ]),

                                                    Padding(
                                                      padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                                                      child: CustomDivider(),
                                                    ),

                                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                      Text(getTranslated('total_amount', context), style: poppinsMedium.copyWith(
                                                        fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).primaryColor,
                                                      )),
                                                      Text(
                                                        PriceConverter.convertPrice(context, widget.amount+_deliveryCharge),
                                                        style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).primaryColor),
                                                      ),
                                                    ]),
                                                  ]),
                                                ) : SizedBox(),

                                        ],),
                                      ),
                                      !order.isLoading ? Builder(
                                        builder: (context) => Center(
                                            child: Container(
                                              width: 1170,
                                              child: CustomButton(
                                                margin: Dimensions.PADDING_SIZE_SMALL,
                                                buttonText: getTranslated('place_order', context),
                                                onPressed: () {
                                                  if (!_selfPickup && order.addressIndex == -1) {
                                                    showCustomSnackBar(getTranslated('select_delivery_address', context),context,isError: true);
                                                     }else if (order.timeSlots == null || order.timeSlots.length == 0) {
                                                    showCustomSnackBar(getTranslated('select_a_time', context),context,isError: true);
                                                   }else if (!_selfPickup && _kmWiseCharge && order.distance == -1) {
                                                    showCustomSnackBar(getTranslated('delivery_fee_not_set_yet', context),context,isError: true);
                                                    }else if (!_isCashOnDeliveryActive && !_isDigitalPaymentActive) {
                                                    showCustomSnackBar(getTranslated('payment_method_is_not_activated_please_order_later', context), context,isError: true);
                                                  }
                                                  else {
                                                    List<CartModel> _cartList = Provider.of<CartProvider>(context, listen: false).cartList;
                                                    List<Cart> carts = [];
                                                    for (int index = 0; index < _cartList.length; index++) {
                                                      Cart cart = Cart(
                                                        productId: _cartList[index].id, price: _cartList[index].price, discountAmount: _cartList[index].discountedPrice,
                                                        quantity: _cartList[index].quantity, taxAmount: _cartList[index].tax,
                                                        variant: '', variation: [Variation(type: _cartList[index].variation != null ? _cartList[index].variation.type : null)],
                                                      );
                                                      carts.add(cart);
                                                    }
                                                    order.placeOrder(PlaceOrderBody(
                                                      cart: carts, orderType: widget.orderType, couponCode: widget.couponCode, orderNote: _noteController.text,
                                                      branchId: _branches[order.branchIndex].id,
                                                      deliveryAddressId: !_selfPickup ? Provider.of<LocationProvider>(context, listen: false)
                                                          .addressList[order.addressIndex].id : 0, distance: _selfPickup ? 0 : order.distance,
                                                      couponDiscountAmount: Provider.of<CouponProvider>(context, listen: false).discount, timeSlotId: order.timeSlots[order.selectTimeSlot].id,
                                                      paymentMethod: _isCashOnDeliveryActive ? order.paymentMethodIndex == 0 ? 'cash_on_delivery' : null : null,
                                                      deliveryDate: order.getDates(context)[order.selectDateSlot], couponDiscountTitle: '', orderAmount: widget.amount+_deliveryCharge,
                                                    ), _callback);
                                                  }
                                                },
                                              ),
                                            ),
                                        ),
                                      ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                                    ],

                                  ))
                              ],
                            ),
                          ),
                        ),
                      ),
                       FooterView() ,
                    ],),
                  ),
                )
               : Column(
                children: [

                  Expanded(
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Center(
                          child: SizedBox(
                            width: 1170,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                              //Branch
                              _branches.length > 1 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: Text(getTranslated('select_branch', context), style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                ),

                                SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                    physics: BouncingScrollPhysics(),
                                    itemCount: _branches.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                                        child: InkWell(
                                          onTap: () {
                                            try {
                                              order.setBranchIndex(index);
                                              double.parse(_branches[index].latitude);
                                              _setMarkers(index);
                                            }catch(e) {}
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: index == order.branchIndex ? Theme.of(context).primaryColor : ColorResources.getBackgroundColor(context),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Text(_branches[index].name, maxLines: 1, overflow: TextOverflow.ellipsis, style: poppinsMedium.copyWith(
                                              color: index == order.branchIndex ? Colors.white : Theme.of(context).textTheme.bodyText1.color,
                                            )),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                Container(
                                  height: 200,
                                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                  margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context).cardColor,
                                  ),
                                  child: Stack(children: [
                                    GoogleMap(
                                      mapType: MapType.normal,
                                      initialCameraPosition: CameraPosition(target: LatLng(
                                        double.parse(_branches[0].latitude),
                                        double.parse(_branches[0].longitude),
                                      ), zoom: 8),
                                      zoomControlsEnabled: true,
                                      markers: _markers,
                                      onMapCreated: (GoogleMapController controller) async {
                                        await Geolocator.requestPermission();
                                        _mapController = controller;
                                        _loading = false;
                                        _setMarkers(0);
                                      },
                                    ),
                                    _loading ? Center(child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                    )) : SizedBox(),
                                  ]),
                                ),
                              ]) : SizedBox(),

                              // Address
                              !_selfPickup ? Column(children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                  child: Row(children: [
                                    Text(getTranslated('delivery_address', context), style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                    Expanded(child: SizedBox()),
                                    TextButton.icon(
                                      onPressed: () => Navigator.pushNamed(context, RouteHelper.getAddAddressRoute('checkout', 'add', AddressModel()), arguments: AddNewAddressScreen(fromCheckout: true)),
                                      icon: Icon(Icons.add),
                                      label: Text(getTranslated('add', context), style: poppinsRegular),
                                    ),
                                  ]),
                                ),
                                address.addressList != null ? address.addressList.length > 0 ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                  itemCount: address.addressList.length,
                                  itemBuilder: (context, index) {
                                    bool _isAvailable = _branches.length == 1 && (_branches[0].latitude == null || _branches[0].latitude.isEmpty);
                                    if(!_isAvailable) {
                                      double _distance = Geolocator.distanceBetween(
                                        double.parse(_branches[order.branchIndex].latitude), double.parse(_branches[order.branchIndex].longitude),
                                        double.parse(address.addressList[index].latitude), double.parse(address.addressList[index].longitude),
                                      ) / 1000;
                                      _isAvailable = _distance < _branches[order.branchIndex].coverage;
                                    }

                                    return Padding(
                                      padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                                      child: InkWell(
                                        onTap: () async {
                                          if(_isAvailable) {
                                            order.setAddressIndex(index);
                                            if(_kmWiseCharge) {
                                              showDialog(context: context, builder: (context) => Center(child: Container(
                                                height: 100, width: 100, decoration: BoxDecoration(
                                                color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                                              ),
                                                alignment: Alignment.center,
                                                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                                              )), barrierDismissible: false);
                                              bool _isSuccess = await order.getDistanceInMeter(
                                                LatLng(
                                                  double.parse(_branches[order.branchIndex].latitude),
                                                  double.parse(_branches[order.branchIndex].longitude),
                                                ),
                                                LatLng(
                                                  double.parse(address.addressList[index].latitude),
                                                  double.parse(address.addressList[index].longitude),
                                                ),
                                              );
                                              Navigator.pop(context);
                                              if(_isSuccess) {
                                                showDialog(context: context, builder: (context) => DeliveryFeeDialog(
                                                  amount: widget.amount, distance: order.distance,
                                                ));
                                              }else {
                                                showCustomSnackBar(getTranslated('failed_to_fetch_distance', context), context);
                                              }
                                            }
                                          }
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                              decoration: BoxDecoration(
                                                color: ColorResources.getCardBgColor(context),
                                                borderRadius: BorderRadius.circular(10),
                                                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: .5, blurRadius: .5)],
                                              ),
                                              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                  child: Container(
                                                    width: 20, height: 20,
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context).cardColor,
                                                      border: Border.all(
                                                        color: index == order.addressIndex ? Theme.of(context).primaryColor
                                                            : ColorResources.getHintColor(context).withOpacity(0.6),
                                                        width: index == order.addressIndex ? 7 : 5,
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                                                  Text(address.addressList[index].addressType, style: poppinsBold.copyWith(
                                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                                    color: index == order.addressIndex ? ColorResources.getTextColor(context)
                                                        : ColorResources.getHintColor(context).withOpacity(.8),
                                                  )),
                                                  Text(address.addressList[index].address, style: poppinsRegular.copyWith(
                                                    color: index == order.addressIndex ? ColorResources.getTextColor(context)
                                                        : ColorResources.getHintColor(context).withOpacity(.8),
                                                  ), maxLines: 2, overflow: TextOverflow.ellipsis),
                                                ])),
                                              ]),
                                            ),

                                            !_isAvailable ? Positioned(
                                              top: 0, left: 0, bottom: 10, right: 0,
                                              child: Container(
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black.withOpacity(0.6)),
                                                child: Text(
                                                  getTranslated('out_of_coverage_for_this_branch', context),
                                                  textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
                                                  style: poppinsRegular.copyWith(color: Colors.white, fontSize: 10),
                                                ),
                                              ),
                                            ) : SizedBox(),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ) : Center(child: Text(getTranslated('no_address_found', context)))
                                    : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                                SizedBox(height: 20),
                              ]) : SizedBox(),

                              // Time Slot
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                child: Text(getTranslated('preference_time', context), style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: 52,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  physics: BouncingScrollPhysics(),
                                  itemCount: 3,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(right: 18, bottom: 2, top: 2),
                                      child: InkWell(
                                        onTap: () => order.updateDateSlot(index),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: order.selectDateSlot == index ? Theme.of(context).primaryColor
                                                : ColorResources.getTimeColor(context),
                                            borderRadius: BorderRadius.circular(7),
                                            boxShadow: [ BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 100], spreadRadius: .5, blurRadius: .5)],),
                                          child: Text(
                                            index == 0 ? getTranslated('today', context) : index == 1 ? getTranslated('tomorrow', context)
                                                : DateConverter.estimatedDate(DateTime.now().add(Duration(days: 2))),
                                            style: poppinsRegular.copyWith(
                                              fontSize: Dimensions.FONT_SIZE_LARGE,
                                              color: order.selectDateSlot == index ? Colors.white : Colors.grey[500]
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // Preference Time
                              SizedBox(height: 12),
                              Container(
                                height: 52,
                                child: order.timeSlots != null ? order.timeSlots.length > 0 ? ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  physics: BouncingScrollPhysics(),
                                  itemCount: order.timeSlots.length,
                                  itemBuilder: (context, index) => Padding(
                                    padding: EdgeInsets.only(right: 18, bottom: 2, top: 2),
                                    child: InkWell(
                                      onTap: () => order.updateTimeSlot(index),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: order.selectTimeSlot == index ? Theme.of(context).primaryColor : ColorResources.getTimeColor(context),
                                          borderRadius: BorderRadius.circular(7),
                                          boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 800 : 100], spreadRadius: .5, blurRadius: .5)]),
                                        child: Text(
                                          '${DateConverter.stringToStringTime(order.timeSlots[index].startTime)} '
                                              '- ${DateConverter.stringToStringTime(order.timeSlots[index].endTime)}',
                                          style: poppinsRegular.copyWith(
                                            fontSize: Dimensions.FONT_SIZE_LARGE,
                                            color: order.selectTimeSlot == index ? Colors.white : Colors.grey[500]
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ) : Center(child: Text(getTranslated('no_slot_available', context)))
                                    : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                              ),

                              // Receiver Details
                              /*SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                child: Text(getTranslated('receiver_details', context), style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                child: CustomTextField(
                                  hintText: getTranslated('receiver_name', context),
                                  controller: _nameController,
                                  focusNode: nameFocus,
                                  nextFocus: phoneFocus,
                                  capitalization: TextCapitalization.words,
                                  inputType: TextInputType.name,
                                ),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                child: CustomTextField(
                                  hintText: getTranslated('receiver_phn_no', context),
                                  controller: _phoneController,
                                  focusNode: phoneFocus,
                                  inputType: TextInputType.phone,
                                  inputAction: TextInputAction.done,
                                ),
                              ),*/

                              // Payment Method
                              SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                child: Text(getTranslated('payment_method', context), style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                              ),
                              _isCashOnDeliveryActive ? CustomCheckBox(title: getTranslated('cash_on_delivery', context), index: 0) : SizedBox(),
                              _isDigitalPaymentActive
                                  ? CustomCheckBox(title: getTranslated('digital_payment', context), index: _isCashOnDeliveryActive ? 1 : 0)
                                  : SizedBox(),

                                  Padding(
                                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                    child: CustomTextField(
                                      controller: _noteController,
                                      hintText: getTranslated('additional_note', context),
                                      maxLines: 5,
                                      inputType: TextInputType.multiline,
                                      inputAction: TextInputAction.newline,
                                      capitalization: TextCapitalization.sentences,
                                    ),
                                  ),

                                  _kmWiseCharge ? Padding(
                                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                    child: Column(children: [
                                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Text(getTranslated('subtotal', context), style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                        Text(PriceConverter.convertPrice(context, widget.amount), style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                      ]),
                                      SizedBox(height: 10),

                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Text(
                                          getTranslated('delivery_fee', context),
                                          style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                                        ),
                                        Text(
                                          (_selfPickup || order.distance != -1) ? '(+) ${PriceConverter.convertPrice(context, _selfPickup ? 0 : _deliveryCharge)}'
                                              : getTranslated('not_found', context),
                                          style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                                        ),
                                      ]),

                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                                        child: CustomDivider(),
                                      ),

                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Text(getTranslated('total_amount', context), style: poppinsMedium.copyWith(
                                          fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).primaryColor,
                                        )),
                                        Text(
                                          PriceConverter.convertPrice(context, widget.amount+_deliveryCharge),
                                          style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).primaryColor),
                                        ),
                                      ]),
                                    ]),
                                  ) : SizedBox(),

                                ]),
                          ),
                        ),
                      ),
                    ),
                  ),

                  !order.isLoading ? Builder(
                    builder: (context) => Center(
                      child: Container(
                        width: 1170,
                        child: CustomButton(
                          margin: Dimensions.PADDING_SIZE_SMALL,
                          buttonText: getTranslated('place_order', context),
                          onPressed: () {
                            if (!_selfPickup && order.addressIndex == -1) {
                              showCustomSnackBar(getTranslated('select_delivery_address', context), context,isError: true);
                            }else if (order.timeSlots == null || order.timeSlots.length == 0) {
                              showCustomSnackBar(getTranslated('select_a_time', context), context,isError: true);
                            }else if (!_selfPickup && _kmWiseCharge && order.distance == -1) {
                              showCustomSnackBar(getTranslated('delivery_fee_not_set_yet', context), context,isError: true);
                            }
                            else if (!_isCashOnDeliveryActive && !_isDigitalPaymentActive) {
                              showCustomSnackBar(getTranslated('payment_method_is_not_activated_please_order_later', context), context,isError: true);
                            }
                            else {
                              List<CartModel> _cartList = Provider.of<CartProvider>(context, listen: false).cartList;
                              List<Cart> carts = [];
                              for (int index = 0; index < _cartList.length; index++) {
                                Cart cart = Cart(
                                  productId: _cartList[index].id, price: _cartList[index].price, discountAmount: _cartList[index].discountedPrice,
                                  quantity: _cartList[index].quantity, taxAmount: _cartList[index].tax,
                                  variant: '', variation: [Variation(type: _cartList[index].variation != null ? _cartList[index].variation.type : null)],
                                );
                                carts.add(cart);
                              }
                              order.placeOrder(PlaceOrderBody(
                                cart: carts, orderType: widget.orderType, couponCode: widget.couponCode, orderNote: _noteController.text,
                                branchId: _branches[order.branchIndex].id,
                                deliveryAddressId: !_selfPickup ? Provider.of<LocationProvider>(context, listen: false)
                                    .addressList[order.addressIndex].id : 0, distance: _selfPickup ? 0 : order.distance,
                                couponDiscountAmount: Provider.of<CouponProvider>(context, listen: false).discount, timeSlotId: order.timeSlots[order.selectTimeSlot].id,
                                paymentMethod: _isCashOnDeliveryActive ? order.paymentMethodIndex == 0 ? 'cash_on_delivery' : null : null,
                                deliveryDate: order.getDates(context)[order.selectDateSlot], couponDiscountTitle: '', orderAmount: widget.amount+_deliveryCharge,
                              ), _callback);
                            }
                          },
                        ),
                      ),
                    ),
                  ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),

                ],
              );
            },
          );
        },
      ) : NotLoggedInScreen()
    );
  }

  void _callback(bool isSuccess, String message, String orderID) async {
    if (isSuccess) {
      Provider.of<ProductProvider>(context, listen: false).getPopularProductList(context, '1', true,Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,);
      Provider.of<CartProvider>(context, listen: false).clearCartList();
      Provider.of<OrderProvider>(context, listen: false).stopLoader();
      if (_isCashOnDeliveryActive && Provider.of<OrderProvider>(context, listen: false).paymentMethodIndex == 0) {
        Navigator.pushReplacementNamed(context,
          '${RouteHelper.orderSuccessful}$orderID/success',
          arguments: OrderSuccessfulScreen(
            orderID: orderID, status: 0,
          ),
        );
      } else {
        OrderModel _orderModel = OrderModel(
          paymentMethod: '', id: int.parse(orderID), userId: Provider.of<ProfileProvider>(context, listen: false).userInfoModel.id,
          couponDiscountAmount: widget.discount, orderStatus: 'pending', paymentStatus: 'unpaid',
          timeSlotId: Provider.of<OrderProvider>(context, listen: false).timeSlots[Provider.of<OrderProvider>(context, listen: false).selectTimeSlot].id,
          deliveryAddressId: widget.orderType != 'self_pickup' ? Provider.of<LocationProvider>(context, listen: false)
              .addressList[Provider.of<OrderProvider>(context, listen: false).addressIndex].id : 0,
          deliveryCharge: Provider.of<SplashProvider>(context, listen: false).configModel.deliveryCharge,
          createdAt: DateConverter.localDateToIsoString(DateTime.now()), updatedAt: DateConverter.localDateToIsoString(DateTime.now()),
        );
        if(ResponsiveHelper.isWeb()) {
          String hostname = html.window.location.hostname;
          String protocol = html.window.location.protocol;
          String selectedUrl = '${AppConstants.BASE_URL}/payment-mobile?order_id=$orderID&&customer_id=${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.id}'
              '&&callback=$protocol//$hostname${RouteHelper.orderSuccessful}$orderID';
          html.window.open(selectedUrl,"_self");
        } else{
          Navigator.pushReplacementNamed(context,
            RouteHelper.getPaymentRoute('checkout', _orderModel.id.toString(), _orderModel.userId),
            arguments: PaymentScreen(orderModel: _orderModel, fromCheckout: true),
          );
        }

      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: Duration(milliseconds: 600), backgroundColor: Colors.red),);
    }
  }

  void _setMarkers(int selectedIndex) async {
    BitmapDescriptor _bitmapDescriptor;
    BitmapDescriptor _bitmapDescriptorUnSelect;
    // Uint8List activeImageData = await convertAssetToUnit8List(Images.restaurant_marker, width: ResponsiveHelper.isMobilePhone() ? 30 : 30);
    // Uint8List inactiveImageData = await convertAssetToUnit8List(Images.unselected_restaurant_marker, width: ResponsiveHelper.isMobilePhone() ? 30 : 30);
    await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(30, 50)), Images.restaurant_marker).then((_marker) {
      _bitmapDescriptor = _marker;
    });
    await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(20, 20)), Images.unselected_restaurant_marker).then((_marker) {
      _bitmapDescriptorUnSelect = _marker;
    });
    // Marker
    _markers = HashSet<Marker>();
    for(int index=0; index<_branches.length; index++) {
      _markers.add(Marker(
        markerId: MarkerId('branch_$index'),
        position: LatLng(double.parse(_branches[index].latitude), double.parse(_branches[index].longitude)),
        infoWindow: InfoWindow(title: _branches[index].name, snippet: _branches[index].address),
        icon: selectedIndex == index ? _bitmapDescriptor : _bitmapDescriptorUnSelect,
      ));
    }

    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
      double.parse(_branches[selectedIndex].latitude),
      double.parse(_branches[selectedIndex].longitude),
    ), zoom: ResponsiveHelper.isMobile(context) ? 12 : 16)));

    setState(() {});
  }

  Future<Uint8List> convertAssetToUnit8List(String imagePath, {int width = 50}) async {
    ByteData data = await rootBundle.load(imagePath);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png)).buffer.asUint8List();
  }

}
