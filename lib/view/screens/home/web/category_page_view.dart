import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/provider/category_provider.dart';
import 'package:flutter_grocery/provider/localization_provider.dart';
import 'package:flutter_grocery/provider/theme_provider.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/on_hover.dart';
import 'package:flutter_grocery/view/base/text_hover.dart';
import 'package:provider/provider.dart';

import '../../../../../provider/splash_provider.dart';
import '../../../../../utill/color_resources.dart';
import '../../../../../utill/dimensions.dart';
import '../../../../../utill/images.dart';

class CategoryPageView extends StatelessWidget {
  final CategoryProvider categoryProvider;
  final PageController pageController;
  const CategoryPageView({Key key, @required this.categoryProvider, @required this.pageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int _totalPage = (categoryProvider.categoryList.length / 7).ceil();

    return Container(
      child: PageView.builder(
        controller: pageController,
        itemCount: _totalPage,
        onPageChanged: (index) {
          categoryProvider.updateProductCurrentIndex(index, _totalPage);
        },
        itemBuilder: (context, index) {
          int _initialLength = 7;
          int currentIndex = 7 * index;

          (index + 1 == _totalPage) ? _initialLength = categoryProvider.categoryList.length - (index * 7)  : 7;
          return Align(
            alignment: _initialLength < 7 ? Provider.of<LocalizationProvider>(context).isLtr ? Alignment.centerLeft : Alignment.centerRight  : Alignment.center,
            child: ListView.builder(
                itemCount: _initialLength, scrollDirection: Axis.horizontal, physics: NeverScrollableScrollPhysics(), shrinkWrap: true,
                itemBuilder: (context, item) {
                  int _currentIndex = item  + currentIndex;
                  String _name = '';
                  categoryProvider.categoryList[_currentIndex].name.length > 20 ? _name = categoryProvider.categoryList[_currentIndex].name.substring(0, 20)+' ...' : _name = categoryProvider.categoryList[_currentIndex].name;
                  return Container(
                            margin: EdgeInsets.only(top: 20,left: 20,right: 15),
                            child: InkWell(
                              hoverColor: Colors.transparent,
                              onTap: (){
                                Navigator.of(context).pushNamed(
                                  RouteHelper.getCategoryProductsRouteNew(id: categoryProvider.categoryList[_currentIndex].id),
                                  // arguments: CategoryProductScreenNew(categoryModel: categoryProvider.categoryList[_currentIndex]),
                                );
                                },
                              child: TextHover(
                                builder: (hovered) {
                                  return Column(children: [
                                    OnHover(

                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(Provider.of<ThemeProvider>(context).darkTheme ? 0.05 : 1),
                                            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SIZE_LARGE),
                                            boxShadow:Provider.of<ThemeProvider>(context).darkTheme
                                                ? null
                                                : [
                                              BoxShadow(
                                                color:ColorResources.CARD_SHADOW_COLOR.withOpacity(0.3),
                                                blurRadius: 20,
                                              )
                                            ]
                                        ),
                                        padding: const EdgeInsets.all(3),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SIZE_LARGE),
                                          child: FadeInImage.assetNetwork(
                                            placeholder: Images.placeholder(context), width: 125, height: 125, fit: BoxFit.cover,
                                            image: Provider.of<SplashProvider>(context, listen: false).baseUrls != null
                                                ? '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}/${categoryProvider.categoryList[_currentIndex].image}':'',
                                            imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder(context), width: 125, height: 125, fit: BoxFit.cover),

                                          ),
                                        ),
                                      ),
                                    ),

                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: Dimensions.PADDING_SIZE_DEFAULT),
                                        child:  SizedBox(
                                          width: 120,
                                          child: Text(
                                            _name,
                                            style: poppinsMedium.copyWith(color: hovered ? Theme.of(context).primaryColor : ColorResources.getTextColor(context)),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),

                                  ]);
                                }
                              ),
                            ),
                          );
                }
            ),
          );
        },
      ),
    );
  }
}
