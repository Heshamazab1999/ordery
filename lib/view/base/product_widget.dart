
import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/cart_model.dart';
import 'package:flutter_grocery/data/model/response/product_model.dart';
import 'package:flutter_grocery/helper/price_converter.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/cart_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';
import 'package:flutter_grocery/view/base/on_hover.dart';
import 'package:flutter_grocery/view/screens/product/product_details_screen.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final CartModel cart;
  ProductWidget({@required this.product, this.cart});


  final oneSideShadow = Padding(
    padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
    child: Container(
      margin: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: ColorResources.Black_COLOR.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          double _price = 0;
          int _stock = 0;
          bool isExistInCart = false;
          int cardIndex;
          CartModel _cartModel;
          if(cartProvider.cartList != null) {
            if(product.variations.length > 0) {
              for(int index=0; index<product.variations.length; index++) {
                _price = product.variations.length > 0 ? product.variations[index].price : product.price;
                _stock = product.variations.length > 0 ? product.variations[index].stock : product.totalStock;
                _cartModel = CartModel(product.id, product.image[0], product.name, _price,
                  PriceConverter.convertWithDiscount(
                      context, _price, product.discount, product.discountType),
                  1,
                  product.variations.length > 0 ? product.variations[index] : null,
                  (_price - PriceConverter.convertWithDiscount(context, _price, product.discount, product.discountType)),
                  (_price - PriceConverter.convertWithDiscount(context, _price, product.tax, product.taxType)),
                  product.capacity,
                  product.unit,
                  _stock,product
                );
                isExistInCart = Provider.of<CartProvider>(context, listen: false).isExistInCart(_cartModel) != null;
                cardIndex = Provider.of<CartProvider>(context, listen: false).isExistInCart(_cartModel);
                if(isExistInCart) {
                  break;
                }
              }
            }else {
              _price = product.variations.length > 0 ? product.variations[0].price : product.price;
              _stock = product.variations.length > 0 ? product.variations[0].stock : product.totalStock;
              _cartModel = CartModel(product.id, product.image[0], product.name, _price,
                PriceConverter.convertWithDiscount(
                    context, _price, product.discount, product.discountType),
                1,
                product.variations.length > 0 ? product.variations[0] : null,
                (_price - PriceConverter.convertWithDiscount(context, _price, product.discount, product.discountType)),
                (_price - PriceConverter.convertWithDiscount(context, _price, product.tax, product.taxType)),
                product.capacity,
                product.unit,
                _stock,product
              );
              isExistInCart = Provider.of<CartProvider>(context, listen: false).isExistInCart(_cartModel) != null;
              cardIndex = Provider.of<CartProvider>(context, listen: false).isExistInCart(_cartModel);
            }
          }

      return ResponsiveHelper.isDesktop(context)
          ? OnHover(
            isItem: true,
            child: InkWell(
              borderRadius:  BorderRadius.circular(Dimensions.RADIUS_SIZE_TEN),
              onTap: () {
                Navigator.of(context).pushNamed(RouteHelper.getProductDetailsRoute(product: product),
                );
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: ColorResources.getCardBgColor(context),
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SIZE_TEN),
                      boxShadow: [BoxShadow(
                            color: ColorResources.Black_COLOR.withOpacity(0.05),
                            offset: const Offset(0, 4),
                            blurRadius: 7,
                            spreadRadius: 0.1)]),
                  child: Column(
                    children: [
                      Expanded(
                          flex: 6,
                          child: Stack(
                            children: [
                              oneSideShadow,
                              Container(
                                padding: EdgeInsets.all(5),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: ColorResources.getCardBgColor(context),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(Dimensions.RADIUS_SIZE_TEN),
                                        topRight: Radius.circular(Dimensions.RADIUS_SIZE_TEN)),
                                    ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(Dimensions.RADIUS_SIZE_TEN),
                                      topRight: Radius.circular(Dimensions.RADIUS_SIZE_TEN)),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: Images.placeholder(context),
                                    height: 155,
                                    fit: BoxFit.cover,
                                    image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${product.image[0]}',
                                    imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder(context), width: 80, height: 155, fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Expanded(
                          flex: 5,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  product.name,
                                  style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  '${product.capacity} ${product.unit}',
                                  style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        PriceConverter.convertPrice(context, product.price, discount: product.discount, discountType: product.discountType),
                                        style: poppinsBold.copyWith(
                                            fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                                    product.discount > 0
                                        ? Text(PriceConverter.convertPrice(context, product.price),
                                            style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: ColorResources.RED_COLOR,decoration: TextDecoration.lineThrough),
                                          ) : SizedBox(height: 15,),

                                  ],
                                ),
                                const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                !isExistInCart
                                    ? InkWell(
                                        onTap: () {
                                          if(product.variations == null || product.variations.length == 0) {
                                            if (isExistInCart) {
                                              showCustomSnackBar(getTranslated('already_added', context), context);
                                            } else if (_stock < 1) {
                                              showCustomSnackBar(getTranslated('out_of_stock', context), context);
                                            } else {
                                              Provider.of<CartProvider>(context, listen: false).addToCart(_cartModel);
                                              showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
                                            }
                                          }else {
                                            Navigator.of(context).pushNamed(
                                              RouteHelper.getProductDetailsRoute(product: product),
                                            );
                                          }
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              getTranslated('add_to_cart', context),
                                              style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT, color: Theme.of(context).primaryColor),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                            SizedBox(
                                              height: 16,
                                              width: 16,
                                              child: Image.asset(Images.shopping_cart_bold),),
                                          ],
                                        ),
                                      )
                                    : Consumer<CartProvider>(builder: (context, cart, child) =>
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                                children: [
                                          InkWell(
                                            onTap: () {
                                              if (cart.cartList[cardIndex].quantity > 1) {
                                                Provider.of<CartProvider>(context, listen: false).setQuantity(false, cardIndex);
                                              } else {
                                                Provider.of<CartProvider>(context, listen: false).removeFromCart(cardIndex, context);
                                              }
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                              child: Icon(Icons.remove,
                                                  size: 20,
                                                  color: Theme.of(context).primaryColor),
                                            ),
                                          ),
                                          Text(
                                              cart.cartList[cardIndex].quantity.toString(),
                                              style: poppinsSemiBold.copyWith(
                                                  fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                                  color: Theme.of(context).primaryColor)),
                                          InkWell(
                                            onTap: () {
                                              if (cart.cartList[cardIndex].quantity < cart.cartList[cardIndex].stock) {
                                                Provider.of<CartProvider>(context, listen: false).setQuantity(true, cardIndex);
                                              } else {
                                                showCustomSnackBar(getTranslated('out_of_stock', context), context);
                                              }
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      Dimensions.PADDING_SIZE_SMALL,
                                                  vertical: Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL),
                                              child: Icon(Icons.add,
                                                  size: 20,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                          ),
                                        ]),
                                      ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
            ),
          )
          : Padding(
              padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    RouteHelper.getProductDetailsRoute(product: product),
                  );
                 // Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetailsScreen(product: product,cart: isExistInCart ? Provider.of<CartProvider>(context, listen: false).cartList[cardIndex]:null,)));
                },
                child: Container(
                  height: 85,
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorResources.getCardBgColor(context),
                  ),
                  child: Row(children: [
                    Container(
                      height: 85,
                      width: 85,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 2,
                            color: ColorResources.getGreyColor(context)),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.placeholder(context),
                          image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${product.image[0]}',
                          fit: BoxFit.cover,
                          width: 85,
                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder(context), width: 85, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_SMALL),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(product.name,
                                style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 10),
                              Text('${product.capacity} ${product.unit}',
                                  style: poppinsRegular.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_SMALL,
                                      color: ColorResources.getTextColor(context))),
                            ]),
                      ),
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            PriceConverter.convertPrice(context, product.price, discount: product.discount, discountType: product.discountType),
                            style: poppinsBold.copyWith(
                                fontSize: Dimensions.FONT_SIZE_SMALL),
                          ),
                          product.discount > 0
                              ? Text(
                                  PriceConverter.convertPrice(context, product.price),
                                  style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, decoration: TextDecoration.lineThrough,),
                                )
                              : SizedBox(),
                          Expanded(child: SizedBox()),
                          !isExistInCart
                              ? InkWell(
                                  onTap: () {
                                    if(product.variations == null || product.variations.length == 0) {
                                      if (isExistInCart) {
                                        showCustomSnackBar(getTranslated('already_added', context), context);
                                      } else if (_stock < 1) {
                                        showCustomSnackBar(getTranslated('out_of_stock', context), context);
                                      } else {
                                        Provider.of<CartProvider>(context, listen: false).addToCart(_cartModel);
                                        showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
                                      }
                                    }else {
                                      Navigator.of(context).pushNamed(
                                        RouteHelper.getProductDetailsRoute(product: product),
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    margin: EdgeInsets.all(2),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1, color: ColorResources.getHintColor(context).withOpacity(0.2)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(Icons.add,
                                        color: Theme.of(context).primaryColor),
                                  ))
                              : Consumer<CartProvider>(builder: (context, cart, child) =>
                                Row(children: [
                                    InkWell(
                                      onTap: () {
                                        if (cart.cartList[cardIndex].quantity > 1) {
                                          Provider.of<CartProvider>(context, listen: false).setQuantity(false, cardIndex);
                                        } else {
                                          Provider.of<CartProvider>(context, listen: false).removeFromCart(cardIndex, context);
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Dimensions.PADDING_SIZE_SMALL,
                                            vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                        child: Icon(Icons.remove, size: 20, color: Theme.of(context).primaryColor),
                                      ),
                                    ),
                                    Text(
                                        cart.cartList[cardIndex].quantity.toString(),
                                        style: poppinsSemiBold.copyWith(
                                            fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                            color: Theme.of(context).primaryColor)),
                                    InkWell(
                                      onTap: () {
                                        if (cart.cartList[cardIndex].quantity <
                                            cart.cartList[cardIndex].stock) {
                                          Provider.of<CartProvider>(context, listen: false).setQuantity(true, cardIndex);
                                        } else {
                                          showCustomSnackBar(getTranslated('out_of_stock', context), context);
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Dimensions.PADDING_SIZE_SMALL,
                                            vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                        child: Icon(Icons.add, size: 20, color: Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  ]),
                                ),
                        ]),
                  ]),
                ),
              ),
            );
    });
  }
}
