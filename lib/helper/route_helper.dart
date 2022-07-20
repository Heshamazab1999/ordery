import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/model/response/address_model.dart';
import 'package:flutter_grocery/data/model/response/category_model.dart';
import 'package:flutter_grocery/data/model/response/order_model.dart';
import 'package:flutter_grocery/data/model/response/product_model.dart';
import 'package:flutter_grocery/data/model/response/userinfo_model.dart';
import 'package:flutter_grocery/helper/html_type.dart';
import 'package:flutter_grocery/view/screens/address/add_new_address_screen.dart';
import 'package:flutter_grocery/view/screens/address/address_screen.dart';
import 'package:flutter_grocery/view/screens/address/select_location_screen.dart';
import 'package:flutter_grocery/view/screens/auth/create_account_screen.dart';
import 'package:flutter_grocery/view/screens/auth/login_screen.dart';
import 'package:flutter_grocery/view/screens/auth/maintainance_screen.dart';
import 'package:flutter_grocery/view/screens/auth/signup_screen.dart';
import 'package:flutter_grocery/view/screens/cart/cart_screen.dart';
import 'package:flutter_grocery/view/screens/category/all_category_screen.dart';
import 'package:flutter_grocery/view/screens/chat/chat_screen.dart';
import 'package:flutter_grocery/view/screens/checkout/checkout_screen.dart';
import 'package:flutter_grocery/view/screens/checkout/order_successful_screen.dart';
import 'package:flutter_grocery/view/screens/checkout/payment_screen.dart';
import 'package:flutter_grocery/view/screens/contact/contact_screen.dart';
import 'package:flutter_grocery/view/screens/coupon/coupon_screen.dart';
import 'package:flutter_grocery/view/screens/forgot_password/create_new_password_screen.dart';
import 'package:flutter_grocery/view/screens/forgot_password/forgot_password_screen.dart';
import 'package:flutter_grocery/view/screens/forgot_password/verification_screen.dart';
import 'package:flutter_grocery/view/screens/html/html_viewer_screen.dart';
import 'package:flutter_grocery/view/screens/menu/menu_screen.dart';
import 'package:flutter_grocery/view/screens/notification/notification_screen.dart';
import 'package:flutter_grocery/view/screens/onboarding/on_boarding_screen.dart';
import 'package:flutter_grocery/view/screens/order/my_order_screen.dart';
import 'package:flutter_grocery/view/screens/order/order_details_screen.dart';
import 'package:flutter_grocery/view/screens/order/track_order_screen.dart';
import 'package:flutter_grocery/view/screens/product/category_product_screen_new.dart';
import 'package:flutter_grocery/view/screens/product/daily_item_screen.dart';
import 'package:flutter_grocery/view/screens/product/image_zoom_screen.dart';
import 'package:flutter_grocery/view/screens/product/product_description_screen.dart';
import 'package:flutter_grocery/view/screens/product/product_details_screen.dart';
import 'package:flutter_grocery/view/screens/profile/profile_edit_screen.dart';
import 'package:flutter_grocery/view/screens/profile/profile_screen.dart';
import 'package:flutter_grocery/view/screens/search/search_result_screen.dart';
import 'package:flutter_grocery/view/screens/search/search_screen.dart';
import 'package:flutter_grocery/view/screens/settings/setting_screen.dart';
import 'package:flutter_grocery/view/screens/splash/splash_screen.dart';
import 'package:flutter_grocery/view/screens/update/update_screen.dart';

class RouteHelper {
  static final FluroRouter router = FluroRouter();

  static String splash = '/splash';
  static String orderDetails = '/order-details';
  static String onBoarding = '/on-boarding';
  static String menu = '/';
  static String login = '/login';
  static String forgetPassword = '/forget-password';
  static String signUp = '/sign-up';
  static String verification = '/verification';
  static String createAccount = '/create-account';
  static String resetPassword = '/reset-password';
  //static String addAddress = '/add-address';
  static String updateAddress = '/update-address';
  static String selectLocation = '/select-location/';
  static String orderSuccessful = '/order-successful/';
  static String payment = '/payment';
  static String checkout = '/checkout';
  static String notification = '/notification';
  static String trackOrder = '/track-order';
  // static String categoryProducts = '/category-products';
  static String categoryProductsNew = '/category-products-new';
  static String productDescription = '/product-description';
  static String productDetails = '/product-details';
  static String productImages = '/product-images';
  static String profile = '/profile';
  static String searchProduct = '/search-product';
  static String profileEdit = '/profile-edit';
  static String searchResult = '/search-result';
  static String cart = '/cart';
  static String categorys = '/categorys';
  static String profileMenus = '/menus';
  static String myOrder = '/my-order';
  static String address = '/address';
  static String coupon = '/coupon';
  // static String chat = '/chat';
  static const String CHAT_SCREEN = '/chat_screen';
  static String settings = '/settings';
  static const String TERMS_SCREEN = '/terms';
  static const String POLICY_SCREEN = '/privacy-policy';
  static const String ABOUT_US_SCREEN = '/about-us';
  static const String DAILY_ITEM = '/daily-item';
  static const String MAINTENANCE = '/maintenance';
  static const String CONTACT_SCREEN = '/contact';
  static const String UPDATE = '/update';
  static const String ADD_ADDRESS_SCREEN = '/add-address';

  static String getMainRoute() => menu;
  static String getLoginRoute() => login;
  static String getTermsRoute() => TERMS_SCREEN;
  static String getPolicyRoute() => POLICY_SCREEN;
  static String getAboutUsRoute() => ABOUT_US_SCREEN;
  static String getUpdateRoute() => UPDATE;
  static String getSelectLocationRoute() => selectLocation;

  static String getOrderDetailsRoute(int id) => '$orderDetails?id=$id';
  static String getVerifyRoute(String page, String email) => '$verification?page=$page&email=$email';
  static String getNewPassRoute(String email, String token) => '$resetPassword?email=$email&token=$token';
  //static String getAddAddressRoute(String page) => '$addAddress?page=$page';
  static String getAddAddressRoute(String page, String action, AddressModel addressModel) {
    String _data = base64Url.encode(utf8.encode(jsonEncode(addressModel.toJson())));
    return '$ADD_ADDRESS_SCREEN?page=$page&action=$action&address=$_data';
  }
  static String getUpdateAddressRoute(String address, String type, String lat, String long, String name, String num, int id, int user) {
    List<int> _encoded = utf8.encode(address);
    String _address = base64Encode(_encoded);
    _encoded = utf8.encode(name);
    String _name = base64Encode(_encoded);
    return '$updateAddress?address=$_address&type=$type&lat=$lat&long=$long&name=$_name&number=$num&id=$id&user=$user';
  }
  static String getPaymentRoute(String page, String id, int user) => '$payment?page=$page&id=$id&user=$user';
  static String getCheckoutRoute(double amount, double discount, String type, String code) => '$checkout?amount=$amount&discount=$discount&type=$type&code=$code';
  static String getOrderTrackingRoute(int id) => '$trackOrder?id=$id';
  // static String getCategoryProductsRoute(int id) => '$categoryProducts?id=$id';
  static String getCategoryProductsRouteNew({int id, String subcategoryName}) => '$categoryProductsNew?id=$id&subcategory=$subcategoryName';
  static String getProductDescriptionRoute(String description) => '$productDescription?description=$description';
  ///..........................
  static String getProductDetailsRoute({@required Product product}) {
    String _product = base64Encode(utf8.encode(jsonEncode(product.toJson())));
    String _product1 = Uri.encodeComponent(jsonEncode(product.toJson()));
    return '$productDetails?product=$_product1';
  }
  static String getProductImagesRoute(String name, String images) => '$productImages?name=$name&images=$images';
  static String getProfileEditRoute(String fname, String lname, String email, String phone, String images) {
    List<int> _encoded = utf8.encode(fname);
    String _fname = base64Encode(_encoded);
    _encoded = utf8.encode(lname);
    String _lname = base64Encode(_encoded);
    _encoded = utf8.encode(email);
    String _email = base64Encode(_encoded);
    _encoded = utf8.encode(phone);
    String _phone = base64Encode(_encoded);
    _encoded = utf8.encode(images);
    String _image = base64Encode(_encoded);
    return '$profileEdit?fname=$_fname&lname=$_lname&email=$_email&phone=$_phone&images=$_image';
  }
  static String getDailyItemRoute() => '$DAILY_ITEM';
  static String getMaintenanceRoute() => '$MAINTENANCE';
  static String getSearchResultRoute(String text) {
    List<int> _encoded = utf8.encode(text);
    String _data = base64Encode(_encoded);
    return '$searchResult?text=$_data';
  }
  static String getChatRoute({OrderModel orderModel}) {
    String _orderModel = base64Encode(utf8.encode(jsonEncode(orderModel)));
    return '$CHAT_SCREEN?order=$_orderModel';
  }
  static String getContactRoute() => CONTACT_SCREEN;


  static Handler _splashHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => SplashScreen());

  static Handler _orderDetailsHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    OrderDetailsScreen _orderDetailsScreen = ModalRoute.of(context).settings.arguments;
    return _orderDetailsScreen != null ? _orderDetailsScreen : OrderDetailsScreen(orderId: int.parse(params['id'][0]), orderModel: null);
  });

  static Handler _onBoardingHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => OnBoardingScreen());

  static Handler _menuHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => MenuScreen());

  static Handler _loginHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => LoginScreen());

  static Handler _forgetPassHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => ForgotPasswordScreen());

  static Handler _signUpHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => SignUpScreen());

  static Handler _verificationHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    VerificationScreen _verificationScreen = ModalRoute.of(context).settings.arguments;
    return _verificationScreen != null ? _verificationScreen : VerificationScreen(
      fromSignUp: params['page'][0] == 'sign-up', emailAddress: params['email'][0],
    );
  });

  static Handler _createAccountHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => CreateAccountScreen());

  static Handler _resetPassHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    CreateNewPasswordScreen _createPassScreen = ModalRoute.of(context).settings.arguments;
    return _createPassScreen != null ? _createPassScreen : CreateNewPasswordScreen(
      email: params['email'][0], resetToken: params['token'][0],
    );
  });

  static Handler _addAddressHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    AddNewAddressScreen _addNewAddressScreen = ModalRoute.of(context).settings.arguments;
    return _addNewAddressScreen != null ? _addNewAddressScreen : AddNewAddressScreen(
      fromCheckout: params['page'][0] == 'checkout', isEnableUpdate: false,
    );
  });

  static Handler _updateAddressHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    AddNewAddressScreen _addNewAddressScreen = ModalRoute.of(context).settings.arguments;
    List<int> _decode = base64Decode(params['address'][0].replaceAll(' ', '+'));
    String _address = utf8.decode(_decode);
    _decode = base64Decode(params['name'][0].replaceAll(' ', '+'));
    String _name = utf8.decode(_decode);
    return _addNewAddressScreen != null ? _addNewAddressScreen : AddNewAddressScreen(
      isEnableUpdate: true, fromCheckout: false, address: AddressModel(
        id: int.parse(params['id'][0]), userId: int.parse(params['user'][0]), address: _address, addressType: params['type'][0],
        latitude: params['lat'][0], longitude: params['long'][0], contactPersonName: _name, contactPersonNumber: params['number'][0],
      ),
    );
  });

  static Handler _selectLocationHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    SelectLocationScreen _locationScreen =  ModalRoute.of(context).settings.arguments;
    return _locationScreen != null ? _locationScreen : Center(child: Container(child: Text('Not Found')));
  });


/*  static Handler _orderSuccessfulHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    OrderSuccessfulScreen _orderSuccessfulScreen = ModalRoute.of(context).settings.arguments;
    return _orderSuccessfulScreen != null ? _orderSuccessfulScreen : OrderSuccessfulScreen(
      orderID: params['id'][0], addressID: int.parse(params['address'][0]), status: int.parse(params['status'][0]),
    );
  });*/
  static Handler _orderSuccessHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) {
        int _status = (params['status'][0] == 'success' || params['status'][0] == 'payment-success') ? 0
            : (params['status'][0] == 'fail' || params['status'][0] == 'payment-fail') ? 1 : 2;
        return OrderSuccessfulScreen(orderID: params['id'][0], status: _status);
      }
  );


  static Handler _paymentHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    PaymentScreen _paymentScreen = ModalRoute.of(context).settings.arguments;
    return _paymentScreen != null ? _paymentScreen : PaymentScreen(
      fromCheckout: params['id'][0] == 'checkout', orderModel: OrderModel(
        userId: int.parse(params['user'][0]), id: int.parse(params['id'][0]),
      ),
    );
  });

  static Handler _checkoutHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    CheckoutScreen _checkoutScreen = ModalRoute.of(context).settings.arguments;
    return _checkoutScreen != null ? _checkoutScreen : CheckoutScreen(
      orderType: params['type'][0], discount: double.parse(params['discount'][0]), amount: double.parse(params['amount'][0]),
      couponCode: params['code'][0],
    );
  });

  static Handler _notificationHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => NotificationScreen());

  static Handler _trackOrderHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    TrackOrderScreen _trackOrderScreen = ModalRoute.of(context).settings.arguments;
    return _trackOrderScreen != null ? _trackOrderScreen : TrackOrderScreen(orderID: params['id'][0]);
  });

  /*static Handler _categoryProductsHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    CategoryProductScreen _categoryProductScreen = ModalRoute.of(context).settings.arguments;
    return _categoryProductScreen != null ? _categoryProductScreen : CategoryProductScreen(categoryModel: CategoryModel(
      id: int.parse(params['id'][0]),
    ));
  });*/
  static Handler _categoryProductsHandlerNew = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    CategoryProductScreenNew _categoryProductScreen = ModalRoute.of(context).settings.arguments;
    return _categoryProductScreen != null ? _categoryProductScreen : CategoryProductScreenNew(categoryModel: CategoryModel(
      id: int.parse(params['id'][0]),
    ),subCategory: params['subcategory'][0],);
  });

  static Handler _productDescriptionHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    DescriptionScreen _descriptionScreen = ModalRoute.of(context).settings.arguments;
    List<int> _decode = base64Decode(params['description'][0].replaceAll('-', '+'));
    String _data = utf8.decode(_decode);
    return _descriptionScreen != null ? _descriptionScreen : DescriptionScreen(description: _data);
  });

  static Handler _productDetailsHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    Product p = Product.fromJson(jsonDecode(params['product'][0]));
    return ProductDetailsScreen(product: p);
  });

  ///...............
  static Handler _productImagesHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    ProductImageScreen _productImageScreen = ModalRoute.of(context).settings.arguments;
    return _productImageScreen != null ? _productImageScreen : ProductImageScreen(
      title: params['name'][0], imageList: jsonDecode(params['images'][0]),
    );
  });

  static Handler _profileHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => ProfileScreen());

  static Handler _searchProductHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => SearchScreen());
  ///.................
  static Handler _profileEditHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params)
  {
    ProfileEditScreen _profileEditScreen = ModalRoute.of(context).settings.arguments;
    List<int> _decode = base64Decode(params['fname'][0].replaceAll(' ', '+'));
    String _fname = utf8.decode(_decode);
    _decode = base64Decode(params['lname'][0].replaceAll(' ', '+'));
    String _lname = utf8.decode(_decode);
    _decode = base64Decode(params['email'][0].replaceAll(' ', '+'));
    String _email = utf8.decode(_decode);
    _decode = base64Decode(params['phone'][0].replaceAll(' ', '+'));
    String _phone = utf8.decode(_decode);
    _decode = base64Decode(params['images'][0].replaceAll(' ', '+'));
    String _image = utf8.decode(_decode);
   return _profileEditScreen != null? _profileEditScreen: ProfileEditScreen(
    userInfoModel: UserInfoModel(fName: _fname, lName: _lname, email: _email, phone: _phone,image: _image),
  );
  }
  );
  static Handler _searchResultHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    List<int> _decode = base64Decode(params['text'][0]);
    String _data = utf8.decode(_decode);
    return SearchResultScreen(searchString: _data);
  });
  static Handler _cartHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => CartScreen());
  static Handler _categorysHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => AllCategoryScreen());
  static Handler _profileMenusHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => MenuWidget());
  static Handler _myOrderHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => MyOrderScreen());
  static Handler _addressHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => AddressScreen());
  static Handler _couponHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => CouponScreen());
  static Handler _chatHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    final _orderModel = jsonDecode(utf8.decode(base64Url.decode(params['order'][0].replaceAll(' ', '+'))));
    return ChatScreen(orderModel : _orderModel != null ? OrderModel.fromJson(_orderModel) : null);
  });
  static Handler _settingsHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => SettingsScreen());
  static Handler _termsHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => HtmlViewerScreen(htmlType: HtmlType.TERMS_AND_CONDITION));

  static Handler _policyHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => HtmlViewerScreen(htmlType: HtmlType.PRIVACY_POLICY));

  static Handler _aboutUsHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => HtmlViewerScreen(htmlType: HtmlType.ABOUT_US));

  static Handler _dailyItemHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => DailyItemScreen());
  static Handler _maintenanceHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => MaintenanceScreen());
  static Handler _contactHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => ContactScreen());

  static Handler _updateHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => UpdateScreen());
  static Handler _newAddressHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    bool _isUpdate = params['action'][0] == 'update';
    print('this add is call ${_isUpdate}');
    AddressModel _addressModel;
    if(_isUpdate) {
      String _decoded = utf8.decode(base64Url.decode(params['address'][0].replaceAll(' ', '+')));
      _addressModel = AddressModel.fromJson(jsonDecode(_decoded));
    }
    return AddNewAddressScreen(fromCheckout: params['page'][0] == 'checkout', isEnableUpdate: _isUpdate, address: _isUpdate ? _addressModel : null);
  });

  //static Handler _routeHandler = Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => ModalRoute.of(context).settings.arguments);

  static void setupRouter(){
    router.define(splash, handler: _splashHandler, transitionType: TransitionType.fadeIn);
    router.define(orderDetails, handler: _orderDetailsHandler, transitionType: TransitionType.fadeIn);
    router.define(onBoarding, handler: _onBoardingHandler, transitionType: TransitionType.fadeIn);
    router.define(menu, handler: _menuHandler, transitionType: TransitionType.fadeIn);
    router.define(login, handler: _loginHandler, transitionType: TransitionType.fadeIn);
    router.define(forgetPassword, handler: _forgetPassHandler, transitionType: TransitionType.fadeIn);
    router.define(signUp, handler: _signUpHandler, transitionType: TransitionType.fadeIn);
    router.define(verification, handler: _verificationHandler, transitionType: TransitionType.fadeIn);
    router.define(createAccount, handler: _createAccountHandler, transitionType: TransitionType.fadeIn);
    router.define(resetPassword, handler: _resetPassHandler, transitionType: TransitionType.fadeIn);
    //router.define(addAddress, handler: _addAddressHandler, transitionType: TransitionType.fadeIn);
    router.define(updateAddress, handler: _updateAddressHandler, transitionType: TransitionType.fadeIn);
    router.define(selectLocation, handler: _selectLocationHandler, transitionType: TransitionType.fadeIn);
    router.define('$orderSuccessful:id/:status', handler: _orderSuccessHandler, transitionType: TransitionType.fadeIn);
    router.define(payment, handler: _paymentHandler, transitionType: TransitionType.fadeIn);
    router.define(checkout, handler: _checkoutHandler, transitionType: TransitionType.fadeIn);
    router.define(notification, handler: _notificationHandler, transitionType: TransitionType.fadeIn);
    router.define(trackOrder, handler: _trackOrderHandler, transitionType: TransitionType.fadeIn);
    // router.define(categoryProducts, handler: _categoryProductsHandler, transitionType: TransitionType.fadeIn);
    router.define(categoryProductsNew, handler: _categoryProductsHandlerNew, transitionType: TransitionType.fadeIn);
    router.define(productDescription, handler: _productDescriptionHandler, transitionType: TransitionType.fadeIn);
    router.define(productDetails, handler: _productDetailsHandler, transitionType: TransitionType.fadeIn);
    router.define(productImages, handler: _productImagesHandler, transitionType: TransitionType.fadeIn);
    router.define(profile, handler: _profileHandler, transitionType: TransitionType.fadeIn);
    router.define(searchProduct, handler: _searchProductHandler, transitionType: TransitionType.fadeIn);
    router.define(profileEdit, handler: _profileEditHandler, transitionType: TransitionType.fadeIn);
    router.define(searchResult, handler: _searchResultHandler, transitionType: TransitionType.fadeIn);
    router.define(cart, handler: _cartHandler, transitionType: TransitionType.fadeIn);
    router.define(categorys, handler: _categorysHandler, transitionType: TransitionType.fadeIn);
    router.define(profileMenus, handler: _profileMenusHandler, transitionType: TransitionType.fadeIn);
    router.define(myOrder, handler: _myOrderHandler, transitionType: TransitionType.fadeIn);
    router.define(address, handler: _addressHandler, transitionType: TransitionType.fadeIn);
    router.define(coupon, handler: _couponHandler, transitionType: TransitionType.fadeIn);
    router.define(CHAT_SCREEN, handler: _chatHandler, transitionType: TransitionType.fadeIn);
    router.define(settings, handler: _settingsHandler, transitionType: TransitionType.fadeIn);
    router.define(TERMS_SCREEN, handler: _termsHandler, transitionType: TransitionType.fadeIn);
    router.define(POLICY_SCREEN, handler: _policyHandler, transitionType: TransitionType.fadeIn);
    router.define(ABOUT_US_SCREEN, handler: _aboutUsHandler, transitionType: TransitionType.fadeIn);
    router.define(DAILY_ITEM, handler: _dailyItemHandler, transitionType: TransitionType.fadeIn);
    router.define(MAINTENANCE, handler: _maintenanceHandler, transitionType: TransitionType.fadeIn);
    router.define(CONTACT_SCREEN, handler: _contactHandler, transitionType: TransitionType.fadeIn);
    router.define(UPDATE, handler: _updateHandler, transitionType: TransitionType.fadeIn);
    router.define(ADD_ADDRESS_SCREEN, handler: _newAddressHandler, transitionType: TransitionType.fadeIn);
  }
}