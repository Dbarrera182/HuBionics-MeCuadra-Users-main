import 'package:shared_preferences/shared_preferences.dart';

import '../models/complement_models/filters_model.dart';

class FilterPreference {
  Future<FiltersModel> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FiltersModel filtersModel = FiltersModel();
    String? filterString = prefs.getString('filters');
    if (filterString == null) {
      filtersModel = FiltersModel().emptyModel();
    } else {
      filtersModel = FiltersModel.fromJson(filterString);
    }
    return filtersModel;
  }

  saveData(FiltersModel model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringModel = model.toJson();
    prefs.setString('filters', stringModel);
  }

  clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('filters');
  }
}
