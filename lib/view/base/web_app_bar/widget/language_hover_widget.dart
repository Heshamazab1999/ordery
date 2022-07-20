import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/language_model.dart';
import 'package:flutter_grocery/provider/banner_provider.dart';
import 'package:flutter_grocery/provider/category_provider.dart';
import 'package:flutter_grocery/provider/language_provider.dart';
import 'package:flutter_grocery/provider/product_provider.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/view/base/text_hover.dart';
import 'package:provider/provider.dart';

import '../../../../../localization/language_constrants.dart';
import '../../../../../provider/localization_provider.dart';
import '../../../../../utill/color_resources.dart';
import '../../../../../utill/dimensions.dart';
import '../../custom_snackbar.dart';

class LanguageHoverWidget extends StatefulWidget {
  final List<LanguageModel> languageList;
  const LanguageHoverWidget({Key key, @required this.languageList}) : super(key: key);

  @override
  State<LanguageHoverWidget> createState() => _LanguageHoverWidgetState();
}

class _LanguageHoverWidgetState extends State<LanguageHoverWidget> {
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Container(
          color: Theme.of(context).cardColor,
          padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          child: Column(
              children: widget.languageList.map((language) => InkWell(
                onTap: () async {
                  if(languageProvider.languages.length > 0 && languageProvider.selectIndex != -1) {
                    Provider.of<LocalizationProvider>(context, listen: false).setLanguage(Locale(
                        language.languageCode, language.countryCode
                    ));
                    Provider.of<ProductProvider>(context, listen: false).getPopularProductList(
                      context, '1', true, AppConstants.languages[languageProvider.selectIndex].languageCode,
                    );
                    Provider.of<CategoryProvider>(context, listen: false).getCategoryList(
                      context,  AppConstants.languages[languageProvider.selectIndex].languageCode,true
                    );
                  }else {
                    showCustomSnackBar(getTranslated('select_a_language', context), context);
                  }

                  print("-------------------------->${AppConstants.languages[languageProvider.selectIndex].languageCode}-----------------");
                },
                child: TextHover(
                    builder: (isHover) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                        decoration: BoxDecoration(color: isHover ? ColorResources.getGreyColor(context) : Theme.of(context).cardColor, borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                  child: Image.asset(language.imageUrl, width: 25, height: 25),
                                ),
                                Text(language.languageName, overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(fontSize: Dimensions.FONT_SIZE_SMALL),),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                ),
              )).toList()
            // [
            //   Text(_categoryList[5].name),
            // ],
          ),
        );
      }
    );
  }
}
