import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/category_model.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/view/base/text_hover.dart';

class CategoryHoverWidget extends StatelessWidget {
  final List<CategoryModel> categoryList;
  const CategoryHoverWidget({Key key, @required this.categoryList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      child: Column(
          children: categoryList.map((category) => InkWell(
            onTap: () async {
              Future.delayed(Duration(milliseconds: 100)).then((value) async{

                await Navigator.of(context).pushNamed(
                  RouteHelper.getCategoryProductsRouteNew(id: category.id),
                );
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(
                  RouteHelper.getCategoryProductsRouteNew(id: category.id),
                );
              });
            },
            child: TextHover(
                builder: (isHover) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                    decoration: BoxDecoration(color: isHover ? ColorResources.getGreyColor(context) : Theme.of(context).cardColor, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(width: 200,child: Text(category.name, overflow: TextOverflow.ellipsis,maxLines: 1,)),
                        Icon(Icons.chevron_right, size: Dimensions.PADDING_SIZE_DEFAULT),
                      ],
                    ),
                  );
                }
            ),
          )).toList()
      ),
    );
  }
}
