// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class AuctionNotificationModel {
  List<int>? idsNotification;
  List<String>? idsResidence;
  AuctionNotificationModel({
    this.idsNotification,
    this.idsResidence,
  });

  AuctionNotificationModel emptyModel() {
    return AuctionNotificationModel(idsResidence: [], idsNotification: []);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idsNotification': idsNotification ?? [],
      'idsResidence': idsResidence ?? [],
    };
  }

  factory AuctionNotificationModel.fromMap(Map<String, dynamic> map) {
    List<int> listDynamicToInt(List<dynamic> listDynamic) {
      List<int> newList = [];
      for (int i in listDynamic) {
        newList.add(i);
      }

      return newList;
    }

    List<String> listDynamicToString(List<dynamic> listDynamic) {
      List<String> newList = [];
      for (String i in listDynamic) {
        newList.add(i);
      }

      return newList;
    }

    return AuctionNotificationModel(
      idsNotification: map['idsNotification'] != null
          ? listDynamicToInt(map['idsNotification'])
          : [],
      idsResidence: map['idsResidence'] != null
          ? listDynamicToString(map['idsResidence'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuctionNotificationModel.fromJson(String source) =>
      AuctionNotificationModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AuctionNotificationModel(idsNotification: $idsNotification, idsResidence: $idsResidence)';

  @override
  bool operator ==(covariant AuctionNotificationModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.idsNotification, idsNotification) &&
        listEquals(other.idsResidence, idsResidence);
  }

  @override
  int get hashCode => idsNotification.hashCode ^ idsResidence.hashCode;
}
