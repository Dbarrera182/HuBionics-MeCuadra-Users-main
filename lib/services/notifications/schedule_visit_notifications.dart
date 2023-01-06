import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:me_cuadra_users/models/user_model.dart';

Future<void> createBasicNotification(String urlImage, String body) async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 8,
          icon: 'resource://drawable/res_notification_app_icon',
          channelKey: 'basic_channel',
          title: 'Notificación de MeCuadra',
          body: body,
          bigPicture: urlImage,
          notificationLayout: NotificationLayout.BigPicture));
}

Future<void> createReminderNotification(DateTime notificationSchedule) async {
  int id = Random().nextInt(999999999);
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: id,
          channelKey: 'scheduled_channel',
          title: '${Emojis.time_alarm_clock} Visita MeCuadra',
          body: 'Recuerda la visita programada de tu vivienda',
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

Future<void> createAuctionInitNotification(
    DateTime notificationSchedule) async {
  int id = Random().nextInt(999999999);
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: id,
          channelKey: 'scheduled_channel',
          title: '${Emojis.time_alarm_clock} Arranca la subasta',
          body: 'La subasta está por comenzar, preparate!',
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

Future<void> cancelScheduleNotifications() async {
  await AwesomeNotifications().cancelAll();
}
