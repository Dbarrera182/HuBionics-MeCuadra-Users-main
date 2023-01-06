// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OfferDB {
  String? key;
  OfferModel? offerModel;

  OfferDB({this.key, this.offerModel});
}

class OfferModel {
  String? idUser;
  String? userName;
  int? userPalette;
  int? ofertPrice;
  String? ofertDate;

  OfferModel(this.idUser, this.userName, this.userPalette, this.ofertPrice,
      this.ofertDate);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idUser': idUser,
      'userName': userName,
      'userPalette': userPalette,
      'ofertPrice': ofertPrice,
      'ofertDate': ofertDate,
    };
  }

  Map<String, dynamic> emptyMap() {
    return <String, dynamic>{
      'idUser': '',
      'userName': '',
      'userPalette': 0,
      'ofertPrice': 0,
      'ofertDate': ''
    };
  }

  factory OfferModel.fromMap(Map<dynamic, dynamic> map) {
    return OfferModel(
      map['idUser'] != null ? map['idUser'] as String : '',
      map['userName'] != null ? map['userName'] as String : '',
      map['userPalette'] != null ? map['userPalette'] as int : 0,
      map['ofertPrice'] != null ? map['ofertPrice'] as int : 0,
      map['ofertDate'] != null ? map['ofertDate'] as String : '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OfferModel.fromJson(String source) =>
      OfferModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OfertModel(idUser: $idUser, userName: $userName, userPalette: $userPalette, ofertPrice: $ofertPrice, ofertDate: $ofertDate)';
  }

  @override
  bool operator ==(covariant OfferModel other) {
    if (identical(this, other)) return true;

    return other.idUser == idUser &&
        other.userName == userName &&
        other.userPalette == userPalette &&
        other.ofertPrice == ofertPrice &&
        other.ofertDate == ofertDate;
  }

  @override
  int get hashCode {
    return idUser.hashCode ^
        userName.hashCode ^
        userPalette.hashCode ^
        ofertPrice.hashCode ^
        ofertDate.hashCode;
  }
}
