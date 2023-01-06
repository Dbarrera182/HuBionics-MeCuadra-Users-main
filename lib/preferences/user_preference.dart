import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class UserPreferences {
  Future<UserModel> loadData() async {
    UserModel userModel = UserModel();
    String? userString;
    await SharedPreferences.getInstance()
        .then((prefs) => {userString = prefs.getString('user') ?? ''});
    if (userString == null || userString == '') {
      userModel = UserModel().emptyModel();
    } else {
      userModel = UserModel.fromJson(userString!);
    }
    return userModel;
  }

  saveData(UserModel model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringModel = model.toJson();
    prefs.setString('user', stringModel);
  }

  clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
  }
}
