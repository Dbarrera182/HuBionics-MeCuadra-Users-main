// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class VisitsModel {
  String? initTime;
  String? finalTime;
  List<String>? visitingUsers;
  VisitsModel({
    this.initTime,
    this.finalTime,
    this.visitingUsers,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'initTime': initTime ?? '',
      'finalTime': finalTime ?? '',
      'visitingUsers': visitingUsers ?? [],
    };
  }

  Map<String, dynamic> emptyMap() {
    return <String, dynamic>{
      'initTime': '',
      'finalTime': '',
      'visitingUsers': [],
    };
  }

  factory VisitsModel.fromMap(Map<String, dynamic> map) {
    List<String> listDynamicToString(List<dynamic> listDynamic) {
      List<String> newList = [];
      for (String i in listDynamic) {
        newList.add(i);
      }

      return newList;
    }

    return VisitsModel(
      initTime: map['initTime'] != null ? map['initTime'] as String : '',
      finalTime: map['finalTime'] != null ? map['finalTime'] as String : '',
      visitingUsers: listDynamicToString(map['visitingUsers']),
    );
  }

  String toJson() => json.encode(toMap());

  factory VisitsModel.fromJson(String source) =>
      VisitsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VisitsModel(initTime: $initTime, finalTime: $finalTime, visitingUsers: $visitingUsers)';
  }

  @override
  bool operator ==(covariant VisitsModel other) {
    if (identical(this, other)) return true;

    return other.initTime == initTime &&
        other.finalTime == finalTime &&
        listEquals(other.visitingUsers, visitingUsers);
  }

  @override
  int get hashCode {
    return initTime.hashCode ^ finalTime.hashCode ^ visitingUsers.hashCode;
  }
}
