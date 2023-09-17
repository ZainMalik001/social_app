import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rubu/core/models/influencer_model.dart';
import 'package:rubu/features/home/controllers/home_controller.dart';

import '../../../core/models/post_model.dart';
import '../../../injection_handler.dart';
import '../services/firestore.dart';

class SearchController extends GetxController {
  final _searchFocus = FocusNode();
  final _controller = TextEditingController();

  bool _showClearIcon = false;
  bool _toggleSearch = false;
  bool _loadingSearch = false;

  bool get showClearIcon => _showClearIcon;
  bool get toggleSearch => _toggleSearch;
  bool get loadingSearch => _loadingSearch;
  FocusNode get searchFocus => _searchFocus;
  TextEditingController get controller => _controller;
  List<ProductModel> get searchedProducts => _searchedProducts;
  List<InfluencerModel> get searchedInfluencers => _searchedInfluencers;
  List<String> get recentSearches => _recentSearches;

  late GetStorage _storage;
  late List<String> _recentSearches;
  late List<ProductModel> _searchedProducts, _searchedCategory;
  late List<InfluencerModel> _searchedInfluencers;
  late SearchFirestoreService _firestoreService;

  @override
  void onInit() {
    _storage = sl.get<GetStorage>();
    _firestoreService = sl.get<SearchFirestoreService>();
    _getRecenterSearches();
    _searchFocus.addListener(() {
      update();
    });
    _controller.addListener(() {
      if (_controller.text.isNotEmpty && !_showClearIcon) {
        _showClearIcon = true;
        update();
      } else if (_controller.text.isEmpty && _showClearIcon) {
        _showClearIcon = false;
        update();
      }
    });
    super.onInit();
  }

  void clearCurrentSearch() {
    controller.clear();
    _toggleSearch = false;
    update();
  }

  void _getRecenterSearches() {
    _recentSearches = _storage.read('recent_searches')?.map<String>((e) => e.toString()).toList() ?? [];
  }

  void searchProducts(String query) async {
    final q = query.trim();
    if (q.isEmpty) {
      return;
    }
    _loadingSearch = true;
    update();

    _searchedProducts = await _firestoreService.searchProducts(q);
    _searchedInfluencers = await _firestoreService.searchInfluencers(q);
    // _searchedCategory = await _firestoreService.searchCategory(q);

    _loadingSearch = false;
    _toggleSearch = true;

    if (_recentSearches.contains(q)) _recentSearches.remove(q);
    _recentSearches = [q, ..._recentSearches];
    _storage.write('recent_searches', _recentSearches);
    update();
  }

  void removeRecentSearch(String query) {
    _recentSearches.remove(query);
    _storage.write('recent_searches', _recentSearches);
    update();
  }

  void toDiscoveryScreen(String category) {
    Get.toNamed(
      '/discover',
      arguments: {'category': category},
      id: 2,
    );
    Get.find<HomeController>().update();
  }

  void toggleFocus() {
    update();
  }
}
