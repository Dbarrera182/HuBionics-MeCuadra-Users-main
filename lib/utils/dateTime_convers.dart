// ignore_for_file: file_names

class DateTimeConver {
  static DateTime getDateTimeNowInUTCFormat() {
    DateTime thisDate = DateTime.now();
    var utcDiferenceHour = thisDate.toUtc().hour - thisDate.hour;
    var utcDiferenceMin = thisDate.toUtc().minute - (thisDate.minute);
    DateTime nowDate = thisDate
        .toUtc()
        .subtract(Duration(hours: utcDiferenceHour, minutes: utcDiferenceMin));
    return nowDate;
  }
}
