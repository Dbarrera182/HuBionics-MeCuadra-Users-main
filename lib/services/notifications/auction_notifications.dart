import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';

import '../../preferences/auction_notification_preferences.dart';

Future<void> createAuctionNotification(
    DateTime notificationSchedule, String idResidence) async {
  int id = Random().nextInt(999999999);
  var auctionsNotification = await AuctionNotificationPreferences().loadData();
  auctionsNotification.idsNotification!.add(id);
  auctionsNotification.idsResidence!.add(idResidence);
  AuctionNotificationPreferences().saveData(auctionsNotification);
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: id,
          channelKey: 'scheduled_channel',
          title: '${Emojis.time_alarm_clock} Arranca la subasta',
          body:
              'La subasta de tu propiedad comenzará pronto, preparate! ${Emojis.smile_anxious_face_with_sweat}',
          notificationLayout: NotificationLayout.Default),
      actionButtons: [
        NotificationActionButton(key: 'MARK_DONE', label: 'Entendido')
      ],
      schedule: NotificationCalendar(
          repeats: false,
          day: notificationSchedule.day,
          month: notificationSchedule.month,
          year: notificationSchedule.year,
          hour: notificationSchedule.hour,
          minute: notificationSchedule.minute,
          second: notificationSchedule.second,
          millisecond: notificationSchedule.millisecond));
}

Future<void> cancelAuctionNotifications(int id) async {
  await AwesomeNotifications().cancel(id);
}
