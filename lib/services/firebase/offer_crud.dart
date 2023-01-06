import 'package:firebase_database/firebase_database.dart';

import '../../models/offer_model.dart';

class OfferCrud {
  final DatabaseReference _offersRef =
      FirebaseDatabase.instance.ref().child('offers');

  void saveOffer(OfferModel offer, String idResidence) {
    _offersRef.child(idResidence).push().set(offer.toMap());
  }

  Query getOffers(String idResidence) => _offersRef.child(idResidence);
}
