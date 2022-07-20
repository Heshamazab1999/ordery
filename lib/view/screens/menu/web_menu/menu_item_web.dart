import 'package:flutter/material.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';

class MenuItemWeb extends StatelessWidget {
  final String image;
  final String title;
  final Function onTap;
  const MenuItemWeb({Key key, @required this.image, @required this.title, @required this.onTap}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(32.0),
      onTap: onTap,
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.04), borderRadius: BorderRadius.circular(32.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, width: 50, height: 50, color: Theme.of(context).textTheme.bodyText1.color),
            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
            Text(title, style: poppinsRegular),
          ],
        ),
      ),
    );
  }
}
