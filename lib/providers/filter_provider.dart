import 'package:flutter/material.dart';

import '../models/complement_models/filters_model.dart';
import '../preferences/filter_preference.dart';

class FilterProvider extends ChangeNotifier {
  FiltersModel filter = FiltersModel();

  FilterProvider() {
    getFilterFromPreference();
  }

  void setFilter(FiltersModel model) {
    filter = model;
    notifyListeners();
  }

  void cleanFilter() {
    filter = FiltersModel();
    notifyListeners();
  }

  Future<void> getFilterFromPreference() async {
    filter = await FilterPreference().loadData();
    notifyListeners();
  }
}
