import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';

import '../../shared_preferences/shared_prefs_repo.dart';
import 'app_theme.dart';

class AppThemeController extends GetxController {
  final _sharedPreferencesRepo = Get.put(SharedPrefsRepo());

  var isDark = false.obs;

  void toggleDarkTheme(bool value) {
    _sharedPreferencesRepo.put('isDarkOption', value);
    isDark.value = value;
    Get.changeTheme(
      Get.isDarkMode ? AppTheme().theme(false) : AppTheme().theme(true),
    );
  }
}