import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/price_converter.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/provider/product_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/on_hover.dart';
import 'package:flutter_grocery/view/screens/product/product_details_screen.dart';
import 'package:provider/provider.dart';
class WebDailyItemView extends StatelessWidget {
  final ProductProvider productProvider;
  final int index;
   WebDailyItemView({Key key,@required this.productProvider,@required this.index}) : super(key: key);

  final oneSideShadow = Padding(
    padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
    child: Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: ColorResources.Black_COLOR.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 0), // changes position of shadow
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return OnHover(
      isItem: true,
      child: InkWell(
        onTap: (){
          Navigator.of(context).pushNamed(RouteHelper.getProductDetailsRoute(product: productProvider.dailyItemList[index]),
              arguments: ProductDetailsScreen(product: productProvider.dailyItemList[index]));
        },
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SIZE_TEN),
        child: Container(
          decoration: BoxDecoration(
              color: ColorResources.getCardBgColor(context),
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SIZE_TEN),
              boxShadow: [
                BoxShadow(
                    color: ColorResources.Black_COLOR.withOpacity(0.05),
                    offset: const Offset(0, 4),
                    blurRadius: 7,
                    spreadRadius: 0.1
                )
              ]
          ),
          child: Column(
            children: [
              Expanded(
                  flex: 6,
                  child: Stack(
                    children: [
                      oneSideShadow,
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(top: 5,left: 5,right: 5),
                        decoration: BoxDecoration(
                            color: ColorResources.getCardBgColor(context),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.RADIUS_SIZE_TEN),topRight: Radius.circular(Dimensions.RADIUS_SIZE_TEN)),
                            // boxShadow: [
                            //   BoxShadow(
                            //       color: ColorResources.Black_COLOR.withOpacity(0.1),
                            //       offset: const Offset(0, 0),
                            //       blurRadius: 10,
                            //       spreadRadius: 0,
                            //       blurStyle: BlurStyle.outer
                            //   ),
                            // ]
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.RADIUS_SIZE_TEN),topRight: Radius.circular(Dimensions.RADIUS_SIZE_TEN)),
                          child: FadeInImage.assetNetwork(
                            width: 100,
                            height: 150,
                            fit: BoxFit.cover,
                            placeholder: Images.placeholder(context),
                            image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}'
                                '/${productProvider.dailyItemList[index].image[0]}',
                            imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder(context), width: 100, height: 150, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              Expanded(flex: 4,child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Text(
                      productProvider.dailyItemList[index].name,
                      style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                      maxLines: 1, overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,
                    ),
                    Text(
                      '${productProvider.dailyItemList[index].capacity} ${productProvider.dailyItemList[index].unit}',
                      style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                      maxLines: 2, overflow: TextOverflow.ellipsis,
                    ),



                    Text(
                      PriceConverter.convertPrice(
                        context, productProvider.dailyItemList[index].price,
                        discount: productProvider.dailyItemList[index].discount,
                        discountType: productProvider.dailyItemList[index].discountType,
                      ),
                      style: poppinsBold.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                    ),

                    productProvider.dailyItemList[index].discount > 0 ? Text(
                      PriceConverter.convertPrice(
                        context, productProvider.dailyItemList[index].price,
                      ),
                      style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: ColorResources.RED_COLOR,decoration: TextDecoration.lineThrough),
                    ) : SizedBox(),

                    // const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          getTranslated('add_to_cart', context),
                          style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT,color: Theme.of(context).primaryColor),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        SizedBox(height: 16,width: 16,
                          child: Image.asset(Images.shopping_cart_bold),),
                      ],
                    )*/
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );

  }
}
