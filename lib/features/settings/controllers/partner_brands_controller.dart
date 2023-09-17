import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:rubu/core/models/partner_brands_model.dart';

class PartnerBrandsController extends GetxController {
  final _args = Get.arguments;

  final _searchFocus = FocusNode();
  final _controller = TextEditingController();
  bool _showClearIcon = false;

  late List<PartnerBrandsModel> _partnerBrands;

  bool get showClearIcon => _showClearIcon;
  FocusNode get searchFocus => _searchFocus;
  TextEditingController get controller => _controller;
  List<PartnerBrandsModel> get brands => _args['brands'];
  List<PartnerBrandsModel> get partnerBrands => _partnerBrands;

  @override
  void onInit() {
    _partnerBrands = brands;
    super.onInit();
  }

  void clearCurrentSearch() {
    _controller.clear();
    _showClearIcon = false;
    _partnerBrands = brands;
    update();
  }

  void searchProducts(String query) {
    if (query.isNotEmpty) {
      _showClearIcon = true;
      _partnerBrands = brands.where((element) => element.name.toLowerCase().contains(query.toLowerCase())).toList();
      update();
    }
  }
}
