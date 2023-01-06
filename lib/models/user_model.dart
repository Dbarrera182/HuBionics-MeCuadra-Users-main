import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  String? id;
  String? userToken;
  String? userName;
  String? userIdentification;
  List<String>? userInterest;
  String? singinMethod;
  String? lastAccessDate;
  List<String>? userState;
  String? email;
  List<String>? userProperties;
  List<String>? userScheduledProperties;
  List<String>? userLikes;
  String? phoneNumber;
  String? photoURL;
  bool? isVerified;

  UserModel({
    this.id,
    this.userToken,
    this.userName,
    this.userIdentification,
    this.userInterest,
    this.singinMethod,
    this.userState,
    this.email,
    this.lastAccessDate,
    this.userProperties,
    this.userScheduledProperties,
    this.userLikes,
    this.phoneNumber,
    this.photoURL,
    this.isVerified,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userToken': userToken,
      'userName': userName,
      'userIdentification': userIdentification,
      'lastAccessDate': lastAccessDate,
      'singinMethod': singinMethod,
      'userInterest': userInterest ?? [''],
      'userState': userState ?? [''],
      'email': email,
      'userProperties': userProperties ?? [],
      'userScheduledProperties': userScheduledProperties ?? [],
      'userLikes': userLikes ?? [],
      'phoneNumber': phoneNumber,
      'photoURL': photoURL ?? '',
      'isVerified': isVerified ?? false,
    };
  }

  UserModel emptyModel() {
    return UserModel(
        id: '',
        userName: '',
        email: '',
        isVerified: false,
        phoneNumber: '',
        lastAccessDate: '',
        photoURL: '',
        userScheduledProperties: [],
        userLikes: [],
        singinMethod: '',
        userIdentification: '',
        userInterest: [''],
        userState: [''],
        userProperties: [],
        userToken: '');
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    List<String> listDynamicToString(List<dynamic> listDynamic) {
      List<String> newList = [];
      for (String i in listDynamic) {
        newList.add(i);
      }
      return newList;
    }

    return UserModel(
      id: map['id'] != null ? map['id'] as String : '',
      userToken: map['userToken'] != null ? map['userToken'] as String : '',
      userName: map['userName'] != null ? map['userName'] as String : '',
      userIdentification: map['userIdentification'] != null
          ? map['userIdentification'] as String
          : '',
      singinMethod:
          map['singinMethod'] != null ? map['singinMethod'] as String : '',
      lastAccessDate:
          map['singinMethod'] != null ? map['singinMethod'] as String : '',
      userInterest: map['userInterest'] != null
          ? listDynamicToString(map['userInterest'])
          : [''],
      userState: map['userState'] != null
          ? listDynamicToString(map['userState'])
          : [''],
      email: map['email'] != null ? map['email'] as String : '',
      userProperties: map['userProperties'] != null
          ? listDynamicToString(map['userProperties'])
          : [],
      userScheduledProperties: map['userScheduledProperties'] != null
          ? listDynamicToString(map['userScheduledProperties'])
          : [],
      userLikes:
          map['userLikes'] != null ? listDynamicToString(map['userLikes']) : [],
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : '',
      photoURL: map['photoURL'] != null ? map['photoURL'] as String : '',
      isVerified: map['isVerified'] != null ? map['isVerified'] as bool : false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id,userToken: $userToken,userIdentification: $userIdentification, singinMethod: $singinMethod, lastAccessDate: $lastAccessDate, userInterest: $userInterest ,userState: $userState ,userName: $userName, email: $email,  userProperties: $userProperties, userScheduledProperties: $userScheduledProperties, userLikes: $userLikes, phoneNumber: $phoneNumber, photoURL: $photoURL, isVerified: $isVerified)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userToken == userToken &&
        other.userName == userName &&
        other.lastAccessDate == lastAccessDate &&
        other.singinMethod == singinMethod &&
        other.userIdentification == userIdentification &&
        other.userInterest == userInterest &&
        other.userState == userState &&
        other.email == email &&
        listEquals(other.userProperties, userProperties) &&
        listEquals(other.userScheduledProperties, userScheduledProperties) &&
        listEquals(other.userLikes, userLikes) &&
        other.phoneNumber == phoneNumber &&
        other.photoURL == photoURL &&
        other.isVerified == isVerified;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userToken.hashCode ^
        userName.hashCode ^
        userIdentification.hashCode ^
        lastAccessDate.hashCode ^
        singinMethod.hashCode ^
        userInterest.hashCode ^
        userState.hashCode ^
        email.hashCode ^
        userProperties.hashCode ^
        userScheduledProperties.hashCode ^
        userLikes.hashCode ^
        phoneNumber.hashCode ^
        photoURL.hashCode ^
        isVerified.hashCode;
  }
}
