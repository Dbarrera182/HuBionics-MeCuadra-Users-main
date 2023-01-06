// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'document_model.dart';

// ignore_for_file: file_names

class AuctionParticipant {
  String? idUser;
  String? userName;
  String? userToken;
  String? userImage;
  String? userPhoneNumber;
  String? userMail;
  String? requestState;
  String? requestDate;
  List<DocumentModel>? guaranteePayment;
  List<DocumentModel>? creditStudy;
  List<DocumentModel>? userIdentification;

  AuctionParticipant(
      {this.idUser,
      this.userToken,
      this.userName,
      this.userImage,
      this.userMail,
      this.userPhoneNumber,
      this.requestState,
      this.requestDate,
      this.guaranteePayment,
      this.creditStudy,
      this.userIdentification});

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> documentToMap(List<DocumentModel>? model) {
      List<Map<String, dynamic>> documents = [];
      if (model != null) {
        documents = model.map((e) => e.toMap()).toList();
        return documents;
      } else {
        documents = [DocumentModel().emptyMap()];
        return documents;
      }
    }

    return <String, dynamic>{
      'idUser': idUser ?? '',
      'userToken': userToken ?? '',
      'userImage': userImage ?? '',
      'userMail': userMail ?? '',
      'userName': userName ?? '',
      'userPhoneNumber': userPhoneNumber ?? '',
      'requestState': requestState ?? '',
      'requestDate': requestDate ?? '',
      'guaranteePayment': documentToMap(guaranteePayment),
      'creditStudy': documentToMap(creditStudy),
      'userIdentification': documentToMap(userIdentification)
    };
  }

  Map<String, dynamic> emptyMap() {
    return <String, dynamic>{
      'idUser': '',
      'userToken': '',
      'userImage': '',
      'userMail': '',
      'userName': '',
      'userPhoneNumber': '',
      'requestState': '',
      'requestDate': '',
      'guaranteePayment': [DocumentModel().emptyMap()],
      'creditStudy': [DocumentModel().emptyMap()],
      'userIdentification': [DocumentModel().emptyMap()]
    };
  }

  factory AuctionParticipant.fromMap(Map<String, dynamic> map) {
    List<DocumentModel> listDynamicToDocument(List<dynamic> listDynamic) {
      List<DocumentModel> newList = [];
      if (listDynamic.isNotEmpty) {
        for (var i = 0; i < listDynamic.length; i++) {
          newList.add(DocumentModel.fromMap(listDynamic[i]));
        }
      }

      return newList;
    }

    return AuctionParticipant(
        idUser: map['idUser'] != null ? map['idUser'] as String : '',
        userToken: map['userToken'] != null ? map['userToken'] as String : '',
        userImage: map['userImage'] != null ? map['userImage'] as String : '',
        userMail: map['userMail'] != null ? map['userMail'] as String : '',
        userName: map['userName'] != null ? map['userName'] as String : '',
        userPhoneNumber: map['userPhoneNumber'] != null
            ? map['userPhoneNumber'] as String
            : '',
        requestState:
            map['requestState'] != null ? map['requestState'] as String : '',
        requestDate:
            map['requestDate'] != null ? map['requestDate'] as String : '',
        guaranteePayment: map['guaranteePayment'] != null
            ? listDynamicToDocument(map['guaranteePayment'])
            : [DocumentModel(documentName: '', documentURL: '')],
        creditStudy: map['creditStudy'] != null
            ? listDynamicToDocument(map['creditStudy'])
            : [DocumentModel(documentName: '', documentURL: '')],
        userIdentification: map['userIdentification'] != null
            ? listDynamicToDocument(map['userIdentification'])
            : [DocumentModel(documentName: '', documentURL: '')]);
  }

  String toJson() => json.encode(toMap());

  factory AuctionParticipant.fromJson(String source) =>
      AuctionParticipant.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AuctionParticipants(idUser: $idUser,userToken: $userToken,userImage: $userImage, userMail: $userMail ,userName: $userName, userPhoneNumber: $userPhoneNumber, requestState: $requestState, requestDate: $requestDate,guaranteePayment: $guaranteePayment,creditStudy: $creditStudy,userIdentification: $userIdentification)';
  }

  @override
  bool operator ==(covariant AuctionParticipant other) {
    if (identical(this, other)) return true;

    return other.idUser == idUser &&
        other.userToken == userToken &&
        other.userImage == userImage &&
        other.userName == userName &&
        other.userMail == userMail &&
        other.userPhoneNumber == userPhoneNumber &&
        other.requestState == requestState &&
        other.requestDate == requestDate &&
        other.guaranteePayment == guaranteePayment &&
        other.creditStudy == creditStudy &&
        other.userIdentification == userIdentification;
  }

  @override
  int get hashCode {
    return idUser.hashCode ^
        userToken.hashCode ^
        userName.hashCode ^
        userImage.hashCode ^
        userMail.hashCode ^
        userPhoneNumber.hashCode ^
        requestState.hashCode ^
        requestDate.hashCode ^
        guaranteePayment.hashCode ^
        creditStudy.hashCode ^
        userIdentification.hashCode;
  }
}
