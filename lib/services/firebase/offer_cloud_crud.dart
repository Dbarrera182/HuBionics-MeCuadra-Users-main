// ignore_for_file: invalid_return_type_for_catch_error

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/offer_model.dart';
import '../../models/offer_model_cloud.dart';

class OfferCloudCrud {
  CollectionReference offers =
      FirebaseFirestore.instance.collection('offers_cloud');

  Future<void> addOffer(
    OfferModelCloud model,
  ) async {
    // Call the offer's CollectionReference to add a new offer model
    dynamic modelTemp;
    if (model.idResidence != null || model.idResidence != '') {
      modelTemp = offers.doc(model.idResidence);
    } else {
      modelTemp = offers.doc();
    }
    String id = modelTemp.id;
    model.idResidence = id;
    await modelTemp.set({
      'idResidence': model.idResidence,
      'offers': offersToMap(model.offers),
    }).then((value) {
      log("Offer Added");
    }).catchError((error) => log("❌Failed to add the offer: $error"));
  }

  Future<OfferModelCloud> getOffer(String id) async {
    //Get a offer model for the idOffer
    OfferModelCloud model = OfferModelCloud();
    await offers
        .where('idResidence'.trim(), isEqualTo: id.trim())
        .get()
        .then((querySnapshot) {
      for (var element in querySnapshot.docs) {
        model.idResidence = element.get('idResidence');
        model.offers = listDynamicToOffers(element.get('offers'));
      }
    }).then((value) {
      log("🆗  get Offer for id offer");
    });
    return model;
  }

  Future<List<OfferModelCloud>> getAllOffers() async {
    //Get all offer concludeds
    List<OfferModelCloud> offerList = [];
    try {
      await offers
          .where('idResidence'.trim(), isNotEqualTo: '')
          .get()
          .then((querySnapshot) {
        for (var element in querySnapshot.docs) {
          OfferModelCloud model = OfferModelCloud();
          model.idResidence = element.get('idResidence');
          model.offers = listDynamicToOffers(element.get('offers'));

          offerList.add(model);
        }
      });
      return offerList;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return [];
    }
  }

  Future updateOffer(String id, OfferModelCloud model) {
    //Update all the offer object with the id and one offer model
    return offers.doc(id).update({
      "idResidence": model.idResidence,
      "offers": offersToMap(model.offers),
    }).then((value) {
      log("Offer update");
    }).catchError((error) => log("❌Failed to update the offer: $error"));
  }

  Future<void> deleteOffer(String id) async {
    //Delete a offer with the id Residence
    await offers
        .doc(id)
        .delete()
        .then((value) => log("Offer deleted"))
        .catchError((error) => log("❌Failed to deleted the offer: $error"));
  }

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

  List<OfferModel> listDynamicToOffers(List<dynamic> listDynamic) {
    List<OfferModel> newList = [];
    if (listDynamic.isNotEmpty) {
      for (var i = 0; i < listDynamic.length; i++) {
        newList.add(OfferModel.fromMap(listDynamic[i]));
      }
    }

    return newList;
  }
}
