// Import the firebase_core and cloud_firestore plugin
// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/employee_model.dart';

class CrudEmployee {
  // Create a CollectionReference called salesmen that references the firestore collection
  CollectionReference workers =
      FirebaseFirestore.instance.collection('workers');

  Future<void> addEmployee(
    EmployeeModel model,
  ) async {
    // Call the salesmen's CollectionReference to add a new model of employee
    final employee = workers.doc();
    String id = employee.id;
    model.id = id;
    await employee
        .set({
          'id': model.id,
          'assignedProperties': model.assignedProperties ?? 0,
          'businessNumber': model.businessNumber ?? "",
          'createDate': model.createDate ?? "",
          'direction': model.direction ?? "",
          'email': model.email ?? "",
          'emailVerified': model.emailVerified ?? "",
          'image': model.image ?? "",
          'name': model.name ?? "",
          'personalNumber': model.personalNumber ?? "",
          'position': model.position ?? "",
          'propertyType': model.propertyType ?? "",
          'specializedSector': model.specializedSector ?? "",
        })
        .then((value) => log("Employee Added"))
        .catchError((error) => log("❌Failed to add employee: $error"));
  }

  Future<EmployeeModel> getEmployee(String id) async {
    //Get a employee model for the id employee
    EmployeeModel model = EmployeeModel();
    await workers
        .where('id'.trim(), isEqualTo: id.trim())
        .get()
        .then((querySnapshot) {
      for (var element in querySnapshot.docs) {
        model.id = element.get('id');
        model.position = element.get('position');
        model.name = element.get('name');
        model.personalNumber = element.get('personalNumber');
        model.businessNumber = element.get('businessNumber');
        model.image = element.get('image');
        model.createDate = element.get('createDate');
        model.direction = element.get('direction');
        model.email = element.get('email');

        model.assignedProperties = element.get('assignedProperties');
        model.propertyType = element.get('propertyType');
        model.specializedSector = element.get('specializedSector');
        model.emailVerified = element.get('emailVerified');
      }
    }).then((value) {
      log("🆗  get Employee for id employee");
    });
    return model;
  }

  Future<EmployeeModel> getEmployeeForEmail(
      BuildContext context, String email) async {
    //Get a employee for the email
    EmployeeModel model = EmployeeModel();
    await workers
        .where('email'.trim(), isEqualTo: email.trim())
        .get()
        .then((querySnapshot) {
      for (var element in querySnapshot.docs) {
        model.id = element.get('id');
        model.position = element.get('position');
        model.name = element.get('name');
        model.personalNumber = element.get('personalNumber');
        model.businessNumber = element.get('businessNumber');
        model.image = element.get('image');
        model.createDate = element.get('createDate');
        model.direction = element.get('direction');
        model.email = element.get('email');

        model.assignedProperties = element.get('assignedProperties');
        model.propertyType = element.get('propertyType');
        model.specializedSector = element.get('specializedSector');
        model.emailVerified = element.get('emailVerified');
      }
    }).then((value) {
      log("🆗  get employee for email");
    });
    return model;
  }

  Future<List<EmployeeModel>> getAllWorkers(String position) async {
    //Get all workers
    List<EmployeeModel> workersList = [];

    try {
      await workers
          .where('position'.trim(), isEqualTo: position.trim())
          .get()
          .then((querySnapshot) {
        for (var element in querySnapshot.docs) {
          EmployeeModel model = EmployeeModel();
          model.id = element.get('id');
          model.position = element.get('position');
          model.name = element.get('name');
          model.personalNumber = element.get('personalNumber');
          model.businessNumber = element.get('businessNumber');
          model.image = element.get('image');
          model.createDate = element.get('createDate');
          model.direction = element.get('direction');
          model.email = element.get('email');

          model.assignedProperties = element.get('assignedProperties');
          model.propertyType = element.get('propertyType');
          model.specializedSector = element.get('specializedSector');
          model.emailVerified = element.get('emailVerified');
          workersList.add(model);
        }
      });

      return workersList;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<void> deleteEmployee(String id) async {
    //Delete a patient with the idPatient
    await workers
        .doc(id)
        .delete()
        .then((value) => log("Employee deleted"))
        .catchError((error) => log("❌Failed to deleted the employee: $error"));
  }

  Future updateEmployee(String id, EmployeeModel model) {
    //Update all patient object with the id and one patient model
    return workers
        .doc(id)
        .update({
          "id": model.id,
          "position": model.position,
          "name": model.name,
          "personalNumber": model.personalNumber,
          "businessNumber": model.businessNumber,
          "image": model.image,
          "createDate": model.createDate,
          "direction": model.direction,
          "email": model.email,
          "assignedProperties": model.assignedProperties,
          "propertyType": model.propertyType,
          "specializedSector": model.specializedSector,
          "emailVerified": model.emailVerified,
        })
        .then((value) => log("Employee update"))
        .catchError((error) => log("❌Failed to update Employee: $error"));
  }
}
