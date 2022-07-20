import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/product_type.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/banner_provider.dart';
import 'package:flutter_grocery/provider/category_provider.dart';
import 'package:flutter_grocery/provider/localization_provider.dart';
import 'package:flutter_grocery/provider/product_provider.dart';
import 'package:flutter_grocery/view/base/title_widget.dart';
import 'package:flutter_grocery/view/base/footer_view.dart';
import 'package:flutter_grocery/view/base/web_app_bar/web_app_bar.dart';
import 'package:flutter_grocery/view/screens/home/widget/banners_view.dart';
import 'package:flutter_grocery/view/screens/home/widget/category_view.dart';
import 'package:flutter_grocery/view/screens/home/widget/daily_item_view.dart';
import 'package:flutter_grocery/view/screens/home/widget/product_view.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<void> _loadData(BuildContext context, bool reload) async {
     Provider.of<CategoryProvider>(context, listen: false).getCategoryList(
      context, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,reload,
    );
     Provider.of<BannerProvider>(context, listen: false).getBannerList(context, reload);
    await Provider.of<ProductProvider>(context, listen: false).getDailyItemList(context, reload,
      Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,);

     Provider.of<ProductProvider>(context, listen: false).getPopularProductList(
       context,'1', true, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode);

  }

  @override
  void initState() {
    _loadData(context, false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    return RefreshIndicator(
      onRefresh: () async {
        Provider.of<ProductProvider>(context, listen: false).offset = 1;
        await _loadData(context, true);
      },
      backgroundColor: Theme.of(context).primaryColor,
      child: Scaffold(
        appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120))  : null,
        body: Scrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                Center(
                  child: SizedBox(width: 1170,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.height - 400 : MediaQuery.of(context).size.height),
                      child: Column(
                          children: [

                        Consumer<BannerProvider>(builder: (context, banner, child) {
                          return banner.bannerList == null ? BannersView() : banner.bannerList.length == 0 ? SizedBox() : BannersView();
                        }),

                        // Category
                        Consumer<CategoryProvider>(builder: (context, category, child) {
                          return category.categoryList == null ? CategoryView() : category.categoryList.length == 0 ? SizedBox() : CategoryView();
                        }),

                       // Category
                        Consumer<ProductProvider>(builder: (context, product, child) {
                          return product.dailyItemList == null ? DailyItemView() : product.dailyItemList.length == 0 ? SizedBox() : DailyItemView();
                        }),

                        // Popular Item\

                        ResponsiveHelper.isMobilePhone()? SizedBox(height: 10,) : SizedBox.shrink(),
                        TitleWidget(title: getTranslated('popular_item', context)),
                        ProductView(productType: ProductType.POPULAR_PRODUCT, scrollController: _scrollController),


                      ]),
                    ),
                  ),
                ),
                ResponsiveHelper.isDesktop(context) ? FooterView() : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
