import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../preferences/user_preference.dart';

class UserProvider extends ChangeNotifier {
  UserModel user = UserModel();

  UserProvider() {
    getUserFromPreference();
  }

  void setUser(UserModel model) {
    user = model;
    notifyListeners();
  }

  void cleanUser() {
    user = UserModel();
    notifyListeners();
  }

  Future<void> getUserFromPreference() async {
    user = await UserPreferences().loadData();
    notifyListeners();
  }
}
