import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/price_converter.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/cart_provider.dart';
import 'package:flutter_grocery/provider/coupon_provider.dart';
import 'package:flutter_grocery/provider/localization_provider.dart';
import 'package:flutter_grocery/provider/order_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/provider/theme_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:flutter_grocery/view/base/custom_divider.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';
import 'package:flutter_grocery/view/base/footer_view.dart';
import 'package:flutter_grocery/view/screens/cart/widget/cart_product_widget.dart';
import 'package:flutter_grocery/view/screens/cart/widget/delivery_option_button.dart';
import 'package:flutter_grocery/view/screens/checkout/checkout_screen.dart';
import 'package:provider/provider.dart';

class WebCartView extends StatelessWidget {
  const WebCartView({
    Key key,
    @required TextEditingController couponController,
    @required double total,
    @required bool isSelfPickupActive,
    @required bool kmWiseCharge,
    @required double itemPrice,
    @required double tax,
    @required double discount,
    @required this.cart,
    @required this.deliveryCharge,
  }) : _couponController = couponController, _total = total, _isSelfPickupActive = isSelfPickupActive, _kmWiseCharge = kmWiseCharge, _itemPrice = itemPrice, _tax = tax, _discount = discount, super(key: key);

  final TextEditingController _couponController;
  final double _total;
  final bool _isSelfPickupActive;
  final bool _kmWiseCharge;
  final double _itemPrice;
  final double _tax;
  final double _discount;
  final double deliveryCharge;
  final CartProvider cart;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.height - 560 : MediaQuery.of(context).size.height),
              child: SizedBox(
                width: 1170,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_LARGE),
                  child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Expanded(
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cart.cartList.length,
                      padding: EdgeInsets.only(top:Dimensions.PADDING_SIZE_LARGE),
                      itemBuilder: (context, index) {
                        return CartProductWidget(cart: cart.cartList[index], index: index,);
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [

                        Container(
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
                          margin: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL,vertical: Dimensions.PADDING_SIZE_LARGE),
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE,vertical: Dimensions.PADDING_SIZE_LARGE),
                          child: Column(children: [
                            // Coupon
                            Consumer<CouponProvider>(
                              builder: (context, coupon, child) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color:ColorResources.CARD_SHADOW_COLOR.withOpacity(0.2),
                                        blurRadius: 10,
                                      )
                                    ]
                                  ),
                                  child: Row(children: [
                                    SizedBox(width: 1),
                                    Expanded(
                                      child: TextField(
                                        controller: _couponController,
                                        style: poppinsMedium,
                                        decoration: InputDecoration(
                                            hintText: getTranslated('enter_promo_code', context),
                                            hintStyle: poppinsRegular.copyWith(color: ColorResources.getHintColor(context)),
                                            isDense: true,
                                            filled: true,
                                            enabled: coupon.discount == 0,
                                            fillColor: Theme.of(context).cardColor,
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.horizontal(left: Radius.circular(10)), borderSide: BorderSide.none)),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (_couponController.text.isNotEmpty && !coupon.isLoading) {
                                          if (coupon.discount < 1) {
                                            coupon.applyCoupon(_couponController.text, _total).then((discount) {
                                              if (discount > 0) {
                                                showCustomSnackBar('You got ${PriceConverter.convertPrice(context, discount)} discount', context,isError: false);
                                              } else {
                                                showCustomSnackBar(getTranslated('invalid_code_or_failed', context),context,isError: true);
                                              }
                                            });
                                          } else {
                                            coupon.removeCouponData(true);
                                          }
                                        }else {
                                          showCustomSnackBar(getTranslated('enter_a_coupon_code', context),context,isError: true);

                                        }
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 100,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.horizontal(
                                            right: Radius.circular(Provider.of<LocalizationProvider>(context, listen: false).isLtr ? 10 : 0),
                                            left: Radius.circular(Provider.of<LocalizationProvider>(context, listen: false).isLtr ? 0 : 10),
                                          ),
                                        ),
                                        child: coupon.discount <= 0
                                            ? !coupon.isLoading
                                            ? Text(
                                          getTranslated('apply', context),
                                          style: poppinsMedium.copyWith(color: Colors.white),
                                        )
                                            : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                                            : Icon(Icons.clear, color: Colors.white),
                                      ),
                                    ),
                                  ]),
                                );
                              },
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                            // Order type
                            _isSelfPickupActive ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(getTranslated('delivery_option', context), style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                              DeliveryOptionButton(value: 'delivery', title: getTranslated('delivery', context), kmWiseFee: _kmWiseCharge),
                              DeliveryOptionButton(value: 'self_pickup', title: getTranslated('self_pickup', context), kmWiseFee: _kmWiseCharge),
                              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                            ]) : SizedBox(),

                            // Total
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text(getTranslated('items_price', context), style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                              Text(PriceConverter.convertPrice(context, _itemPrice), style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                            ]),
                            SizedBox(height: 10),

                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text(getTranslated('tax', context), style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                              Text('(+) ${PriceConverter.convertPrice(context, _tax)}', style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                            ]),
                            SizedBox(height: 10),

                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text(getTranslated('discount', context), style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                              Text('(-) ${PriceConverter.convertPrice(context, _discount)}',
                                  style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                            ]),
                            SizedBox(height: 10),

                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text(getTranslated('coupon_discount', context), style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                              Text(
                                '(-) ${PriceConverter.convertPrice(context, Provider.of<CouponProvider>(context).discount)}',
                                style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                              ),
                            ]),
                            SizedBox(height: 10),

                            _kmWiseCharge ? SizedBox() : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text(
                                getTranslated('delivery_fee', context),
                                style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                              ),
                              Text(
                                '(+) ${PriceConverter.convertPrice(context, deliveryCharge)}',
                                style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                              ),
                            ]),

                            Padding(
                              padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                              child: CustomDivider(),
                            ),

                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text(getTranslated(_kmWiseCharge ? 'subtotal' : 'total_amount', context), style: poppinsMedium.copyWith(
                                fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                color: Theme.of(context).primaryColor,
                              )),
                              Text(
                                PriceConverter.convertPrice(context, _total),
                                style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Theme.of(context).primaryColor),
                              ),
                            ]),


                          ],),

                        ),
                        Container(
                          // width: 100,
                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          child: CustomButton(
                            buttonText: getTranslated('continue_checkout', context),
                            onPressed: () {
                              if(_itemPrice < Provider.of<SplashProvider>(context, listen: false).configModel.minimumOrderValue) {
                                showCustomSnackBar('${getTranslated('minimum_order_amount_is', context)}${PriceConverter.convertPrice(context, Provider.of<SplashProvider>(context, listen: false).configModel
                                    .minimumOrderValue)},${getTranslated('you_have', context)} ${PriceConverter.convertPrice(context, _itemPrice)} ${getTranslated('in_your_cart_please_add_more_item', context)}',context,isError: true);

                              } else {
                                String _orderType = Provider.of<OrderProvider>(context, listen: false).orderType;
                                double _discount = Provider.of<CouponProvider>(context, listen: false).discount;
                                Navigator.pushNamed(
                                  context, RouteHelper.getCheckoutRoute(
                                  _total, _discount, _orderType,
                                  Provider.of<CouponProvider>(context, listen: false).code,
                                ),
                                  arguments: CheckoutScreen(
                                    amount: _total, orderType: _orderType, discount: _discount,
                                    couponCode: Provider.of<CouponProvider>(context, listen: false).code,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )

                  ],
              ),
                ),
              ),
            ),
          ),
          FooterView() ,
        ],
      ),
    );
  }
}