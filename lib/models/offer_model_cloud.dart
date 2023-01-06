// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'offer_model.dart';

class OfferModelCloud {
  String? idResidence;
  List<OfferModel>? offers;
  OfferModelCloud({
    this.idResidence,
    this.offers,
  });

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> offersToMap(List<OfferModel>? model) {
      List<Map<String, dynamic>> offersMap = [];
      if (model != null) {
        offersMap = model.map((e) => e.toMap()).toList();
        return offersMap;
      } else {
        offersMap = [OfferModel('', '', 0, 0, '').toMap()];
        return offersMap;
      }
    }

    return <String, dynamic>{
      'idResidence': idResidence,
      'offers': offersToMap(offers),
    };
  }

  factory OfferModelCloud.fromMap(Map<String, dynamic> map) {
    List<OfferModel> listDynamicToOffers(List<dynamic> listDynamic) {
      List<OfferModel> newList = [];
      if (listDynamic.isNotEmpty) {
        for (var i = 0; i < listDynamic.length; i++) {
          newList.add(OfferModel.fromMap(listDynamic[i]));
        }
      }

      return newList;
    }

    return OfferModelCloud(
      idResidence:
          map['idResidence'] != null ? map['idResidence'] as String : null,
      offers: map['offers'] != null
          ? listDynamicToOffers(map['offers'])
          : [OfferModel('', '', 0, 0, '')],
    );
  }

  String toJson() => json.encode(toMap());

  factory OfferModelCloud.fromJson(String source) =>
      OfferModelCloud.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'OfferModelCloud(idResidence: $idResidence, offers: $offers)';

  @override
  bool operator ==(covariant OfferModelCloud other) {
    if (identical(this, other)) return true;

    return other.idResidence == idResidence && listEquals(other.offers, offers);
  }

  @override
  int get hashCode => idResidence.hashCode ^ offers.hashCode;
}
