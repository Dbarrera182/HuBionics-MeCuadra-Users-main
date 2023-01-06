import 'package:me_cuadra_users/models/complement_models/auction_notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuctionNotificationPreferences {
  Future<AuctionNotificationModel> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AuctionNotificationModel auctionNotificationModel =
        AuctionNotificationModel();
    String? auctionNotificationString = prefs.getString('auctionNotification');
    if (auctionNotificationString == null) {
      auctionNotificationModel = AuctionNotificationModel().emptyModel();
    } else {
      auctionNotificationModel =
          AuctionNotificationModel.fromJson(auctionNotificationString);
    }
    return auctionNotificationModel;
  }

  saveData(AuctionNotificationModel model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringModel = model.toJson();
    prefs.setString('auctionNotification', stringModel);
  }

  clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('auctionNotification');
  }
}
