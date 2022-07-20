import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/order_model.dart';
import 'package:flutter_grocery/helper/price_converter.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/location_provider.dart';
import 'package:flutter_grocery/provider/order_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/provider/theme_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_app_bar.dart';
import 'package:flutter_grocery/view/base/footer_view.dart';
import 'package:flutter_grocery/view/base/web_app_bar/web_app_bar.dart';
import 'package:flutter_grocery/view/screens/order/widget/custom_stepper.dart';
import 'package:flutter_grocery/view/screens/order/widget/delivery_man_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_grocery/view/screens/order/widget/tracking_map_widget.dart';

class TrackOrderScreen extends StatelessWidget {
  final String orderID;
  final bool isBackButton;
  final OrderModel orderModel;
  TrackOrderScreen({@required this.orderID, this.isBackButton = false, this.orderModel});

  @override
  Widget build(BuildContext context) {

    Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
    Provider.of<OrderProvider>(context, listen: false).getDeliveryManData(orderID, context);
    Provider.of<OrderProvider>(context, listen: false).trackOrder(orderID, orderModel,  context, true);
    final List<String> _statusList = ['pending', 'confirmed', 'processing', 'out_for_delivery', 'delivered', 'returned', 'failed', 'canceled'];

    return Scaffold(
      backgroundColor: ColorResources.getBackgroundColor(context),
      appBar: ResponsiveHelper.isDesktop(context)? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120)): CustomAppBar(
        title: getTranslated('track_order', context),
        isCenter: false,
        onBackPressed: () {
          if (isBackButton) {
            Provider.of<SplashProvider>(context, listen: false).setPageIndex(0);
           Navigator.pushNamed(context, RouteHelper.menu);
           // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MenuScreen()));
          } else {
            Navigator.of(context).pop();
          }
        },
      ),
      body: Center(
        child: Consumer<OrderProvider>(
          builder: (context, orderProvider, child) {
            String _status;
            if (orderProvider.trackModel != null) {
              _status = orderProvider.trackModel.orderStatus;
            }

            return orderProvider.trackModel != null
                ? ListView(

                    children: [
                      Center(
                        child: SizedBox(
                          width: 1170,
                          child: Padding(
                              padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isDesktop(context)? 50 : 5,horizontal: ResponsiveHelper.isDesktop(context)? 200 : 20),
                            child: Column(children: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  color: ColorResources.getCardBgColor(context),
                                  boxShadow: [
                                    BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 200], spreadRadius: 0.5, blurRadius: 0.5)
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text('${getTranslated('order_id', context)} #${orderProvider.trackModel.id}',
                                          style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                    ),
                                    Text(
                                      '${getTranslated('amount', context)}${PriceConverter.convertPrice(context, orderProvider.trackModel.orderAmount)}',
                                      style: poppinsRegular,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                              Provider.of<OrderProvider>(context, listen: false).orderType != 'self_pickup' ? Container(
                                padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_LARGE, horizontal: Dimensions.PADDING_SIZE_SMALL),
                                decoration: BoxDecoration(
                                  color: ColorResources.getCardBgColor(context),
                                  borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  boxShadow: [
                                    BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 200], spreadRadius: 0.5, blurRadius: 0.5)
                                  ],
                                ),
                                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Icon(Icons.location_on, color: Theme.of(context).primaryColor),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Text(
                                      orderProvider.trackModel.deliveryAddress != null? orderProvider.trackModel.deliveryAddress.address : getTranslated('address_was_deleted', context),
                                      style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: ColorResources.getTextColor(context)),
                                    ),
                                  ),
                                ]),
                              ) : SizedBox(),

                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                              orderProvider.trackModel.deliveryMan != null ? DeliveryManWidget(deliveryMan: orderProvider.trackModel.deliveryMan) : SizedBox(),
                              orderProvider.trackModel.deliveryMan != null ? SizedBox(height: 30) : SizedBox(),

                              CustomStepper(title: getTranslated('order_placed', context), isActive: true, haveTopBar: false),
                              CustomStepper(title: getTranslated('order_accepted', context), isActive: _status != _statusList[0]),
                              CustomStepper(title: getTranslated('preparing_items', context), isActive: _status != _statusList[0] && _status != _statusList[1]),
                              CustomStepper(
                                title: getTranslated('order_in_the_way', context),
                                isActive: _status != _statusList[0] && _status != _statusList[1] && _status != _statusList[2],
                              ),
                              (orderProvider.trackModel != null && orderProvider.trackModel.deliveryAddress != null) ?
                              CustomStepper(title: getTranslated('delivered_the_order', context), isActive: _status == _statusList[4], height: _status == _statusList[3] ? 170 : 30,
                                child: _status == _statusList[3] ? Flexible(
                                  child: TrackingMapWidget(
                                    deliveryManModel: orderProvider.deliveryManModel,
                                    orderID: orderID, branchID: orderProvider.trackModel.branchId,

                                    addressModel: orderProvider.trackModel.deliveryAddress??''
                                  ),
                                ) : null,
                              ) : CustomStepper(
                                title: getTranslated('delivered_the_order', context),
                                isActive: _status == _statusList[4], height: _status == _statusList[3] ? 30 : 30,
                              ),
                              ResponsiveHelper.isDesktop(context) ? SizedBox(height: 100) : SizedBox(),

                            ],),
                          ),
                        ),
                      ),
                      ResponsiveHelper.isDesktop(context) ? FooterView() : SizedBox(),

                    ],
                  )
                : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
          },
        ),
      ),
    );
  }
}
