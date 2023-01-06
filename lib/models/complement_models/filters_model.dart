// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class FiltersModel {
  List<String>? availibity;
  List<String>? typeOfResidence;
  List<String>? typeOfAuction;
  List<String>? stateOfResidence;
  int? room;
  int? bath;
  int? garage;
  String? city;
  int? minPrice;
  int? maxPrice;

  FiltersModel(
      {this.availibity,
      this.typeOfResidence,
      this.stateOfResidence,
      this.typeOfAuction,
      this.room,
      this.bath,
      this.garage,
      this.city,
      this.minPrice,
      this.maxPrice});

  FiltersModel emptyModel() {
    return FiltersModel(
        availibity: [],
        bath: 0,
        city: '',
        garage: 0,
        maxPrice: 0,
        minPrice: 0,
        room: 0,
        typeOfAuction: [],
        stateOfResidence: [],
        typeOfResidence: []);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'availibity': availibity ?? [],
      'typeOfResidence': typeOfResidence ?? [],
      'stateOfResidence': stateOfResidence ?? [],
      'typeOfAuction': typeOfAuction ?? [],
      'room': room ?? 0,
      'bath': bath ?? 0,
      'garage': garage ?? 0,
      'city': city ?? '',
      'minPrice': minPrice ?? 0,
      'maxPrice': maxPrice ?? 0,
    };
  }

  factory FiltersModel.fromMap(Map<String, dynamic> map) {
    List<String> listDynamicToString(List<dynamic> listDynamic) {
      List<String> newList = [];
      for (String i in listDynamic) {
        newList.add(i);
      }

      return newList;
    }

    return FiltersModel(
      availibity: map['availibity'] != null
          ? listDynamicToString(map['availibity'])
          : [],
      typeOfAuction: map['typeOfAuction'] != null
          ? listDynamicToString(map['typeOfAuction'])
          : [],
      typeOfResidence: map['typeOfResidence'] != null
          ? listDynamicToString(map['typeOfResidence'])
          : [],
      stateOfResidence: map['stateOfResidence'] != null
          ? listDynamicToString(map['stateOfResidence'])
          : [],
      room: map['room'] != null ? map['room'] as int : 0,
      bath: map['bath'] != null ? map['bath'] as int : 0,
      garage: map['garage'] != null ? map['garage'] as int : 0,
      city: map['city'] != null ? map['city'] as String : '',
      minPrice: map['minPrice'] != null ? map['minPrice'] as int : 0,
      maxPrice: map['maxPrice'] != null ? map['maxPrice'] as int : 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory FiltersModel.fromJson(String source) =>
      FiltersModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FiltersModel(availibity: $availibity, typeOfResidence: $typeOfResidence,typeOfAuction: $typeOfAuction, stateOfResidence: $stateOfResidence, room: $room, bath: $bath, garage: $garage, city: $city, minPrice: $minPrice, maxPrice: $maxPrice)';
  }

  @override
  bool operator ==(covariant FiltersModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.availibity, availibity) &&
        listEquals(other.typeOfResidence, typeOfResidence) &&
        listEquals(other.stateOfResidence, stateOfResidence) &&
        listEquals(other.typeOfAuction, typeOfAuction) &&
        other.room == room &&
        other.bath == bath &&
        other.garage == garage &&
        other.city == city &&
        other.minPrice == minPrice &&
        other.maxPrice == maxPrice;
  }

  @override
  int get hashCode {
    return availibity.hashCode ^
        typeOfResidence.hashCode ^
        typeOfAuction.hashCode ^
        stateOfResidence.hashCode ^
        room.hashCode ^
        bath.hashCode ^
        garage.hashCode ^
        city.hashCode ^
        minPrice.hashCode ^
        maxPrice.hashCode;
  }
}
