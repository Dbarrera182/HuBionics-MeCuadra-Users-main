import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user_model.dart';

class UserCrud {
  // Create a CollectionReference called doctors that references the firestore collection
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(
    UserModel userModel,
  ) async {
    // Call the users's CollectionReference to add a new modelUser
    // ignore: prefer_typing_uninitialized_variables
    var user;
    if (userModel.id != null || userModel.id != '') {
      user = users.doc(userModel.id);
    } else {
      user = users.doc();
    }
    String id = user.id;
    userModel.id = id;
    await user
        .set({
          'id': userModel.id,
          'userToken': userModel.userToken ?? "",
          'userName': userModel.userName ?? "",
          'userIdentification': userModel.userIdentification ?? "",
          'lastAccessDate': userModel.lastAccessDate ?? "",
          'userInterest': userModel.userInterest ?? [''],
          'userState': userModel.userState ?? [''],
          'email': userModel.email ?? "",
          'photoURL': userModel.photoURL ?? "",
          'userScheduledProperties': userModel.userScheduledProperties ?? [],
          'userLikes': userModel.userLikes ?? [],
          'userProperties': userModel.userProperties ?? [],
          'phoneNumber': userModel.phoneNumber ?? "",
          'isVerified': userModel.isVerified ?? false,
        })
        .then((value) => log("✅User added"))
        .catchError((error) => log("❌Failed to add user: $error"));
  }

  Future<UserModel> getUser(String id) async {
    //Get a doctorModel for the idDoctor
    UserModel model = UserModel();
    await users
        .where('id'.trim(), isEqualTo: id.trim())
        .get()
        .then((querySnapshot) {
      for (var element in querySnapshot.docs) {
        model.id = element.get('id');
        model.userToken = element.get('userToken');
        model.lastAccessDate = element.get('lastAccessDate');
        model.userIdentification = element.get('userIdentification');
        model.userInterest = listDynamicToString(element.get('userInterest'));
        model.userState = listDynamicToString(element.get('userState'));
        model.email = element.get('email');
        model.userName = element.get('userName');
        model.photoURL = element.get('photoURL');
        model.userScheduledProperties =
            listDynamicToString(element.get('userScheduledProperties'));
        model.userLikes = listDynamicToString(element.get('userLikes'));
        model.userProperties =
            listDynamicToString(element.get('userProperties'));
        model.phoneNumber = element.get('phoneNumber');
        model.isVerified = element.get('isVerified');
      }
    }).then((value) {
      log("🆗  get User for id User");
    });
    return model;
  }

  Future<UserModel> getUserforEmail(String mail) async {
    //Get a doctorModel for the idDoctor
    UserModel model = UserModel();
    await users
        .where('email'.trim(), isEqualTo: mail.trim())
        .get()
        .then((querySnapshot) {
      for (var element in querySnapshot.docs) {
        model.id = element.get('id');
        model.userToken = element.get('userToken');
        model.lastAccessDate = element.get('lastAccessDate');
        model.userIdentification = element.get('userIdentification');
        model.userInterest = listDynamicToString(element.get('userInterest'));
        model.userState = listDynamicToString(element.get('userState'));
        model.email = element.get('email');
        model.userName = element.get('userName');
        model.photoURL = element.get('photoURL');
        model.userScheduledProperties =
            listDynamicToString(element.get('userScheduledProperties'));
        model.userLikes = listDynamicToString(element.get('userLikes'));
        model.userProperties =
            listDynamicToString(element.get('userProperties'));
        model.phoneNumber = element.get('phoneNumber');
        model.isVerified = element.get('isVerified');
      }
    }).then((value) {
      log("🆗  get User for id User");
    });
    return model;
  }

  Future<List<UserModel>> getUsersForRank(String rank) async {
    //Get a doctorModel for the idDoctor
    List<UserModel> userList = [];

    try {
      await users
          .where('rank'.trim(), isEqualTo: rank.toString().trim())
          .get()
          .then((querySnapshot) {
        for (var element in querySnapshot.docs) {
          UserModel user = UserModel();
          user.id = element.get('id');
          user.userToken = element.get('userToken');
          user.lastAccessDate = element.get('lastAccessDate');

          user.email = element.get('email');
          user.userIdentification = element.get('userIdentification');
          user.userInterest = listDynamicToString(element.get('userInterest'));
          user.userState = listDynamicToString(element.get('userState'));
          user.userName = element.get('userName');
          user.photoURL = element.get('photoURL');
          user.userScheduledProperties =
              listDynamicToString(element.get('userScheduledProperties'));
          user.userLikes = listDynamicToString(element.get('userLikes'));
          user.userProperties =
              listDynamicToString(element.get('userProperties'));
          user.phoneNumber = element.get('phoneNumber');
          user.isVerified = element.get('isVerified');
          userList.add(user);
        }
      });

      return userList;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return [];
    }
  }

  Future<void> deleteUser(String id) async {
    //Delete a doctor with the idDoctor
    await users
        .doc(id)
        .delete()
        .then((value) => log("User deleted"))
        .catchError((error) => log("❌Failed to deleted the user: $error"));
  }

  Future updateUser(String id, UserModel model) {
    //Update all doctor object with the id and one doctor model
    return users.doc(id).update({
      "id": model.id,
      "userToken": model.userToken,
      "email": model.email,
      "lastAccessDate": model.lastAccessDate,
      "userIdentification": model.userIdentification,
      "userInterest": model.userInterest,
      "userState": model.userState,
      "userName": model.userName,
      "photoURL": model.photoURL,
      "userProperties": model.userProperties,
      "userScheduledProperties": model.userScheduledProperties,
      "userLikes": model.userLikes,
      "phoneNumber": model.phoneNumber,
      "isVerified": model.isVerified,
    }).then((value) {
      log("User update");
      // ignore: invalid_return_type_for_catch_error
    }).catchError((error) => log("❌Failed to update user: $error"));
  }

  List<String> listDynamicToString(List<dynamic> listDynamic) {
    List<String> newList = [];
    for (String i in listDynamic) {
      newList.add(i);
    }

    return newList;
  }
}
