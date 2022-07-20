import 'package:flutter/material.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/category_provider.dart';
import 'package:flutter_grocery/provider/localization_provider.dart';
import 'package:flutter_grocery/view/screens/home/widget/category_view.dart';
import 'package:provider/provider.dart';

import 'array_button.dart';
import 'category_page_view.dart';
class CategoriesWebView extends StatefulWidget {
  const CategoriesWebView({Key key}) : super(key: key);

  @override
  _CategoriesWebViewState createState() => _CategoriesWebViewState();
}

class _CategoriesWebViewState extends State<CategoriesWebView> {
  final PageController pageController = PageController();

  void _nextPage() {
    pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.easeInOut);
  }
  void _previousPage() {
    pageController.previousPage(duration: Duration(seconds: 1), curve: Curves.easeInOut);
  }
  @override
  Widget build(BuildContext context) {

    return Consumer<CategoryProvider>(builder: (context,category,child){

      return category.categoryList != null?
      Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 190,
                    child:  category.categoryList != null ? category.categoryList.length > 0 ?
                    CategoryPageView(categoryProvider: category, pageController: pageController)
                        : Center(child: Text(getTranslated('no_category_available', context))) : CategoryShimmer(),

                  ),
                ),
              ],
            ),
          ),
          if(category.categoryList != null) Positioned.fill(child: Align(child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: ArrayButton(isLeft: true, isLarge: true, onTop: _previousPage, isVisible: !category.pageFirstIndex),
          ), alignment: Provider.of<LocalizationProvider>(context).isLtr ? Alignment.centerLeft : Alignment.centerRight)),
          if(category.categoryList != null) Positioned.fill(child: Align(
              child: ArrayButton(isLeft: false, isLarge: true, onTop: _nextPage,
                  isVisible:  !category.pageLastIndex && (category.categoryList != null ? category.categoryList.length > 7 : false)),
              alignment: Provider.of<LocalizationProvider>(context).isLtr ? Alignment.centerRight : Alignment.centerLeft)),

        ],
      ): SizedBox();
    });
  }
}
