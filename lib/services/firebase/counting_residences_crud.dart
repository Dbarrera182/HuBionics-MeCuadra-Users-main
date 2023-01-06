// ignore_for_file: file_names, invalid_return_type_for_catch_error

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:me_cuadra_users/models/complement_models/counting_residences_model.dart';

class CountingResidencesCrud {
  CollectionReference countingResidences =
      FirebaseFirestore.instance.collection('countingResidences');

  Future<CountingResidenceModel> getCounting() async {
    //Get a residence model for the idResidence
    CountingResidenceModel model = CountingResidenceModel();
    await countingResidences
        .where('id'.trim(), isEqualTo: 'counter')
        .get()
        .then((querySnapshot) {
      for (var element in querySnapshot.docs) {
        model.counting = element.get('counting');
      }
    }).then((value) {});
    return model;
  }

  Future updateResidence(CountingResidenceModel model) {
    //Update all doctor object with the id and one doctor model
    return countingResidences
        .doc('counting')
        .update({
          "counting": model.counting,
        })
        .then((value) {})
        .catchError((error) => log("❌Failed to update residence: $error"));
  }
}
