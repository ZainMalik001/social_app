import 'package:country/country.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:rubu/features/home/controllers/home_controller.dart';
import 'package:rubu/features/settings/controllers/change_controller.dart';

class CountryController extends GetxController {
  String _selectedCountry = Get.find<HomeController>().user.country ?? '';

  String get selectedCountry => _selectedCountry;

  void selectCountry(Country country) {
    _selectedCountry = country.alpha3;
    update();

    Get.find<ChangeController>().selectedCountry = country.alpha3;

    Get.find<HomeController>()
      ..user.country = country.alpha3
      ..update();

    Get.back();
  }
}
