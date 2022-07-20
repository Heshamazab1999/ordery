
import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/product_model.dart';
import 'package:flutter_grocery/helper/price_converter.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/cart_provider.dart';
import 'package:flutter_grocery/provider/product_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';
import 'package:flutter_grocery/view/screens/product/widget/variation_view.dart';
import 'package:provider/provider.dart';

class WebProductInformation extends StatelessWidget {
  final Product product;
  final int stock;
  final int cartIndex;
  final  double priceWithQuantity;
  WebProductInformation({@required this.product, @required this.stock, @required this.cartIndex, @required this.priceWithQuantity});

  @override
  Widget build(BuildContext context) {

    double _startingPrice;
    double _endingPrice;
    if(product.variations.length != 0) {
      List<double> _priceList = [];
      product.variations.forEach((variation) => _priceList.add(variation.price));
      _priceList.sort((a, b) => a.compareTo(b));
      _startingPrice = _priceList[0];
      if(_priceList[0] < _priceList[_priceList.length-1]) {
        _endingPrice = _priceList[_priceList.length-1];
      }
    }else {
      _startingPrice = product.price;
    }


    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
        children: [
      Text(
        product.name ?? '',
        style: poppinsBold.copyWith(fontSize: Dimensions.FONT_SIZE_MAX_LARGE, color: ColorResources.getProductDescriptionColor(context)),
        maxLines: 2,
      ),
      const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
      Text(
        '${product.capacity} ${product.unit}',
        style: poppinsRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.FONT_SIZE_LARGE),
      ),
      const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

      //Product Price
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${PriceConverter.convertPrice(context, _startingPrice, discount: product.discount, discountType: product.discountType)}'
                '${_endingPrice!= null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: product.discount, discountType: product.discountType)}' : ''}',
            style: poppinsBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.FONT_SIZE_OVER_LARGE),
          ),
          const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
          product.discount > 0 ? Text(
            '${PriceConverter.convertPrice(context, _startingPrice)}'
                '${_endingPrice!= null ? ' - ${PriceConverter.convertPrice(context, _endingPrice)}' : ''}',
            style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT, color: ColorResources.RED_COLOR,decoration: TextDecoration.lineThrough),
          ): SizedBox(),
        ],
      ),


      VariationView(product: product),


      const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

      const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE ),

      Builder(
        builder: (context) {
          return Row(children: [
            QuantityButton(isIncrement: false, quantity: Provider.of<ProductProvider>(context, listen: false).quantity, stock: stock, cartIndex: cartIndex),
            SizedBox(width: 30),
            Consumer<ProductProvider>(builder: (context, product, child) {
              return Consumer<CartProvider>(builder: (context, cart, child) {
                return Text(cartIndex != null ? cart.cartList[cartIndex].quantity.toString() : product.quantity.toString(), style: poppinsSemiBold);
              });
            }),
            SizedBox(width: 30),
            QuantityButton(isIncrement: true, quantity: Provider.of<ProductProvider>(context, listen: false).quantity, stock: stock, cartIndex: cartIndex),
          ]);
        }
      ),

      const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
          Row(children: [
            Text('${getTranslated('total_amount', context)}:', style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Text(PriceConverter.convertPrice(context, priceWithQuantity), style: poppinsBold.copyWith(
              color: Theme.of(context).primaryColor, fontSize: Dimensions.FONT_SIZE_LARGE,
            )),
          ]),
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),


    ]);
  }
}

class QuantityButton extends StatelessWidget {
  final bool isIncrement;
  final int cartIndex;
  final int quantity;
  final bool isCartWidget;
  final int stock;
  QuantityButton({
    @required this.isIncrement,
    @required this.quantity,
    @required this.stock,
    this.isCartWidget = false,
    @required this.cartIndex,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(cartIndex != null) {
          if(isIncrement) {
            if (Provider.of<CartProvider>(context, listen: false).cartList[cartIndex].quantity < Provider.of<CartProvider>(context, listen: false).cartList[cartIndex].stock) {
              Provider.of<CartProvider>(context, listen: false).setQuantity(true, cartIndex);
            } else {
              showCustomSnackBar(getTranslated('out_of_stock', context), context);
            }
          }else {
            if (Provider.of<CartProvider>(context, listen: false).cartList[cartIndex].quantity > 1) {
              Provider.of<CartProvider>(context, listen: false).setQuantity(false, cartIndex);
            } else {
              Provider.of<ProductProvider>(context, listen: false).setExistData(null);
              Provider.of<CartProvider>(context, listen: false).removeFromCart(cartIndex, context);
            }
          }
        }else {
          if (!isIncrement && quantity > 1) {
            Provider.of<ProductProvider>(context, listen: false).setQuantity(false);
          } else if (isIncrement) {
            if(quantity < stock) {
              Provider.of<ProductProvider>(context, listen: false).setQuantity(true);
            }else {
              showCustomSnackBar(getTranslated('out_of_stock', context), context);
            }
          }
        }
      },
      child: Container(
        // padding: EdgeInsets.all(3),
        height: 50,width: 50,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Theme.of(context).primaryColor),
        child: Center(
          child: Icon(
            isIncrement ? Icons.add : Icons.remove,
            color: isIncrement
                ? ColorResources.getWhiteColor(context)
                : quantity > 1
                ? ColorResources.getWhiteColor(context)
                : ColorResources.getWhiteColor(context),
            size: isCartWidget ? 26 : 20,
          ),
        ),
      ),
    );
  }
}
