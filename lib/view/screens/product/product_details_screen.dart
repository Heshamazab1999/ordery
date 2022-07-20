import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/cart_model.dart';
import 'package:flutter_grocery/data/model/response/product_model.dart';
import 'package:flutter_grocery/helper/price_converter.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/cart_provider.dart';
import 'package:flutter_grocery/provider/localization_provider.dart';
import 'package:flutter_grocery/provider/product_provider.dart';
import 'package:flutter_grocery/provider/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/custom_button.dart';
import 'package:flutter_grocery/view/base/custom_snackbar.dart';
import 'package:flutter_grocery/view/base/footer_view.dart';
import 'package:flutter_grocery/view/base/title_row.dart';
import 'package:flutter_grocery/view/base/web_app_bar/web_app_bar.dart';
import 'package:flutter_grocery/view/screens/product/product_description_screen.dart';
import 'package:flutter_grocery/view/screens/product/widget/details_app_bar.dart';
import 'package:flutter_grocery/view/screens/product/widget/variation_view.dart';
import 'package:flutter_grocery/view/screens/product/widget/product_description_view.dart';
import 'package:flutter_grocery/view/screens/product/widget/product_image_view.dart';
import 'package:flutter_grocery/view/screens/product/widget/product_title_view.dart';
import 'package:flutter_grocery/view/screens/product/widget/web_product_information.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;
  ProductDetailsScreen({@required this.product});

  @override
  Widget build(BuildContext context) {
    Provider.of<SplashProvider>(context, listen: false).initSharedData();
    Provider.of<CartProvider>(context, listen: false).getCartData();
    Provider.of<CartProvider>(context, listen: false).setSelect(0, false);

    Variations _variation;
    final GlobalKey<DetailsAppBarState> _key = GlobalKey();

    Provider.of<ProductProvider>(context, listen: false).getProductDetails(context, product,Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode);

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120))  : DetailsAppBar(key: _key),

      body: Consumer<CartProvider>(builder: (context, cart, child) {
        return  Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            double price = 0;
            int _stock = 0;
            double priceWithQuantity = 0;
            CartModel _cartModel;

            if(productProvider.product != null) {
              List<String> _variationList = [];
              for (int index = 0; index < productProvider.product.choiceOptions.length; index++) {
                _variationList.add(productProvider.product.choiceOptions[index].options[productProvider.variationIndex[index]].replaceAll(' ', ''));
              }
              String variationType = '';
              bool isFirst = true;
              _variationList.forEach((variation) {
                if (isFirst) {
                  variationType = '$variationType$variation';
                  isFirst = false;
                } else {
                  variationType = '$variationType-$variation';
                }
              });

              price = productProvider.product.price;
              _stock = productProvider.product.totalStock;
              for (Variations variation in productProvider.product.variations) {
                if (variation.type == variationType) {
                  price = variation.price;
                  _variation = variation;
                  _stock = variation.stock;
                  break;
                }
              }
              double priceWithDiscount = PriceConverter.convertWithDiscount(context, price, productProvider.product.discount, productProvider.product.discountType);
              priceWithQuantity = priceWithDiscount * (productProvider.cartIndex != null ? cart.cartList[productProvider.cartIndex].quantity : productProvider.quantity);

              _cartModel = CartModel(
                productProvider.product.id, productProvider.product.image[0], productProvider.product.name, price,
                PriceConverter.convertWithDiscount(context, price, productProvider.product.discount, productProvider.product.discountType),
                productProvider.quantity, _variation,
                (price-PriceConverter.convertWithDiscount(context, price, productProvider.product.discount, productProvider.product.discountType)),
                (price-PriceConverter.convertWithDiscount(context, price, productProvider.product.tax, productProvider.product.taxType)), productProvider.product.capacity, productProvider.product.unit, _stock,productProvider.product
              );
              productProvider.setExistData(Provider.of<CartProvider>(context).isExistInCart(_cartModel));
            }

            return productProvider.product != null ?
            !ResponsiveHelper.isDesktop(context)
                ? Column(
              children: [
                Expanded(
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      physics: ResponsiveHelper.isMobilePhone()? BouncingScrollPhysics():null,
                      child: Center(
                        child: SizedBox(
                          width: 1170,
                          child: Column(

                            children: [

                              ProductImageView(productModel: productProvider.product),

                              ProductTitleView(product: productProvider.product, stock: _stock, cartIndex: productProvider.cartIndex),

                              VariationView(product: productProvider.product),

                              Padding(
                                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                child: Row(children: [
                                  Text('${getTranslated('total_amount', context)}:', style: poppinsMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  Text(PriceConverter.convertPrice(context, priceWithQuantity), style: poppinsBold.copyWith(
                                    color: Theme.of(context).primaryColor, fontSize: Dimensions.FONT_SIZE_LARGE,
                                  )),
                                ]),
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                              //Description
                              (productProvider.product.description != null && productProvider.product.description.isNotEmpty ) ? Container(
                                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                color: Theme.of(context).cardColor,
                                child: Column(children: [
                                  Builder(builder: (context) =>
                                      TitleRow(title: getTranslated('description', context), isDetailsPage: true,
                                          onTap: () {
                                            List<int> _encoded = utf8.encode(productProvider.product.description);
                                            String _data = base64Encode(_encoded);
                                            _data = _data.replaceAll('+', '-');
                                            Navigator.of(context).pushNamed(
                                              RouteHelper.getProductDescriptionRoute(_data),
                                              arguments: DescriptionScreen(description: productProvider.product.description),
                                            );

                                          }),
                                  ),
                                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  ProductDescription(
                                    productDescription: productProvider.product.description,
                                    id: productProvider.product.id.toString(),
                                  )
                                ]),
                              ) : SizedBox.shrink(),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Builder(
                  builder: (context) => Center(
                    child: Container(
                      width: 1170,
                      child: CustomButton(
                        margin: Dimensions.PADDING_SIZE_SMALL,
                        buttonText: getTranslated(productProvider.cartIndex != null ? 'already_added' : _stock <= 0 ? 'out_of_stock' : 'add_to_card', context),
                        onPressed: (productProvider.cartIndex == null && _stock > 0) ? () {
                          if (productProvider.cartIndex == null && _stock > 0) {
                            Provider.of<CartProvider>(context, listen: false).addToCart(_cartModel);
                            _key.currentState.shake();


                            showCustomSnackBar(getTranslated('added_to_cart', context),context, isError: false);

                          } else {
                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('already_added', context)), backgroundColor: Colors.red,));
                            showCustomSnackBar(getTranslated('already_added', context), context);
                          }
                        } : null,
                      ),
                    ),
                  ),
                ),

              ],
            )
                : SingleChildScrollView(
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.height - 400 : MediaQuery.of(context).size.height),
                    child: Column(children: [
                      const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      Center(
                        child: SizedBox(
                          width: 1170,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Expanded(flex: 5, child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: 350,
                                  child: Consumer<CartProvider>(
                                      builder: (context, cartProvider, child) {
                                        return FadeInImage.assetNetwork(
                                          placeholder: Images.placeholder(context),
                                          fit: BoxFit.cover,
                                          image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${productProvider.product.image[cartProvider.productSelect]}',
                                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder(context), fit: BoxFit.cover),
                                        );
                                      }
                                  ),
                                ),
                                const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                Container(height: 100,
                                  child: productProvider.product.image != null ? ListView.builder(
                                      itemCount: productProvider.product.image.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context,index){
                                        return Padding(
                                          padding: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                                          child: InkWell(
                                            onTap: (){
                                              Provider.of<CartProvider>(context, listen: false).setSelect(index, true);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(Provider.of<CartProvider>(context, listen: false).productSelect == index ? 3 : 0),
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Provider.of<CartProvider>(context, listen: false).productSelect == index ? Theme.of(context).primaryColor : ColorResources.getGreyColor(context),width: 1)
                                              ),
                                              child: FadeInImage.assetNetwork(
                                                placeholder: Images.placeholder(context),
                                                image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${productProvider.product.image[index]}',
                                                width: 100,
                                                fit: BoxFit.cover,
                                                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder(context), width: 100,fit: BoxFit.cover),
                                              ),
                                            ),
                                          ),
                                        );
                                      }) : SizedBox(),)
                              ],
                            ),),
                            const SizedBox(width: 30),
                            Expanded(flex: 6,child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  productProvider.product != null ? WebProductInformation(product: productProvider.product, stock: _stock, cartIndex: productProvider.cartIndex,priceWithQuantity: priceWithQuantity) : CircularProgressIndicator(),
                                  const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                                  Builder(
                                    builder: (context) => Center(
                                      child: Container(
                                        width: 1170,
                                        child: CustomButton(
                                          buttonText: getTranslated(productProvider.cartIndex != null ? 'already_added' : _stock <= 0 ? 'out_of_stock' : 'add_to_card', context),
                                          onPressed: (productProvider.cartIndex == null && _stock > 0) ? () {
                                            if (productProvider.cartIndex == null && _stock > 0) {
                                              Provider.of<CartProvider>(context, listen: false).addToCart(_cartModel);

                                              showCustomSnackBar(getTranslated('added_to_cart', context),context, isError: false);

                                            } else {
                                              showCustomSnackBar(getTranslated('already_added', context), context);
                                            }
                                          } : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                          ],),
                        ),
                      ),
                      //Description
                      SizedBox(
                        width: 1170,
                        child: (productProvider.product.description != null && productProvider.product.description.isNotEmpty ) ? Container(
                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          child: Column(children: [
                            Builder(builder: (context) =>
                                TitleRow(title: getTranslated('description', context), isDetailsPage: true),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            ProductDescription(
                              productDescription: productProvider.product.description,
                              id: productProvider.product.id.toString(),
                            )
                          ]),
                        ) : SizedBox.shrink(),
                      ),
                    ]),
                  ),

                  FooterView(),
                ],
              ),
            )

                : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
          },
        );
      }),
    );
  }
}