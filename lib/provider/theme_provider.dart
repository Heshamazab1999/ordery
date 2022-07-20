import 'package:flutter/foundation.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  final SharedPreferences sharedPreferences;
  ThemeProvider({@required this.sharedPreferences}) {
    _loadCurrentTheme();
  }

  bool _darkTheme = true;
  bool get darkTheme => _darkTheme;

  void toggleTheme() {
    _darkTheme = !_darkTheme;
    sharedPreferences.setBool(AppConstants.THEME, _darkTheme);
    notifyListeners();
  }

  // void toggleSwitch(bool value) {
  //   if (_isSwitched == false) {
  //     _isSwitched = true;
  //     textValue = 'Switch Button is ON';
  //     print('Switch Button is ON');
  //     Get.find<ThemeController>().toggleTheme();
  //     update();
  //
  //   } else {
  //     _isSwitched = false;
  //     textValue = 'Switch Button is OFF';
  //     print('Switch Button is OFF');
  //     Get.find<ThemeController>().toggleTheme();
  //     update();
  //   }
  // }

  void _loadCurrentTheme() async {
    _darkTheme = sharedPreferences.getBool(AppConstants.THEME) ?? false;
    notifyListeners();
  }
}
