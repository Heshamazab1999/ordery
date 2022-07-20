class ConfigModel {
  String _ecommerceName;
  String _ecommerceLogo;
  String _ecommerceAddress;
  String _ecommercePhone;
  String _ecommerceEmail;
  EcommerceLocationCoverage _ecommerceLocationCoverage;
  double _minimumOrderValue;
  int _selfPickup;
  BaseUrls _baseUrls;
  String _currencySymbol;
  double _deliveryCharge;
  String _cashOnDelivery;
  String _digitalPayment;
  List<Branches> _branches;
  String _termsAndConditions;
  String _privacyPolicy;
  String _aboutUs;
  bool _emailVerification;
  bool _phoneVerification;
  String _currencySymbolPosition;
  bool _maintenanceMode;
  String _country;
  DeliveryManagement _deliveryManagement;
  PlayStoreConfig _playStoreConfig;
  AppStoreConfig _appStoreConfig;
  List<SocialMediaLink> _socialMediaLink;
  String _footerCopyright;

  ConfigModel(
      {String ecommerceName,
        String ecommerceLogo,
        String ecommerceAddress,
        String ecommercePhone,
        String ecommerceEmail,
        EcommerceLocationCoverage ecommerceLocationCoverage,
        double minimumOrderValue,
        int selfPickup,
        BaseUrls baseUrls,
        String currencySymbol,
        double deliveryCharge,
        String cashOnDelivery,
        String digitalPayment,
        List<Branches> branches,
        String termsAndConditions,
        bool emailVerification,
        bool phoneVerification,
        String currencySymbolPosition,
        bool maintenanceMode,
        String country,
        DeliveryManagement deliveryManagement,
        PlayStoreConfig playStoreConfig,
        AppStoreConfig appStoreConfig,
        List<SocialMediaLink> socialMediaLink,
        String footerCopyright,
      }) {
    this._ecommerceName = ecommerceName;
    this._ecommerceLogo = ecommerceLogo;
    this._ecommerceAddress = ecommerceAddress;
    this._ecommercePhone = ecommercePhone;
    this._ecommerceEmail = ecommerceEmail;
    this._ecommerceLocationCoverage = ecommerceLocationCoverage;
    this._minimumOrderValue = minimumOrderValue;
    this._selfPickup = selfPickup;
    this._baseUrls = baseUrls;
    this._currencySymbol = currencySymbol;
    this._deliveryCharge = deliveryCharge;
    this._cashOnDelivery = cashOnDelivery;
    this._digitalPayment = digitalPayment;
    this._branches = branches;
    this._termsAndConditions = termsAndConditions;
    this._aboutUs = aboutUs;
    this._privacyPolicy = privacyPolicy;
    this._emailVerification = emailVerification;
    this._phoneVerification = phoneVerification;
    this._currencySymbolPosition = currencySymbolPosition;
    this._maintenanceMode = maintenanceMode;
    this._country = country;
    this._deliveryManagement = deliveryManagement;
    this._playStoreConfig = playStoreConfig;
    this._appStoreConfig = appStoreConfig;
    this._socialMediaLink = socialMediaLink;
    this._footerCopyright = footerCopyright;
  }

  String get ecommerceName => _ecommerceName;
  String get ecommerceLogo => _ecommerceLogo;
  String get ecommerceAddress => _ecommerceAddress;
  String get ecommercePhone => _ecommercePhone;
  String get ecommerceEmail => _ecommerceEmail;
  EcommerceLocationCoverage get ecommerceLocationCoverage => _ecommerceLocationCoverage;
  double get minimumOrderValue => _minimumOrderValue;
  int get selfPickup => _selfPickup;
  BaseUrls get baseUrls => _baseUrls;
  String get currencySymbol => _currencySymbol;
  double get deliveryCharge => _deliveryCharge;
  String get cashOnDelivery => _cashOnDelivery;
  String get digitalPayment => _digitalPayment;
  List<Branches> get branches => _branches;
  String get termsAndConditions => _termsAndConditions;
  String get aboutUs=> _aboutUs;
  String get privacyPolicy=> _privacyPolicy;
  bool get emailVerification => _emailVerification;
  bool get phoneVerification => _phoneVerification;
  String get currencySymbolPosition => _currencySymbolPosition;
  bool get maintenanceMode => _maintenanceMode;
  String get country => _country;
  DeliveryManagement get deliveryManagement => _deliveryManagement;
  PlayStoreConfig get playStoreConfig => _playStoreConfig;
  AppStoreConfig get appStoreConfig => _appStoreConfig;
  List<SocialMediaLink> get socialMediaLink => _socialMediaLink;
  String get footerCopyright => _footerCopyright;

  ConfigModel.fromJson(Map<String, dynamic> json) {
    _ecommerceName = json['ecommerce_name'];
    _ecommerceLogo = json['ecommerce_logo'];
    _ecommerceAddress = json['ecommerce_address'];
    _ecommercePhone = json['ecommerce_phone'];
    _ecommerceEmail = json['ecommerce_email'];
    _ecommerceLocationCoverage = json['ecommerce_location_coverage'] != null
        ? new EcommerceLocationCoverage.fromJson(
        json['ecommerce_location_coverage'])
        : null;
    _minimumOrderValue = json['minimum_order_value'].toDouble();
    _selfPickup = json['self_pickup'];
    _baseUrls = json['base_urls'] != null
        ? new BaseUrls.fromJson(json['base_urls'])
        : null;
    _currencySymbol = json['currency_symbol'];
    _deliveryCharge = json['delivery_charge'].toDouble();
    _cashOnDelivery = json['cash_on_delivery'];
    _digitalPayment = json['digital_payment'];
    if (json['branches'] != null) {
      _branches = [];
      json['branches'].forEach((v) {
        _branches.add(new Branches.fromJson(v));
      });
    }
    _termsAndConditions = json['terms_and_conditions'];
    _privacyPolicy = json['privacy_policy'];
    _aboutUs = json['about_us'];
    _emailVerification = json['email_verification'];
    _phoneVerification = json['phone_verification'];
    _currencySymbolPosition = json['currency_symbol_position'];
    _maintenanceMode = json['maintenance_mode'];
    _country = json['country'];
    _deliveryManagement = json['delivery_management'] != null
        ? new DeliveryManagement.fromJson(json['delivery_management'])
        : null;
    _playStoreConfig = json['play_store_config'] != null
        ? new PlayStoreConfig.fromJson(json['play_store_config'])
        : null;
    _appStoreConfig = json['app_store_config'] != null
        ? new AppStoreConfig.fromJson(json['app_store_config'])
        : null;
    if (json['social_media_link'] != null) {
      _socialMediaLink = [];
      json['social_media_link'].forEach((v) {
        _socialMediaLink.add(new SocialMediaLink.fromJson(v));
      });
    }
    if(json['footer_text']!=null){
      _footerCopyright = json['footer_text'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ecommerce_name'] = this._ecommerceName;
    data['ecommerce_logo'] = this._ecommerceLogo;
    data['ecommerce_address'] = this._ecommerceAddress;
    data['ecommerce_phone'] = this._ecommercePhone;
    data['ecommerce_email'] = this._ecommerceEmail;
    if (this._ecommerceLocationCoverage != null) {
      data['ecommerce_location_coverage'] =
          this._ecommerceLocationCoverage.toJson();
    }
    data['minimum_order_value'] = this._minimumOrderValue;
    data['self_pickup'] = this._selfPickup;
    if (this._baseUrls != null) {
      data['base_urls'] = this._baseUrls.toJson();
    }
    data['currency_symbol'] = this._currencySymbol;
    data['delivery_charge'] = this._deliveryCharge;
    data['cash_on_delivery'] = this._cashOnDelivery;
    data['digital_payment'] = this._digitalPayment;
    if (this._branches != null) {
      data['branches'] = this._branches.map((v) => v.toJson()).toList();
    }
    data['terms_and_conditions'] = this._termsAndConditions;
    data['privacy_policy'] = this._privacyPolicy;
    data['about_us'] = this._aboutUs;
    data['email_verification'] = this._emailVerification;
    data['phone_verification'] = this._phoneVerification;
    data['currency_symbol_position'] = this._currencySymbolPosition;
    data['maintenance_mode'] = this._maintenanceMode;
    data['country'] = this._country;
    if (this._deliveryManagement != null) {
      data['delivery_management'] = this._deliveryManagement.toJson();
    }
    if (this._playStoreConfig != null) {
      data['play_store_config'] = this._playStoreConfig.toJson();
    }
    if (this._appStoreConfig != null) {
      data['play_store_config'] = this._appStoreConfig.toJson();
    }
    data['footer_text'] = this._footerCopyright;
    return data;
  }
}

class EcommerceLocationCoverage {
  String _longitude;
  String _latitude;
  double _coverage;

  EcommerceLocationCoverage({String longitude, String latitude, double coverage}) {
    this._longitude = longitude;
    this._latitude = latitude;
    this._coverage = coverage;
  }

  String get longitude => _longitude;
  String get latitude => _latitude;
  double get coverage => _coverage;

  EcommerceLocationCoverage.fromJson(Map<String, dynamic> json) {
    _longitude = json['longitude'];
    _latitude = json['latitude'];
    _coverage = json['coverage'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['longitude'] = this._longitude;
    data['latitude'] = this._latitude;
    data['coverage'] = this._coverage;
    return data;
  }
}

class PlayStoreConfig{
  bool _status;
  String _link;
  double _minVersion;

  PlayStoreConfig({bool status, String link, double minVersion}){
    this._status = status;
    this._link = link;
    this._minVersion = minVersion;
  }
  bool get status => _status;
  String get link => _link;
  double get minVersion =>_minVersion;

  PlayStoreConfig.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    if(json['link']!=null){
      _link = json['link'];
    }
    if(json['min_version']!=null && json['min_version']!='' ){
      _minVersion = double.parse(json['min_version'].toString());
    }else{
      _minVersion = 0;
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    data['link'] = this._link;
    data['min_version'] = this._minVersion;

    return data;
  }
}

class AppStoreConfig{
  bool _status;
  String _link;
  double _minVersion;

  AppStoreConfig({bool status, String link, double minVersion}){
    this._status = status;
    this._link = link;
    this._minVersion = minVersion;
  }

  bool get status => _status;
  String get link => _link;
  double get minVersion =>_minVersion;


  AppStoreConfig.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    if(json['link']!=null){
      _link = json['link'];
    }
    if(json['min_version'] !=null  && json['min_version']!=''){
      _minVersion = double.parse(json['min_version'].toString());
    }else{
      _minVersion = 0;
    }

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    data['link'] = this._link;
    data['min_version'] = this._minVersion;

    return data;
  }
}

class BaseUrls {
  String _productImageUrl;
  String _customerImageUrl;
  String _bannerImageUrl;
  String _categoryImageUrl;
  String _reviewImageUrl;
  String _notificationImageUrl;
  String _ecommerceImageUrl;
  String _deliveryManImageUrl;
  String _chatImageUrl;
  String _categoryBanner;

  BaseUrls(
      {String productImageUrl,
        String customerImageUrl,
        String bannerImageUrl,
        String categoryImageUrl,
        String reviewImageUrl,
        String notificationImageUrl,
        String ecommerceImageUrl,
        String deliveryManImageUrl,
        String chatImageUrl,
        String categoryBanner,
      }) {
    this._productImageUrl = productImageUrl;
    this._customerImageUrl = customerImageUrl;
    this._bannerImageUrl = bannerImageUrl;
    this._categoryImageUrl = categoryImageUrl;
    this._reviewImageUrl = reviewImageUrl;
    this._notificationImageUrl = notificationImageUrl;
    this._ecommerceImageUrl = ecommerceImageUrl;
    this._deliveryManImageUrl = deliveryManImageUrl;
    this._chatImageUrl = chatImageUrl;
    this._categoryBanner = categoryBanner;
  }

  String get productImageUrl => _productImageUrl;
  String get customerImageUrl => _customerImageUrl;
  String get bannerImageUrl => _bannerImageUrl;
  String get categoryImageUrl => _categoryImageUrl;
  String get reviewImageUrl => _reviewImageUrl;
  String get notificationImageUrl => _notificationImageUrl;
  String get ecommerceImageUrl => _ecommerceImageUrl;
  String get deliveryManImageUrl => _deliveryManImageUrl;
  String get chatImageUrl => _chatImageUrl;
  String get categoryBanner => _categoryBanner;

  BaseUrls.fromJson(Map<String, dynamic> json) {
    _productImageUrl = json['product_image_url'];
    _customerImageUrl = json['customer_image_url'];
    _bannerImageUrl = json['banner_image_url'];
    _categoryImageUrl = json['category_image_url'];
    _reviewImageUrl = json['review_image_url'];
    _notificationImageUrl = json['notification_image_url'];
    _ecommerceImageUrl = json['ecommerce_image_url'];
    _deliveryManImageUrl = json['delivery_man_image_url'];
    _chatImageUrl = json['chat_image_url'];
    _categoryBanner = json['category_banner_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_image_url'] = this._productImageUrl;
    data['customer_image_url'] = this._customerImageUrl;
    data['banner_image_url'] = this._bannerImageUrl;
    data['category_image_url'] = this._categoryImageUrl;
    data['review_image_url'] = this._reviewImageUrl;
    data['notification_image_url'] = this._notificationImageUrl;
    data['ecommerce_image_url'] = this._ecommerceImageUrl;
    data['delivery_man_image_url'] = this._deliveryManImageUrl;
    data['chat_image_url'] = this._chatImageUrl;
    data['category_banner_image_url'] = this._categoryBanner;
    return data;
  }
}
class SocialMediaLink{
  int _id;
  String _name;
  String _link;
  int _status;
  String _createdAt;
  String _updatedAt;

  SocialMediaLink({int id, String name, String link, int status, String createdAt, String updatedAt}){
    this._id = id;
    this._name = name;
    this._link = link;
    this._status = status;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
  }
  int get id => _id;
  String get name => _name;
  String get link => _link;
  int get status => _status;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  SocialMediaLink.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _link = json['link'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['link'] = this._link;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }

}

class Branches {
  int _id;
  String _name;
  String _email;
  String _longitude;
  String _latitude;
  String _address;
  double _coverage;

  Branches(
      {int id,
        String name,
        String email,
        String longitude,
        String latitude,
        String address,
        double coverage}) {
    this._id = id;
    this._name = name;
    this._email = email;
    this._longitude = longitude;
    this._latitude = latitude;
    this._address = address;
    this._coverage = coverage;
  }

  int get id => _id;
  String get name => _name;
  String get email => _email;
  String get longitude => _longitude;
  String get latitude => _latitude;
  String get address => _address;
  double get coverage => _coverage;

  Branches.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _longitude = json['longitude'];
    _latitude = json['latitude'];
    _address = json['address'];
    _coverage = json['coverage'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['email'] = this._email;
    data['longitude'] = this._longitude;
    data['latitude'] = this._latitude;
    data['address'] = this._address;
    data['coverage'] = this._coverage;
    return data;
  }
}

class DeliveryManagement {
  int _status;
  double _minShippingCharge;
  double _shippingPerKm;

  DeliveryManagement(
      {int status, double minShippingCharge, double shippingPerKm}) {
    this._status = status;
    this._minShippingCharge = minShippingCharge;
    this._shippingPerKm = shippingPerKm;
  }

  int get status => _status;
  double get minShippingCharge => _minShippingCharge;
  double get shippingPerKm => _shippingPerKm;

  DeliveryManagement.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _minShippingCharge = json['min_shipping_charge'].toDouble();
    _shippingPerKm = json['shipping_per_km'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    data['min_shipping_charge'] = this._minShippingCharge;
    data['shipping_per_km'] = this._shippingPerKm;
    return data;
  }
}
