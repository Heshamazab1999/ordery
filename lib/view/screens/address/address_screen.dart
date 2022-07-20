import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/address_model.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/provider/auth_provider.dart';
import 'package:flutter_grocery/provider/location_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/view/base/app_bar_base.dart';
import 'package:flutter_grocery/view/base/footer_view.dart';
import 'package:flutter_grocery/view/base/no_data_screen.dart';
import 'package:flutter_grocery/view/base/not_login_screen.dart';
import 'package:flutter_grocery/view/screens/address/widget/adress_widget.dart';
import 'package:flutter_grocery/view/base/web_app_bar/web_app_bar.dart';
import 'package:provider/provider.dart';
import 'add_new_address_screen.dart';


class AddressScreen extends StatefulWidget {

  final AddressModel addressModel;
  AddressScreen({this.addressModel});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool _isLoggedIn;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn) {
      Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isMobilePhone()? null: ResponsiveHelper.isDesktop(context)? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120)) : AppBarBase(),
        body: _isLoggedIn ? Consumer<LocationProvider>(
          builder: (context, locationProvider, child) {
            return RefreshIndicator(
              onRefresh: () async {
                await Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
              },
              backgroundColor: Theme.of(context).primaryColor,
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.height - 560 : MediaQuery.of(context).size.height),
                  child: Column( mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 1170,
                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          margin: EdgeInsets.only(top: ResponsiveHelper.isDesktop(context) ? 20 : 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Text(
                                getTranslated('saved_address', context),
                                style: poppinsRegular.copyWith(color: ColorResources.getTextColor(context)),
                              ),
                              InkWell(
                               // onTap:() =>  Navigator.pushNamed(context, RouteHelper.getAddAddressRoute('address', 'add', AddressModel())),
                                 onTap:() {Provider.of<LocationProvider>(context, listen: false).updateAddressStatusMessage(message: '');
                                  Navigator.of(context).pushNamed(RouteHelper.getAddAddressRoute('address', 'add', AddressModel()), arguments: AddNewAddressScreen());
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                  decoration: BoxDecoration(
                                    color: ResponsiveHelper.isDesktop(context)? Theme.of(context).primaryColor : Colors.transparent,
                                    borderRadius: BorderRadius.circular(5),

                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.add, color: ResponsiveHelper.isDesktop(context)? Colors.white : ColorResources.getTextColor(context)),
                                      Text(
                                        getTranslated('add_new', context),
                                        style: poppinsRegular.copyWith(color: ResponsiveHelper.isDesktop(context)? Colors.white : ColorResources.getTextColor(context)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      locationProvider.addressList != null ? locationProvider.addressList.length > 0 ?

                      Scrollbar(
                        child: Column(
                          children: [
                            Center(
                              child: SizedBox(
                                width: 1170,
                                child: ResponsiveHelper.isDesktop(context)
                                    ?  GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 5,
                                      mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? 13 : 5,
                                      childAspectRatio:ResponsiveHelper.isDesktop(context) ? 4.5 : ResponsiveHelper.isTab(context) ? 4 : 3.5,
                                      crossAxisCount: ResponsiveHelper.isDesktop(context) ? 2 : ResponsiveHelper.isTab(context) ? 2 : 1),
                                  itemCount: locationProvider.addressList.length,
                                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT,vertical: Dimensions.PADDING_SIZE_DEFAULT),
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int index) {
                                    return AddressWidget(
                                      addressModel: locationProvider.addressList[index],
                                      index: index,
                                    );
                                  },
                                )
                                    : ListView.builder(
                                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                  itemCount: locationProvider.addressList.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => AddressWidget(
                                    addressModel: locationProvider.addressList[index],
                                    index: index,
                                  ),
                                ),
                              ),
                            ),
                            locationProvider.addressList.length <= 4 ?  const SizedBox(height: 300) : SizedBox(),
                            ResponsiveHelper.isDesktop(context) ? FooterView() : SizedBox(),
                          ],
                        ),
                      )
                          : NoDataScreen()
                          : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                    ],
                  ),
                ),
              ),
            );
          },
        ) : NotLoggedInScreen(),
    );
  }
}