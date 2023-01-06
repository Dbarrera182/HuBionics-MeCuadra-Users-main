// Import the firebase_core and cloud_firestore plugin
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:me_cuadra_users/models/employee_model.dart';
import 'package:me_cuadra_users/models/user_model.dart';
import 'package:me_cuadra_users/preferences/user_preference.dart';

import '../../models/complement_models/auction_participan.dart';
import '../../models/complement_models/story_model.dart';
import '../../models/complement_models/visits_model.dart';
import '../../models/offer_model.dart';
import '../../models/residence_model.dart';

class ResidenceCrud {
  // Create a CollectionReference called residences that references the firestore collection
  CollectionReference residences =
      FirebaseFirestore.instance.collection('residences');

  Future<void> addResidence(
    ResidenceModel model,
  ) async {
    // Call the residence's CollectionReference to add a new modelResidence
    final residence = residences.doc();
    String id = residence.id;
    model.id = id;

    List<Map<String, dynamic>> stories = [];
    if (model.stories != null) {
      stories = model.stories!.map((e) => e.toMap()).toList();
    } else {
      stories = [Story().emptyMap()];
    }
    Map<String, dynamic> createFor = EmployeeModel().emptyMap();
    if (model.createFor != null) {
      createFor = model.createFor!.toMap();
    }

    List<Map<String, dynamic>> presentialVisits = [];
    if (model.presentialVisits != null) {
      presentialVisits = model.presentialVisits!.map((e) => e.toMap()).toList();
    } else {
      presentialVisits = [VisitsModel().emptyMap()];
    }

    List<Map<String, dynamic>> virtualVisits = [];
    if (model.virtualVisits != null) {
      virtualVisits = model.virtualVisits!.map((e) => e.toMap()).toList();
    } else {
      virtualVisits = [VisitsModel().emptyMap()];
    }

    List<Map<String, dynamic>> auctionParticipants = [];
    if (model.auctionParticipants != null) {
      auctionParticipants =
          model.auctionParticipants!.map((e) => e.toMap()).toList();
    } else {
      auctionParticipants = [AuctionParticipant().emptyMap()];
    }

    //List<Map<String, dynamic>> offerts = [];
    // if (model.offerts != null) {
    //   offerts = model.offerts!.map((e) => e.toMap()).toList();
    // } else {
    //   offerts = [OfertModel('', '', 0, 0, '').toMap()];
    // }

    await residence
        .set({
          'id': model.id,
          'idUser': model.idUser ?? "",
          'idSalesman': model.idSalesman ?? "",
          'idAuctioner': model.idAuctioner ?? "",
          'idAdminAssistant': model.idAdminAssistant ?? "",
          'idDocumentation': model.idDocumentation ?? "",
          'createFor': createFor,
          'ownerName': model.ownerName ?? [],
          'ownerPhoneNumber': model.ownerPhoneNumber ?? [],
          'ownerIdentification': model.ownerIdentification ?? [],
          'ownerEmail': model.ownerEmail ?? [],
          'stateInApp': model.stateInApp ?? "Solicitud",
          'applicationStatusDate':
              model.applicationStatusDate ?? DateTime.now().toString(),
          'creationStatusDate': model.creationStatusDate ?? "",
          'reviewStatusDate': model.reviewStatusDate ?? "",
          'publicationStatusDate': model.publicationStatusDate ?? "",
          'auctionStatusDate': model.auctionStatusDate ?? "",
          'documentationStatusDate': model.documentationStatusDate ?? "",
          'availability': model.availability ?? "",
          'managment': model.managment ?? 0,
          'price': model.price ?? 0,
          'area': model.area ?? 0,
          'room': model.room ?? 0,
          'bath': model.bath ?? 0,
          'garage': model.garage ?? 0,
          'buildersName': model.buildersName ?? "",
          'name': model.name ?? "",
          'neighborhood': model.neighborhood ?? "",
          'city': model.city ?? "",
          'state': model.state ?? "",
          'country': model.country ?? "",
          'typeOfResidence': model.typeOfResidence ?? "",
          'typeOfAuction': model.typeOfAuction ?? "",
          'condition': model.condition ?? "",
          'stratum': model.stratum ?? 0,
          'features': model.features ?? [],
          'featuresSVG': model.featuresSVG ?? [],
          'commonAreas': model.commonAreas ?? [],
          'commonAreasSVG': model.commonAreasSVG ?? [],
          'location': model.location ?? "",
          'nearbySpaces': model.nearbySpaces ?? [],
          'description': model.description ?? "",
          'stories': stories,
          'propertyNumber': model.propertyNumber ?? "",
          'constructedArea': model.constructedArea ?? 0,
          'lotArea': model.lotArea ?? 0,
          'levelsNumber': model.levelsNumber ?? 0,
          'constructedYear': model.constructedYear ?? 0,
          'specialFeatures': model.specialFeatures ?? [],
          'nearbyNeighborhoods': model.nearbyNeighborhoods ?? [],
          'ownerCity': model.ownerCity ?? "",
          'ownerState': model.ownerState ?? "",
          'ownerCountry': model.ownerCountry ?? "",
          'ownerDirection': model.ownerDirection ?? "",
          'baseAuctionPrice': model.baseAuctionPrice ?? 0,
          'valuePerM2': model.valuePerM2 ?? 0,
          'initialFee': model.initialFee ?? 0,
          'monthTerm': model.monthTerm ?? 0,
          'subsidy': model.subsidy ?? "",
          'preregistroFormObservations':
              model.preregistroFormObservations ?? "",
          'infraestructuraFormObservations':
              model.infraestructuraFormObservations ?? "",
          'informacionFormObservations':
              model.informacionFormObservations ?? "",
          'financionFormObservations': model.financionFormObservations ?? "",
          'agendaFormObservations': model.agendaFormObservations ?? "",
          'propietarioFormObservations':
              model.propietarioFormObservations ?? "",
          'auctionDate': model.auctionDate ?? "",
          'presentialVisits': presentialVisits,
          'virtualVisits': virtualVisits,
          'linkVirtualRoute': model.linkVirtualRoute ?? "",
          'nameAuctionRoom': model.nameAuctionRoom ?? "",
          'rejectedRequest': model.rejectedRequest ?? false,
          'auctionerName': model.auctionerName ?? "",
          'salesmanName': model.salesmanName ?? "",
          'adminAssistantName': model.adminAssistantName ?? "",
          'usersOfWhatsapp': model.usersOfWhatsapp ?? [],
          'auctionOrder': model.auctionOrder ?? 0,
          'auctionState': model.auctionState ?? "",
          'auctionLink': model.auctionLink ??
              "https://www.youtube.com/watch?v=OAl5NP6BPbE",
          'initAuctionTime': model.initAuctionTime ?? "",
          'finalAuctionTime': model.finalAuctionTime ?? "",
          'auctionParticipants': auctionParticipants,
          'isForm1': model.isForm1 ?? false,
          'isForm2': model.isForm2 ?? false,
          'isForm3': model.isForm3 ?? false,
          'isForm4': model.isForm4 ?? false,
          'isForm5': model.isForm5 ?? false,
          'isForm6': model.isForm6 ?? false,
          'auctionInitValue': model.auctionInitValue ?? 0,
          'auctionLastValue': model.auctionLastValue ?? 0,
          // 'offerts': offerts,
        })
        .then((value) => log("Residence Added"))
        .catchError((error) => log("❌Failed to add residence: $error"));
  }

  Future<void> addResidenceFromProfileUSer(
      ResidenceModel model, UserModel user) async {
    final residence = residences.doc();
    String id = residence.id;
    model.id = id;
    user.userProperties!.add(id);

    List<Map<String, dynamic>> stories = [];
    if (model.stories != null) {
      stories = model.stories!.map((e) => e.toMap()).toList();
    } else {
      stories = [Story().emptyMap()];
    }

    List<Map<String, dynamic>> presentialVisits = [];
    if (model.presentialVisits != null) {
      presentialVisits = model.presentialVisits!.map((e) => e.toMap()).toList();
    } else {
      presentialVisits = [VisitsModel().emptyMap()];
    }

    Map<String, dynamic> createFor = EmployeeModel().emptyMap();
    if (model.createFor != null) {
      createFor = model.createFor!.toMap();
    }

    List<Map<String, dynamic>> virtualVisits = [];
    if (model.virtualVisits != null) {
      virtualVisits = model.virtualVisits!.map((e) => e.toMap()).toList();
    } else {
      virtualVisits = [VisitsModel().emptyMap()];
    }

    List<Map<String, dynamic>> auctionParticipants = [];
    if (model.auctionParticipants != null) {
      auctionParticipants =
          model.auctionParticipants!.map((e) => e.toMap()).toList();
    } else {
      auctionParticipants = [AuctionParticipant().emptyMap()];
    }

    //List<Map<String, dynamic>> offerts = [];
    // if (model.offerts != null) {
    //   offerts = model.offerts!.map((e) => e.toMap()).toList();
    // } else {
    //   offerts = [OfertModel('', '', 0, 0, '').toMap()];
    // }

    await residence
        .set({
          'id': model.id,
          'idUser': model.idUser ?? "",
          'idSalesman': model.idSalesman ?? "",
          'idAuctioner': model.idAuctioner ?? "",
          'idAdminAssistant': model.idAdminAssistant ?? "",
          'idDocumentation': model.idDocumentation ?? "",
          'createFor': createFor,
          'ownerName': model.ownerName ?? [],
          'ownerPhoneNumber': model.ownerPhoneNumber ?? [],
          'ownerIdentification': model.ownerIdentification ?? [],
          'ownerEmail': model.ownerEmail ?? [],
          'stateInApp': model.stateInApp ?? "Solicitud",
          'applicationStatusDate':
              model.applicationStatusDate ?? DateTime.now().toString(),
          'creationStatusDate': model.creationStatusDate ?? "",
          'reviewStatusDate': model.reviewStatusDate ?? "",
          'publicationStatusDate': model.publicationStatusDate ?? "",
          'auctionStatusDate': model.auctionStatusDate ?? "",
          'documentationStatusDate': model.documentationStatusDate ?? "",
          'availability': model.availability ?? "",
          'managment': model.managment ?? 0,
          'price': model.price ?? 0,
          'area': model.area ?? 0,
          'room': model.room ?? 0,
          'bath': model.bath ?? 0,
          'garage': model.garage ?? 0,
          'buildersName': model.buildersName ?? "",
          'name': model.name ?? "",
          'neighborhood': model.neighborhood ?? "",
          'city': model.city ?? "",
          'state': model.state ?? "",
          'country': model.country ?? "",
          'typeOfResidence': model.typeOfResidence ?? "",
          'typeOfAuction': model.typeOfAuction ?? "",
          'condition': model.condition ?? "",
          'stratum': model.stratum ?? 0,
          'features': model.features ?? [],
          'featuresSVG': model.featuresSVG ?? [],
          'commonAreas': model.commonAreas ?? [],
          'commonAreasSVG': model.commonAreasSVG ?? [],
          'location': model.location ?? "",
          'nearbySpaces': model.nearbySpaces ?? [],
          'description': model.description ?? "",
          'stories': stories,
          'propertyNumber': model.propertyNumber ?? "",
          'constructedArea': model.constructedArea ?? 0,
          'lotArea': model.lotArea ?? 0,
          'levelsNumber': model.levelsNumber ?? 0,
          'constructedYear': model.constructedYear ?? 0,
          'specialFeatures': model.specialFeatures ?? [],
          'nearbyNeighborhoods': model.nearbyNeighborhoods ?? [],
          'ownerCity': model.ownerCity ?? "",
          'ownerState': model.ownerState ?? "",
          'ownerCountry': model.ownerCountry ?? "",
          'ownerDirection': model.ownerDirection ?? "",
          'baseAuctionPrice': model.baseAuctionPrice ?? 0,
          'valuePerM2': model.valuePerM2 ?? 0,
          'initialFee': model.initialFee ?? 0,
          'monthTerm': model.monthTerm ?? 0,
          'subsidy': model.subsidy ?? "",
          'preregistroFormObservations':
              model.preregistroFormObservations ?? "",
          'infraestructuraFormObservations':
              model.infraestructuraFormObservations ?? "",
          'informacionFormObservations':
              model.informacionFormObservations ?? "",
          'financionFormObservations': model.financionFormObservations ?? "",
          'agendaFormObservations': model.agendaFormObservations ?? "",
          'propietarioFormObservations':
              model.propietarioFormObservations ?? "",
          'auctionDate': model.auctionDate ?? "",
          'presentialVisits': presentialVisits,
          'virtualVisits': virtualVisits,
          'linkVirtualRoute': model.linkVirtualRoute ?? "",
          'nameAuctionRoom': model.nameAuctionRoom ?? "",
          'rejectedRequest': model.rejectedRequest ?? false,
          'auctionerName': model.auctionerName ?? "",
          'salesmanName': model.salesmanName ?? "",
          'adminAssistantName': model.adminAssistantName ?? "",
          'usersOfWhatsapp': model.usersOfWhatsapp ?? [],
          'auctionOrder': model.auctionOrder ?? 0,
          'auctionState': model.auctionState ?? "",
          'auctionLink': model.auctionLink ??
              "https://www.youtube.com/watch?v=OAl5NP6BPbE",
          'initAuctionTime': model.initAuctionTime ?? "",
          'finalAuctionTime': model.finalAuctionTime ?? "",
          'auctionParticipants': auctionParticipants,
          'isForm1': model.isForm1 ?? false,
          'isForm2': model.isForm2 ?? false,
          'isForm3': model.isForm3 ?? false,
          'isForm4': model.isForm4 ?? false,
          'isForm5': model.isForm5 ?? false,
          'isForm6': model.isForm6 ?? false,
          'auctionInitValue': model.auctionInitValue ?? 0,
          'auctionLastValue': model.auctionLastValue ?? 0,
          // 'offerts': offerts,
        })
        .then((value) => UserPreferences().saveData(user))
        .catchError((error) => log("❌Failed to add residence: $error"));
  }

  Future<ResidenceModel> getResidence(String id) async {
    //Get a residence model for the idResidence
    ResidenceModel model = ResidenceModel();
    await residences
        .where('id'.trim(), isEqualTo: id.trim())
        .get()
        .then((querySnapshot) {
      for (var element in querySnapshot.docs) {
        model.id = element.get('id');
        model.idUser = element.get('idUser');
        model.idSalesman = element.get('idSalesman');
        model.idAuctioner = element.get('idAuctioner');
        model.idAdminAssistant = element.get('idAdminAssistant');
        model.idDocumentation = element.get('idDocumentation');
        model.createFor = dynamicToEmployee(element.get('createFor'));
        model.ownerName = listDynamicToString(element.get('ownerName'));
        model.ownerPhoneNumber =
            listDynamicToString(element.get('ownerPhoneNumber'));
        model.ownerIdentification =
            listDynamicToString(element.get('ownerIdentification'));
        model.ownerEmail = listDynamicToString(element.get('ownerEmail'));
        model.stateInApp = element.get('stateInApp');
        model.applicationStatusDate = element.get('applicationStatusDate');
        model.creationStatusDate = element.get('creationStatusDate');
        model.reviewStatusDate = element.get('reviewStatusDate');
        model.publicationStatusDate = element.get('publicationStatusDate');
        model.auctionStatusDate = element.get('auctionStatusDate');
        model.documentationStatusDate = element.get('documentationStatusDate');
        model.availability = element.get('availability');
        model.managment = element.get('managment');
        model.price = element.get('price');
        model.area = element.get('area');
        model.room = element.get('room');
        model.bath = element.get('bath');
        model.garage = element.get('garage');
        model.buildersName = element.get('buildersName');
        model.name = element.get('name');
        model.neighborhood = element.get('neighborhood');
        model.city = element.get('city');
        model.state = element.get('state');
        model.country = element.get('country');
        model.typeOfResidence = element.get('typeOfResidence');
        model.typeOfAuction = element.get('typeOfAuction');
        model.condition = element.get('condition');
        model.stratum = element.get('stratum');
        model.features = listDynamicToString(element.get('features'));
        model.featuresSVG = listDynamicToString(element.get('featuresSVG'));
        model.commonAreas = listDynamicToString(element.get('commonAreas'));
        model.commonAreasSVG =
            listDynamicToString(element.get('commonAreasSVG'));
        model.location = element.get('location');
        model.nearbySpaces = listDynamicToString(element.get('nearbySpaces'));
        model.description = element.get('description');
        model.stories = listDynamicToStory(element.get('stories'));
        model.propertyNumber = element.get('propertyNumber');
        model.constructedArea = element.get('constructedArea');
        model.lotArea = element.get('lotArea');
        model.levelsNumber = element.get('levelsNumber');
        model.constructedYear = element.get('constructedYear');
        model.specialFeatures =
            listDynamicToString(element.get('specialFeatures'));
        model.nearbyNeighborhoods =
            listDynamicToString(element.get('nearbyNeighborhoods'));
        model.ownerCity = element.get('ownerCity');
        model.ownerCountry = element.get('ownerCountry');
        model.ownerState = element.get('ownerState');
        model.ownerDirection = element.get('ownerDirection');
        model.baseAuctionPrice = element.get('baseAuctionPrice');
        model.valuePerM2 = element.get('valuePerM2');
        model.subsidy = element.get('subsidy');
        model.initialFee = element.get('initialFee');
        model.monthTerm = element.get('monthTerm');
        model.preregistroFormObservations =
            element.get('preregistroFormObservations');
        model.infraestructuraFormObservations =
            element.get('infraestructuraFormObservations');
        model.informacionFormObservations =
            element.get('informacionFormObservations');
        model.financionFormObservations =
            element.get('financionFormObservations');
        model.agendaFormObservations = element.get('agendaFormObservations');
        model.propietarioFormObservations =
            element.get('propietarioFormObservations');
        model.auctionDate = element.get('auctionDate');
        model.presentialVisits =
            listDynamicToScheduleVisit(element.get('presentialVisits'));
        model.virtualVisits =
            listDynamicToScheduleVisit(element.get('virtualVisits'));
        model.linkVirtualRoute = element.get('linkVirtualRoute');
        model.nameAuctionRoom = element.get('nameAuctionRoom');
        model.rejectedRequest = element.get('rejectedRequest');
        model.auctionerName = element.get('auctionerName');
        model.salesmanName = element.get('salesmanName');
        model.adminAssistantName = element.get('adminAssistantName');
        model.usersOfWhatsapp =
            listDynamicToString(element.get('usersOfWhatsapp'));
        model.auctionOrder = element.get('auctionOrder');
        model.auctionState = element.get('auctionState');
        model.auctionLink = element.get('auctionLink');
        model.initAuctionTime = element.get('initAuctionTime');
        model.finalAuctionTime = element.get('finalAuctionTime');
        model.auctionParticipants =
            listDynamicToAuctionParticipant(element.get('auctionParticipants'));
        model.isForm1 = element.get('isForm1');
        model.isForm2 = element.get('isForm2');
        model.isForm3 = element.get('isForm3');
        model.isForm4 = element.get('isForm4');
        model.isForm5 = element.get('isForm5');
        model.isForm6 = element.get('isForm6');
        model.auctionInitValue = element.get('auctionInitValue');
        model.auctionLastValue = element.get('auctionLastValue');
        // model.offerts = listDynamicToOffer(element.get('offerts'));
      }
    }).then((value) {
      log("🆗  get Residence for id Residences");
    });
    return model;
  }

  Future<List<OfferModel>> getOffers(String id) async {
    //Get a residence model for the idResidence
    ResidenceModel model = ResidenceModel();
    List<OfferModel> offers = [];
    await residences
        .where('id'.trim(), isEqualTo: id.trim())
        .get()
        .then((querySnapshot) {
      for (var element in querySnapshot.docs) {
        model.id = element.get('id');
        model.idUser = element.get('idUser');
        model.idSalesman = element.get('idSalesman');
        model.idAuctioner = element.get('idAuctioner');
        model.idAdminAssistant = element.get('idAdminAssistant');
        model.idDocumentation = element.get('idDocumentation');
        model.createFor = dynamicToEmployee(element.get('createFor'));
        model.ownerName = listDynamicToString(element.get('ownerName'));
        model.ownerPhoneNumber =
            listDynamicToString(element.get('ownerPhoneNumber'));
        model.ownerIdentification =
            listDynamicToString(element.get('ownerIdentification'));
        model.ownerEmail = listDynamicToString(element.get('ownerEmail'));
        model.stateInApp = element.get('stateInApp');
        model.applicationStatusDate = element.get('applicationStatusDate');
        model.creationStatusDate = element.get('creationStatusDate');
        model.reviewStatusDate = element.get('reviewStatusDate');
        model.publicationStatusDate = element.get('publicationStatusDate');
        model.auctionStatusDate = element.get('auctionStatusDate');
        model.documentationStatusDate = element.get('documentationStatusDate');
        model.availability = element.get('availability');
        model.managment = element.get('managment');
        model.price = element.get('price');
        model.area = element.get('area');
        model.room = element.get('room');
        model.bath = element.get('bath');
        model.garage = element.get('garage');
        model.buildersName = element.get('buildersName');
        model.name = element.get('name');
        model.neighborhood = element.get('neighborhood');
        model.city = element.get('city');
        model.state = element.get('state');
        model.country = element.get('country');
        model.typeOfResidence = element.get('typeOfResidence');
        model.typeOfAuction = element.get('typeOfAuction');
        model.condition = element.get('condition');
        model.stratum = element.get('stratum');
        model.features = listDynamicToString(element.get('features'));
        model.featuresSVG = listDynamicToString(element.get('featuresSVG'));
        model.commonAreas = listDynamicToString(element.get('commonAreas'));
        model.commonAreasSVG =
            listDynamicToString(element.get('commonAreasSVG'));
        model.location = element.get('location');
        model.nearbySpaces = listDynamicToString(element.get('nearbySpaces'));
        model.description = element.get('description');
        model.stories = listDynamicToStory(element.get('stories'));
        model.propertyNumber = element.get('propertyNumber');
        model.constructedArea = element.get('constructedArea');
        model.lotArea = element.get('lotArea');
        model.levelsNumber = element.get('levelsNumber');
        model.constructedYear = element.get('constructedYear');
        model.specialFeatures =
            listDynamicToString(element.get('specialFeatures'));
        model.nearbyNeighborhoods =
            listDynamicToString(element.get('nearbyNeighborhoods'));
        model.ownerCity = element.get('ownerCity');
        model.ownerCountry = element.get('ownerCountry');
        model.ownerState = element.get('ownerState');
        model.ownerDirection = element.get('ownerDirection');
        model.baseAuctionPrice = element.get('baseAuctionPrice');
        model.valuePerM2 = element.get('valuePerM2');
        model.subsidy = element.get('subsidy');
        model.initialFee = element.get('initialFee');
        model.monthTerm = element.get('monthTerm');
        model.preregistroFormObservations =
            element.get('preregistroFormObservations');
        model.infraestructuraFormObservations =
            element.get('infraestructuraFormObservations');
        model.informacionFormObservations =
            element.get('informacionFormObservations');
        model.financionFormObservations =
            element.get('financionFormObservations');
        model.agendaFormObservations = element.get('agendaFormObservations');
        model.propietarioFormObservations =
            element.get('propietarioFormObservations');
        model.auctionDate = element.get('auctionDate');
        model.presentialVisits =
            listDynamicToScheduleVisit(element.get('presentialVisits'));
        model.virtualVisits =
            listDynamicToScheduleVisit(element.get('virtualVisits'));
        model.linkVirtualRoute = element.get('linkVirtualRoute');
        model.nameAuctionRoom = element.get('nameAuctionRoom');
        model.rejectedRequest = element.get('rejectedRequest');
        model.auctionerName = element.get('auctionerName');
        model.salesmanName = element.get('salesmanName');
        model.adminAssistantName = element.get('adminAssistantName');
        model.usersOfWhatsapp =
            listDynamicToString(element.get('usersOfWhatsapp'));
        model.auctionOrder = element.get('auctionOrder');
        model.auctionState = element.get('auctionState');
        model.auctionLink = element.get('auctionLink');
        model.initAuctionTime = element.get('initAuctionTime');
        model.finalAuctionTime = element.get('finalAuctionTime');
        model.auctionParticipants =
            listDynamicToAuctionParticipant(element.get('auctionParticipants'));
        model.isForm1 = element.get('isForm1');
        model.isForm2 = element.get('isForm2');
        model.isForm3 = element.get('isForm3');
        model.isForm4 = element.get('isForm4');
        model.isForm5 = element.get('isForm5');
        model.isForm6 = element.get('isForm6');
        model.auctionInitValue = element.get('auctionInitValue');
        model.auctionLastValue = element.get('auctionLastValue');
        // model.offerts = listDynamicToOffer(element.get('offerts'));
        // offers = model.offerts!}
      }
    }).then((value) {
      log("🆗  get Residence for id Residences");
    });
    return offers;
  }

  Future<List<ResidenceModel>> getAllResidences() async {
    //Get residences of any adviser
    List<ResidenceModel> residenceList = [];
    try {
      await residences
          .where('stateInApp'.trim(), isNotEqualTo: '')
          .get()
          .then((querySnapshot) {
        for (var element in querySnapshot.docs) {
          ResidenceModel model = ResidenceModel();
          model.id = element.get('id');
          model.idUser = element.get('idUser');
          model.idSalesman = element.get('idSalesman');
          model.idAuctioner = element.get('idAuctioner');
          model.idAdminAssistant = element.get('idAdminAssistant');
          model.idDocumentation = element.get('idDocumentation');
          model.createFor = dynamicToEmployee(element.get('createFor'));
          model.ownerName = listDynamicToString(element.get('ownerName'));
          model.ownerPhoneNumber =
              listDynamicToString(element.get('ownerPhoneNumber'));
          model.ownerIdentification =
              listDynamicToString(element.get('ownerIdentification'));
          model.ownerEmail = listDynamicToString(element.get('ownerEmail'));
          model.stateInApp = element.get('stateInApp');
          model.applicationStatusDate = element.get('applicationStatusDate');
          model.creationStatusDate = element.get('creationStatusDate');
          model.reviewStatusDate = element.get('reviewStatusDate');
          model.publicationStatusDate = element.get('publicationStatusDate');
          model.auctionStatusDate = element.get('auctionStatusDate');
          model.documentationStatusDate =
              element.get('documentationStatusDate');
          model.availability = element.get('availability');
          model.managment = element.get('managment');
          model.price = element.get('price');
          model.area = element.get('area');
          model.room = element.get('room');
          model.bath = element.get('bath');
          model.garage = element.get('garage');
          model.buildersName = element.get('buildersName');
          model.name = element.get('name');
          model.neighborhood = element.get('neighborhood');
          model.city = element.get('city');
          model.state = element.get('state');
          model.country = element.get('country');
          model.typeOfResidence = element.get('typeOfResidence');
          model.typeOfAuction = element.get('typeOfAuction');
          model.condition = element.get('condition');
          model.stratum = element.get('stratum');
          model.features = listDynamicToString(element.get('features'));
          model.featuresSVG = listDynamicToString(element.get('featuresSVG'));
          model.commonAreas = listDynamicToString(element.get('commonAreas'));
          model.commonAreasSVG =
              listDynamicToString(element.get('commonAreasSVG'));
          model.location = element.get('location');
          model.nearbySpaces = listDynamicToString(element.get('nearbySpaces'));
          model.description = element.get('description');
          model.stories = listDynamicToStory(element.get('stories'));
          model.propertyNumber = element.get('propertyNumber');
          model.constructedArea = element.get('constructedArea');
          model.lotArea = element.get('lotArea');
          model.levelsNumber = element.get('levelsNumber');
          model.constructedYear = element.get('constructedYear');
          model.specialFeatures =
              listDynamicToString(element.get('specialFeatures'));
          model.nearbyNeighborhoods =
              listDynamicToString(element.get('nearbyNeighborhoods'));
          model.ownerCity = element.get('ownerCity');
          model.ownerCountry = element.get('ownerCountry');
          model.ownerState = element.get('ownerState');
          model.ownerDirection = element.get('ownerDirection');
          model.baseAuctionPrice = element.get('baseAuctionPrice');
          model.valuePerM2 = element.get('valuePerM2');
          model.subsidy = element.get('subsidy');
          model.initialFee = element.get('initialFee');
          model.monthTerm = element.get('monthTerm');
          model.preregistroFormObservations =
              element.get('preregistroFormObservations');
          model.infraestructuraFormObservations =
              element.get('infraestructuraFormObservations');
          model.informacionFormObservations =
              element.get('informacionFormObservations');
          model.financionFormObservations =
              element.get('financionFormObservations');
          model.agendaFormObservations = element.get('agendaFormObservations');
          model.propietarioFormObservations =
              element.get('propietarioFormObservations');
          model.auctionDate = element.get('auctionDate');
          model.presentialVisits =
              listDynamicToScheduleVisit(element.get('presentialVisits'));
          model.virtualVisits =
              listDynamicToScheduleVisit(element.get('virtualVisits'));
          model.linkVirtualRoute = element.get('linkVirtualRoute');
          model.nameAuctionRoom = element.get('nameAuctionRoom');
          model.rejectedRequest = element.get('rejectedRequest');
          model.auctionerName = element.get('auctionerName');
          model.salesmanName = element.get('salesmanName');
          model.adminAssistantName = element.get('adminAssistantName');
          model.usersOfWhatsapp =
              listDynamicToString(element.get('usersOfWhatsapp'));
          model.auctionOrder = element.get('auctionOrder');
          model.auctionState = element.get('auctionState');
          model.auctionLink = element.get('auctionLink');
          model.initAuctionTime = element.get('initAuctionTime');
          model.finalAuctionTime = element.get('finalAuctionTime');
          model.auctionParticipants = listDynamicToAuctionParticipant(
              element.get('auctionParticipants'));
          model.isForm1 = element.get('isForm1');
          model.isForm2 = element.get('isForm2');
          model.isForm3 = element.get('isForm3');
          model.isForm4 = element.get('isForm4');
          model.isForm5 = element.get('isForm5');
          model.isForm6 = element.get('isForm6');
          model.auctionInitValue = element.get('auctionInitValue');
          model.auctionLastValue = element.get('auctionLastValue');
          // model.offerts = listDynamicToOffer(element.get('offerts'));

          residenceList.add(model);
        }
      });
      return residenceList;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return [];
    }
  }

  Future<List<ResidenceModel>> getResidencesOfUser(String idUser) async {
    //Get residences of any adviser
    List<ResidenceModel> residenceList = [];
    List<ResidenceModel> residencePublished = [];
    try {
      await residences
          .where('idUser'.trim(), isEqualTo: idUser.toString().trim())
          .get()
          .then((querySnapshot) {
        for (var element in querySnapshot.docs) {
          ResidenceModel model = ResidenceModel();
          model.id = element.get('id');
          model.idUser = element.get('idUser');
          model.idSalesman = element.get('idSalesman');
          model.idAuctioner = element.get('idAuctioner');
          model.idAdminAssistant = element.get('idAdminAssistant');
          model.idDocumentation = element.get('idDocumentation');
          model.createFor = dynamicToEmployee(element.get('createFor'));
          model.ownerName = listDynamicToString(element.get('ownerName'));
          model.ownerPhoneNumber =
              listDynamicToString(element.get('ownerPhoneNumber'));
          model.ownerIdentification =
              listDynamicToString(element.get('ownerIdentification'));
          model.ownerEmail = listDynamicToString(element.get('ownerEmail'));
          model.stateInApp = element.get('stateInApp');
          model.applicationStatusDate = element.get('applicationStatusDate');
          model.creationStatusDate = element.get('creationStatusDate');
          model.reviewStatusDate = element.get('reviewStatusDate');
          model.publicationStatusDate = element.get('publicationStatusDate');
          model.auctionStatusDate = element.get('auctionStatusDate');
          model.documentationStatusDate =
              element.get('documentationStatusDate');
          model.availability = element.get('availability');
          model.managment = element.get('managment');
          model.price = element.get('price');
          model.area = element.get('area');
          model.room = element.get('room');
          model.bath = element.get('bath');
          model.garage = element.get('garage');
          model.buildersName = element.get('buildersName');
          model.name = element.get('name');
          model.neighborhood = element.get('neighborhood');
          model.city = element.get('city');
          model.state = element.get('state');
          model.country = element.get('country');
          model.typeOfResidence = element.get('typeOfResidence');
          model.typeOfAuction = element.get('typeOfAuction');
          model.condition = element.get('condition');
          model.stratum = element.get('stratum');
          model.features = listDynamicToString(element.get('features'));
          model.featuresSVG = listDynamicToString(element.get('featuresSVG'));
          model.commonAreas = listDynamicToString(element.get('commonAreas'));
          model.commonAreasSVG =
              listDynamicToString(element.get('commonAreasSVG'));
          model.location = element.get('location');
          model.nearbySpaces = listDynamicToString(element.get('nearbySpaces'));
          model.description = element.get('description');
          model.stories = listDynamicToStory(element.get('stories'));
          model.propertyNumber = element.get('propertyNumber');
          model.constructedArea = element.get('constructedArea');
          model.lotArea = element.get('lotArea');
          model.levelsNumber = element.get('levelsNumber');
          model.constructedYear = element.get('constructedYear');
          model.specialFeatures =
              listDynamicToString(element.get('specialFeatures'));
          model.nearbyNeighborhoods =
              listDynamicToString(element.get('nearbyNeighborhoods'));
          model.ownerCity = element.get('ownerCity');
          model.ownerCountry = element.get('ownerCountry');
          model.ownerState = element.get('ownerState');
          model.ownerDirection = element.get('ownerDirection');
          model.baseAuctionPrice = element.get('baseAuctionPrice');
          model.valuePerM2 = element.get('valuePerM2');
          model.subsidy = element.get('subsidy');
          model.initialFee = element.get('initialFee');
          model.monthTerm = element.get('monthTerm');
          model.preregistroFormObservations =
              element.get('preregistroFormObservations');
          model.infraestructuraFormObservations =
              element.get('infraestructuraFormObservations');
          model.informacionFormObservations =
              element.get('informacionFormObservations');
          model.financionFormObservations =
              element.get('financionFormObservations');
          model.agendaFormObservations = element.get('agendaFormObservations');
          model.propietarioFormObservations =
              element.get('propietarioFormObservations');
          model.auctionDate = element.get('auctionDate');
          model.presentialVisits =
              listDynamicToScheduleVisit(element.get('presentialVisits'));
          model.virtualVisits =
              listDynamicToScheduleVisit(element.get('virtualVisits'));
          model.linkVirtualRoute = element.get('linkVirtualRoute');
          model.nameAuctionRoom = element.get('nameAuctionRoom');
          model.rejectedRequest = element.get('rejectedRequest');
          model.auctionerName = element.get('auctionerName');
          model.salesmanName = element.get('salesmanName');
          model.adminAssistantName = element.get('adminAssistantName');
          model.usersOfWhatsapp =
              listDynamicToString(element.get('usersOfWhatsapp'));
          model.auctionOrder = element.get('auctionOrder');
          model.auctionState = element.get('auctionState');
          model.auctionLink = element.get('auctionLink');
          model.initAuctionTime = element.get('initAuctionTime');
          model.finalAuctionTime = element.get('finalAuctionTime');
          model.auctionParticipants = listDynamicToAuctionParticipant(
              element.get('auctionParticipants'));
          model.isForm1 = element.get('isForm1');
          model.isForm2 = element.get('isForm2');
          model.isForm3 = element.get('isForm3');
          model.isForm4 = element.get('isForm4');
          model.isForm5 = element.get('isForm5');
          model.isForm6 = element.get('isForm6');
          model.auctionInitValue = element.get('auctionInitValue');
          model.auctionLastValue = element.get('auctionLastValue');
          // model.offerts = listDynamicToOffer(element.get('offerts'));
          residenceList.add(model);
        }
      });
      return residencePublished;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return [];
    }
  }

  Future<List<ResidenceModel>> getResidencesOfAuctionDate(
      String aucDate) async {
    //Get residences of any adviser
    List<ResidenceModel> residenceList = [];
    List<ResidenceModel> residencePublished = [];
    try {
      await residences
          .where('auctionDate'.trim(), isEqualTo: aucDate.toString().trim())
          .get()
          .then((querySnapshot) {
        for (var element in querySnapshot.docs) {
          ResidenceModel model = ResidenceModel();
          model.id = element.get('id');
          model.idUser = element.get('idUser');
          model.idSalesman = element.get('idSalesman');
          model.idAuctioner = element.get('idAuctioner');
          model.idAdminAssistant = element.get('idAdminAssistant');
          model.idDocumentation = element.get('idDocumentation');
          model.createFor = dynamicToEmployee(element.get('createFor'));
          model.ownerName = listDynamicToString(element.get('ownerName'));
          model.ownerPhoneNumber =
              listDynamicToString(element.get('ownerPhoneNumber'));
          model.ownerIdentification =
              listDynamicToString(element.get('ownerIdentification'));
          model.ownerEmail = listDynamicToString(element.get('ownerEmail'));
          model.stateInApp = element.get('stateInApp');
          model.applicationStatusDate = element.get('applicationStatusDate');
          model.creationStatusDate = element.get('creationStatusDate');
          model.reviewStatusDate = element.get('reviewStatusDate');
          model.publicationStatusDate = element.get('publicationStatusDate');
          model.auctionStatusDate = element.get('auctionStatusDate');
          model.documentationStatusDate =
              element.get('documentationStatusDate');
          model.availability = element.get('availability');
          model.managment = element.get('managment');
          model.price = element.get('price');
          model.area = element.get('area');
          model.room = element.get('room');
          model.bath = element.get('bath');
          model.garage = element.get('garage');
          model.buildersName = element.get('buildersName');
          model.name = element.get('name');
          model.neighborhood = element.get('neighborhood');
          model.city = element.get('city');
          model.state = element.get('state');
          model.country = element.get('country');
          model.typeOfResidence = element.get('typeOfResidence');
          model.typeOfAuction = element.get('typeOfAuction');
          model.condition = element.get('condition');
          model.stratum = element.get('stratum');
          model.features = listDynamicToString(element.get('features'));
          model.featuresSVG = listDynamicToString(element.get('featuresSVG'));
          model.commonAreas = listDynamicToString(element.get('commonAreas'));
          model.commonAreasSVG =
              listDynamicToString(element.get('commonAreasSVG'));
          model.location = element.get('location');
          model.nearbySpaces = listDynamicToString(element.get('nearbySpaces'));
          model.description = element.get('description');
          model.stories = listDynamicToStory(element.get('stories'));
          model.propertyNumber = element.get('propertyNumber');
          model.constructedArea = element.get('constructedArea');
          model.lotArea = element.get('lotArea');
          model.levelsNumber = element.get('levelsNumber');
          model.constructedYear = element.get('constructedYear');
          model.specialFeatures =
              listDynamicToString(element.get('specialFeatures'));
          model.nearbyNeighborhoods =
              listDynamicToString(element.get('nearbyNeighborhoods'));
          model.ownerCity = element.get('ownerCity');
          model.ownerCountry = element.get('ownerCountry');
          model.ownerState = element.get('ownerState');
          model.ownerDirection = element.get('ownerDirection');
          model.baseAuctionPrice = element.get('baseAuctionPrice');
          model.valuePerM2 = element.get('valuePerM2');
          model.subsidy = element.get('subsidy');
          model.initialFee = element.get('initialFee');
          model.monthTerm = element.get('monthTerm');
          model.preregistroFormObservations =
              element.get('preregistroFormObservations');
          model.infraestructuraFormObservations =
              element.get('infraestructuraFormObservations');
          model.informacionFormObservations =
              element.get('informacionFormObservations');
          model.financionFormObservations =
              element.get('financionFormObservations');
          model.agendaFormObservations = element.get('agendaFormObservations');
          model.propietarioFormObservations =
              element.get('propietarioFormObservations');
          model.auctionDate = element.get('auctionDate');
          model.presentialVisits =
              listDynamicToScheduleVisit(element.get('presentialVisits'));
          model.virtualVisits =
              listDynamicToScheduleVisit(element.get('virtualVisits'));
          model.linkVirtualRoute = element.get('linkVirtualRoute');
          model.nameAuctionRoom = element.get('nameAuctionRoom');
          model.rejectedRequest = element.get('rejectedRequest');
          model.auctionerName = element.get('auctionerName');
          model.salesmanName = element.get('salesmanName');
          model.adminAssistantName = element.get('adminAssistantName');
          model.usersOfWhatsapp =
              listDynamicToString(element.get('usersOfWhatsapp'));
          model.auctionOrder = element.get('auctionOrder');
          model.auctionState = element.get('auctionState');
          model.auctionLink = element.get('auctionLink');
          model.initAuctionTime = element.get('initAuctionTime');
          model.finalAuctionTime = element.get('finalAuctionTime');
          model.auctionParticipants = listDynamicToAuctionParticipant(
              element.get('auctionParticipants'));
          model.isForm1 = element.get('isForm1');
          model.isForm2 = element.get('isForm2');
          model.isForm3 = element.get('isForm3');
          model.isForm4 = element.get('isForm4');
          model.isForm5 = element.get('isForm5');
          model.isForm6 = element.get('isForm6');
          model.auctionInitValue = element.get('auctionInitValue');
          model.auctionLastValue = element.get('auctionLastValue');
          // model.offerts = listDynamicToOffer(element.get('offerts'));

          residenceList.add(model);
        }
        for (var e in residenceList) {
          if (e.stateInApp == 'Publicada') {
            residencePublished.add(e);
          }
        }
      });
      return residencePublished;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return [];
    }
  }

  Future<List<ResidenceModel>> getResidencesOfSalesman(
      String idSalesman) async {
    //Get residences of any adviser
    List<ResidenceModel> residenceList = [];

    try {
      await residences
          .where('idSalesman'.trim(), isEqualTo: idSalesman.toString().trim())
          .get()
          .then((querySnapshot) {
        for (var element in querySnapshot.docs) {
          ResidenceModel model = ResidenceModel();
          model.id = element.get('id');
          model.idUser = element.get('idUser');
          model.idSalesman = element.get('idSalesman');
          model.idAuctioner = element.get('idAuctioner');
          model.idAdminAssistant = element.get('idAdminAssistant');
          model.idDocumentation = element.get('idDocumentation');
          model.createFor = dynamicToEmployee(element.get('createFor'));
          model.ownerName = listDynamicToString(element.get('ownerName'));
          model.ownerPhoneNumber =
              listDynamicToString(element.get('ownerPhoneNumber'));
          model.ownerIdentification =
              listDynamicToString(element.get('ownerIdentification'));
          model.ownerEmail = listDynamicToString(element.get('ownerEmail'));
          model.stateInApp = element.get('stateInApp');
          model.applicationStatusDate = element.get('applicationStatusDate');
          model.creationStatusDate = element.get('creationStatusDate');
          model.reviewStatusDate = element.get('reviewStatusDate');
          model.publicationStatusDate = element.get('publicationStatusDate');
          model.auctionStatusDate = element.get('auctionStatusDate');
          model.documentationStatusDate =
              element.get('documentationStatusDate');
          model.availability = element.get('availability');
          model.managment = element.get('managment');
          model.price = element.get('price');
          model.area = element.get('area');
          model.room = element.get('room');
          model.bath = element.get('bath');
          model.garage = element.get('garage');
          model.buildersName = element.get('buildersName');
          model.name = element.get('name');
          model.neighborhood = element.get('neighborhood');
          model.city = element.get('city');
          model.state = element.get('state');
          model.country = element.get('country');
          model.typeOfResidence = element.get('typeOfResidence');
          model.typeOfAuction = element.get('typeOfAuction');
          model.condition = element.get('condition');
          model.stratum = element.get('stratum');
          model.features = listDynamicToString(element.get('features'));
          model.featuresSVG = listDynamicToString(element.get('featuresSVG'));
          model.commonAreas = listDynamicToString(element.get('commonAreas'));
          model.commonAreasSVG =
              listDynamicToString(element.get('commonAreasSVG'));
          model.location = element.get('location');
          model.nearbySpaces = listDynamicToString(element.get('nearbySpaces'));
          model.description = element.get('description');
          model.stories = listDynamicToStory(element.get('stories'));
          model.propertyNumber = element.get('propertyNumber');
          model.constructedArea = element.get('constructedArea');
          model.lotArea = element.get('lotArea');
          model.levelsNumber = element.get('levelsNumber');
          model.constructedYear = element.get('constructedYear');
          model.specialFeatures =
              listDynamicToString(element.get('specialFeatures'));
          model.nearbyNeighborhoods =
              listDynamicToString(element.get('nearbyNeighborhoods'));
          model.ownerCity = element.get('ownerCity');
          model.ownerCountry = element.get('ownerCountry');
          model.ownerState = element.get('ownerState');
          model.ownerDirection = element.get('ownerDirection');
          model.baseAuctionPrice = element.get('baseAuctionPrice');
          model.valuePerM2 = element.get('valuePerM2');
          model.subsidy = element.get('subsidy');
          model.initialFee = element.get('initialFee');
          model.monthTerm = element.get('monthTerm');
          model.preregistroFormObservations =
              element.get('preregistroFormObservations');
          model.infraestructuraFormObservations =
              element.get('infraestructuraFormObservations');
          model.informacionFormObservations =
              element.get('informacionFormObservations');
          model.financionFormObservations =
              element.get('financionFormObservations');
          model.agendaFormObservations = element.get('agendaFormObservations');
          model.propietarioFormObservations =
              element.get('propietarioFormObservations');
          model.auctionDate = element.get('auctionDate');
          model.presentialVisits =
              listDynamicToScheduleVisit(element.get('presentialVisits'));
          model.virtualVisits =
              listDynamicToScheduleVisit(element.get('virtualVisits'));
          model.linkVirtualRoute = element.get('linkVirtualRoute');
          model.nameAuctionRoom = element.get('nameAuctionRoom');
          model.rejectedRequest = element.get('rejectedRequest');
          model.auctionerName = element.get('auctionerName');
          model.salesmanName = element.get('salesmanName');
          model.adminAssistantName = element.get('adminAssistantName');
          model.usersOfWhatsapp =
              listDynamicToString(element.get('usersOfWhatsapp'));
          model.auctionOrder = element.get('auctionOrder');
          model.auctionState = element.get('auctionState');
          model.auctionLink = element.get('auctionLink');
          model.initAuctionTime = element.get('initAuctionTime');
          model.finalAuctionTime = element.get('finalAuctionTime');
          model.auctionParticipants = listDynamicToAuctionParticipant(
              element.get('auctionParticipants'));
          model.isForm1 = element.get('isForm1');
          model.isForm2 = element.get('isForm2');
          model.isForm3 = element.get('isForm3');
          model.isForm4 = element.get('isForm4');
          model.isForm5 = element.get('isForm5');
          model.isForm6 = element.get('isForm6');
          model.auctionInitValue = element.get('auctionInitValue');
          model.auctionLastValue = element.get('auctionLastValue');
          // model.offerts = listDynamicToOffer(element.get('offerts'));

          residenceList.add(model);
        }
      });
      return residenceList;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return [];
    }
  }

  Future<List<ResidenceModel>> getResidencesOfAuctioner(
      String idAuctioner) async {
    //Get residences of any auctioner
    List<ResidenceModel> residenceList = [];

    try {
      await residences
          .where('idAuctioner'.trim(), isEqualTo: idAuctioner.toString().trim())
          .get()
          .then((querySnapshot) {
        for (var element in querySnapshot.docs) {
          ResidenceModel model = ResidenceModel();
          model.id = element.get('id');
          model.idUser = element.get('idUser');
          model.idSalesman = element.get('idSalesman');
          model.idAuctioner = element.get('idAuctioner');
          model.idAdminAssistant = element.get('idAdminAssistant');
          model.idDocumentation = element.get('idDocumentation');
          model.createFor = dynamicToEmployee(element.get('createFor'));
          model.ownerName = listDynamicToString(element.get('ownerName'));
          model.ownerPhoneNumber =
              listDynamicToString(element.get('ownerPhoneNumber'));
          model.ownerIdentification =
              listDynamicToString(element.get('ownerIdentification'));
          model.ownerEmail = listDynamicToString(element.get('ownerEmail'));
          model.stateInApp = element.get('stateInApp');
          model.applicationStatusDate = element.get('applicationStatusDate');
          model.creationStatusDate = element.get('creationStatusDate');
          model.reviewStatusDate = element.get('reviewStatusDate');
          model.publicationStatusDate = element.get('publicationStatusDate');
          model.auctionStatusDate = element.get('auctionStatusDate');
          model.documentationStatusDate =
              element.get('documentationStatusDate');
          model.availability = element.get('availability');
          model.managment = element.get('managment');
          model.price = element.get('price');
          model.area = element.get('area');
          model.room = element.get('room');
          model.bath = element.get('bath');
          model.garage = element.get('garage');
          model.buildersName = element.get('buildersName');
          model.name = element.get('name');
          model.neighborhood = element.get('neighborhood');
          model.city = element.get('city');
          model.state = element.get('state');
          model.country = element.get('country');
          model.typeOfResidence = element.get('typeOfResidence');
          model.typeOfAuction = element.get('typeOfAuction');
          model.condition = element.get('condition');
          model.stratum = element.get('stratum');
          model.features = listDynamicToString(element.get('features'));
          model.featuresSVG = listDynamicToString(element.get('featuresSVG'));
          model.commonAreas = listDynamicToString(element.get('commonAreas'));
          model.commonAreasSVG =
              listDynamicToString(element.get('commonAreasSVG'));
          model.location = element.get('location');
          model.nearbySpaces = listDynamicToString(element.get('nearbySpaces'));
          model.description = element.get('description');
          model.stories = listDynamicToStory(element.get('stories'));
          model.propertyNumber = element.get('propertyNumber');
          model.constructedArea = element.get('constructedArea');
          model.lotArea = element.get('lotArea');
          model.levelsNumber = element.get('levelsNumber');
          model.constructedYear = element.get('constructedYear');
          model.specialFeatures =
              listDynamicToString(element.get('specialFeatures'));
          model.nearbyNeighborhoods =
              listDynamicToString(element.get('nearbyNeighborhoods'));
          model.ownerCity = element.get('ownerCity');
          model.ownerCountry = element.get('ownerCountry');
          model.ownerState = element.get('ownerState');
          model.ownerDirection = element.get('ownerDirection');
          model.baseAuctionPrice = element.get('baseAuctionPrice');
          model.valuePerM2 = element.get('valuePerM2');
          model.subsidy = element.get('subsidy');
          model.initialFee = element.get('initialFee');
          model.monthTerm = element.get('monthTerm');
          model.preregistroFormObservations =
              element.get('preregistroFormObservations');
          model.infraestructuraFormObservations =
              element.get('infraestructuraFormObservations');
          model.informacionFormObservations =
              element.get('informacionFormObservations');
          model.financionFormObservations =
              element.get('financionFormObservations');
          model.agendaFormObservations = element.get('agendaFormObservations');
          model.propietarioFormObservations =
              element.get('propietarioFormObservations');
          model.auctionDate = element.get('auctionDate');
          model.presentialVisits =
              listDynamicToScheduleVisit(element.get('presentialVisits'));
          model.virtualVisits =
              listDynamicToScheduleVisit(element.get('virtualVisits'));
          model.linkVirtualRoute = element.get('linkVirtualRoute');
          model.nameAuctionRoom = element.get('nameAuctionRoom');
          model.rejectedRequest = element.get('rejectedRequest');
          model.auctionerName = element.get('auctionerName');
          model.salesmanName = element.get('salesmanName');
          model.adminAssistantName = element.get('adminAssistantName');
          model.usersOfWhatsapp =
              listDynamicToString(element.get('usersOfWhatsapp'));
          model.auctionOrder = element.get('auctionOrder');
          model.auctionState = element.get('auctionState');
          model.auctionLink = element.get('auctionLink');
          model.initAuctionTime = element.get('initAuctionTime');
          model.finalAuctionTime = element.get('finalAuctionTime');
          model.auctionParticipants = listDynamicToAuctionParticipant(
              element.get('auctionParticipants'));
          model.isForm1 = element.get('isForm1');
          model.isForm2 = element.get('isForm2');
          model.isForm3 = element.get('isForm3');
          model.isForm4 = element.get('isForm4');
          model.isForm5 = element.get('isForm5');
          model.isForm6 = element.get('isForm6');
          model.auctionInitValue = element.get('auctionInitValue');
          model.auctionLastValue = element.get('auctionLastValue');
          // model.offerts = listDynamicToOffer(element.get('offerts'));
          residenceList.add(model);
        }
      });
      return residenceList;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return [];
    }
  }

  Future<List<ResidenceModel>> getResidencesOfAdminAssistant(
      String idAdminAssistant) async {
    //Get residences of any assistant
    List<ResidenceModel> residenceList = [];

    try {
      await residences
          .where('idAdminAssistant'.trim(),
              isEqualTo: idAdminAssistant.toString().trim())
          .get()
          .then((querySnapshot) {
        for (var element in querySnapshot.docs) {
          ResidenceModel model = ResidenceModel();
          model.id = element.get('id');
          model.idUser = element.get('idUser');
          model.idSalesman = element.get('idSalesman');
          model.idAuctioner = element.get('idAuctioner');
          model.idAdminAssistant = element.get('idAdminAssistant');
          model.idDocumentation = element.get('idDocumentation');
          model.createFor = dynamicToEmployee(element.get('createFor'));
          model.ownerName = listDynamicToString(element.get('ownerName'));
          model.ownerPhoneNumber =
              listDynamicToString(element.get('ownerPhoneNumber'));
          model.ownerIdentification =
              listDynamicToString(element.get('ownerIdentification'));
          model.ownerEmail = listDynamicToString(element.get('ownerEmail'));
          model.stateInApp = element.get('stateInApp');
          model.applicationStatusDate = element.get('applicationStatusDate');
          model.creationStatusDate = element.get('creationStatusDate');
          model.reviewStatusDate = element.get('reviewStatusDate');
          model.publicationStatusDate = element.get('publicationStatusDate');
          model.auctionStatusDate = element.get('auctionStatusDate');
          model.documentationStatusDate =
              element.get('documentationStatusDate');
          model.availability = element.get('availability');
          model.managment = element.get('managment');
          model.price = element.get('price');
          model.area = element.get('area');
          model.room = element.get('room');
          model.bath = element.get('bath');
          model.garage = element.get('garage');
          model.buildersName = element.get('buildersName');
          model.name = element.get('name');
          model.neighborhood = element.get('neighborhood');
          model.city = element.get('city');
          model.state = element.get('state');
          model.country = element.get('country');
          model.typeOfResidence = element.get('typeOfResidence');
          model.typeOfAuction = element.get('typeOfAuction');
          model.condition = element.get('condition');
          model.stratum = element.get('stratum');
          model.features = listDynamicToString(element.get('features'));
          model.featuresSVG = listDynamicToString(element.get('featuresSVG'));
          model.commonAreas = listDynamicToString(element.get('commonAreas'));
          model.commonAreasSVG =
              listDynamicToString(element.get('commonAreasSVG'));
          model.location = element.get('location');
          model.nearbySpaces = listDynamicToString(element.get('nearbySpaces'));
          model.description = element.get('description');
          model.stories = listDynamicToStory(element.get('stories'));
          model.propertyNumber = element.get('propertyNumber');
          model.constructedArea = element.get('constructedArea');
          model.lotArea = element.get('lotArea');
          model.levelsNumber = element.get('levelsNumber');
          model.constructedYear = element.get('constructedYear');
          model.specialFeatures =
              listDynamicToString(element.get('specialFeatures'));
          model.nearbyNeighborhoods =
              listDynamicToString(element.get('nearbyNeighborhoods'));
          model.ownerCity = element.get('ownerCity');
          model.ownerCountry = element.get('ownerCountry');
          model.ownerState = element.get('ownerState');
          model.ownerDirection = element.get('ownerDirection');
          model.baseAuctionPrice = element.get('baseAuctionPrice');
          model.valuePerM2 = element.get('valuePerM2');
          model.subsidy = element.get('subsidy');
          model.initialFee = element.get('initialFee');
          model.monthTerm = element.get('monthTerm');
          model.preregistroFormObservations =
              element.get('preregistroFormObservations');
          model.infraestructuraFormObservations =
              element.get('infraestructuraFormObservations');
          model.informacionFormObservations =
              element.get('informacionFormObservations');
          model.financionFormObservations =
              element.get('financionFormObservations');
          model.agendaFormObservations = element.get('agendaFormObservations');
          model.propietarioFormObservations =
              element.get('propietarioFormObservations');
          model.auctionDate = element.get('auctionDate');
          model.presentialVisits =
              listDynamicToScheduleVisit(element.get('presentialVisits'));
          model.virtualVisits =
              listDynamicToScheduleVisit(element.get('virtualVisits'));
          model.linkVirtualRoute = element.get('linkVirtualRoute');
          model.nameAuctionRoom = element.get('nameAuctionRoom');
          model.rejectedRequest = element.get('rejectedRequest');
          model.auctionerName = element.get('auctionerName');
          model.salesmanName = element.get('salesmanName');
          model.adminAssistantName = element.get('adminAssistantName');
          model.usersOfWhatsapp =
              listDynamicToString(element.get('usersOfWhatsapp'));
          model.auctionOrder = element.get('auctionOrder');
          model.auctionState = element.get('auctionState');
          model.auctionLink = element.get('auctionLink');
          model.initAuctionTime = element.get('initAuctionTime');
          model.finalAuctionTime = element.get('finalAuctionTime');
          model.auctionParticipants = listDynamicToAuctionParticipant(
              element.get('auctionParticipants'));
          model.isForm1 = element.get('isForm1');
          model.isForm2 = element.get('isForm2');
          model.isForm3 = element.get('isForm3');
          model.isForm4 = element.get('isForm4');
          model.isForm5 = element.get('isForm5');
          model.isForm6 = element.get('isForm6');
          model.auctionInitValue = element.get('auctionInitValue');
          model.auctionLastValue = element.get('auctionLastValue');
          // model.offerts = listDynamicToOffer(element.get('offerts'));
          residenceList.add(model);
        }
      });
      return residenceList;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return [];
    }
  }

  Future<List<ResidenceModel>> getResidencesOfStateInApp(
      String stateInApp) async {
    //Get residences of any stateInApp
    List<ResidenceModel> residenceList = [];

    try {
      await residences
          .where('stateInApp'.trim(), isEqualTo: stateInApp.toString().trim())
          .get()
          .then((querySnapshot) {
        for (var element in querySnapshot.docs) {
          ResidenceModel model = ResidenceModel();
          model.id = element.get('id');
          model.idUser = element.get('idUser');
          model.idSalesman = element.get('idSalesman');
          model.idAuctioner = element.get('idAuctioner');
          model.idAdminAssistant = element.get('idAdminAssistant');
          model.idDocumentation = element.get('idDocumentation');
          model.createFor = dynamicToEmployee(element.get('createFor'));
          model.ownerName = listDynamicToString(element.get('ownerName'));
          model.ownerPhoneNumber =
              listDynamicToString(element.get('ownerPhoneNumber'));
          model.ownerIdentification =
              listDynamicToString(element.get('ownerIdentification'));
          model.ownerEmail = listDynamicToString(element.get('ownerEmail'));
          model.stateInApp = element.get('stateInApp');
          model.applicationStatusDate = element.get('applicationStatusDate');
          model.creationStatusDate = element.get('creationStatusDate');
          model.reviewStatusDate = element.get('reviewStatusDate');
          model.publicationStatusDate = element.get('publicationStatusDate');
          model.auctionStatusDate = element.get('auctionStatusDate');
          model.documentationStatusDate =
              element.get('documentationStatusDate');
          model.availability = element.get('availability');
          model.managment = element.get('managment');
          model.price = element.get('price');
          model.area = element.get('area');
          model.room = element.get('room');
          model.bath = element.get('bath');
          model.garage = element.get('garage');
          model.buildersName = element.get('buildersName');
          model.name = element.get('name');
          model.neighborhood = element.get('neighborhood');
          model.city = element.get('city');
          model.state = element.get('state');
          model.country = element.get('country');
          model.typeOfResidence = element.get('typeOfResidence');
          model.typeOfAuction = element.get('typeOfAuction');
          model.condition = element.get('condition');
          model.stratum = element.get('stratum');
          model.features = listDynamicToString(element.get('features'));
          model.featuresSVG = listDynamicToString(element.get('featuresSVG'));
          model.commonAreas = listDynamicToString(element.get('commonAreas'));
          model.commonAreasSVG =
              listDynamicToString(element.get('commonAreasSVG'));
          model.location = element.get('location');
          model.nearbySpaces = listDynamicToString(element.get('nearbySpaces'));
          model.description = element.get('description');
          model.stories = listDynamicToStory(element.get('stories'));
          model.propertyNumber = element.get('propertyNumber');
          model.constructedArea = element.get('constructedArea');
          model.lotArea = element.get('lotArea');
          model.levelsNumber = element.get('levelsNumber');
          model.constructedYear = element.get('constructedYear');
          model.specialFeatures =
              listDynamicToString(element.get('specialFeatures'));
          model.nearbyNeighborhoods =
              listDynamicToString(element.get('nearbyNeighborhoods'));
          model.ownerCity = element.get('ownerCity');
          model.ownerCountry = element.get('ownerCountry');
          model.ownerState = element.get('ownerState');
          model.ownerDirection = element.get('ownerDirection');
          model.baseAuctionPrice = element.get('baseAuctionPrice');
          model.valuePerM2 = element.get('valuePerM2');
          model.subsidy = element.get('subsidy');
          model.initialFee = element.get('initialFee');
          model.monthTerm = element.get('monthTerm');
          model.preregistroFormObservations =
              element.get('preregistroFormObservations');
          model.infraestructuraFormObservations =
              element.get('infraestructuraFormObservations');
          model.informacionFormObservations =
              element.get('informacionFormObservations');
          model.financionFormObservations =
              element.get('financionFormObservations');
          model.agendaFormObservations = element.get('agendaFormObservations');
          model.propietarioFormObservations =
              element.get('propietarioFormObservations');
          model.auctionDate = element.get('auctionDate');
          model.presentialVisits =
              listDynamicToScheduleVisit(element.get('presentialVisits'));
          model.virtualVisits =
              listDynamicToScheduleVisit(element.get('virtualVisits'));
          model.linkVirtualRoute = element.get('linkVirtualRoute');
          model.nameAuctionRoom = element.get('nameAuctionRoom');
          model.rejectedRequest = element.get('rejectedRequest');
          model.auctionerName = element.get('auctionerName');
          model.salesmanName = element.get('salesmanName');
          model.adminAssistantName = element.get('adminAssistantName');
          model.usersOfWhatsapp =
              listDynamicToString(element.get('usersOfWhatsapp'));
          model.auctionOrder = element.get('auctionOrder');
          model.auctionState = element.get('auctionState');
          model.auctionLink = element.get('auctionLink');
          model.initAuctionTime = element.get('initAuctionTime');
          model.finalAuctionTime = element.get('finalAuctionTime');
          model.auctionParticipants = listDynamicToAuctionParticipant(
              element.get('auctionParticipants'));
          model.isForm1 = element.get('isForm1');
          model.isForm2 = element.get('isForm2');
          model.isForm3 = element.get('isForm3');
          model.isForm4 = element.get('isForm4');
          model.isForm5 = element.get('isForm5');
          model.isForm6 = element.get('isForm6');
          model.auctionInitValue = element.get('auctionInitValue');
          model.auctionLastValue = element.get('auctionLastValue');
          // model.offerts = listDynamicToOffer(element.get('offerts'));
          residenceList.add(model);
        }
      });
      return residenceList;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return [];
    }
  }

  Future<void> deleteResidence(String id) async {
    //Delete a residence with the idResidence
    await residences
        .doc(id)
        .delete()
        .then((value) => log("Residence deleted"))
        .catchError((error) => log("❌Failed to deleted the residence: $error"));
  }

  Future updateResidence(String id, ResidenceModel model) {
    //Update all doctor object with the id and one doctor model
    List<Map<String, dynamic>> stories = [];
    if (model.stories != null) {
      stories = model.stories!.map((e) => e.toMap()).toList();
    } else {
      stories = [Story().emptyMap()];
    }

    List<Map<String, dynamic>> presentialVisits = [];
    if (model.presentialVisits != null) {
      presentialVisits = model.presentialVisits!.map((e) => e.toMap()).toList();
    } else {
      presentialVisits = [VisitsModel().emptyMap()];
    }

    Map<String, dynamic> createFor = EmployeeModel().emptyMap();
    if (model.createFor != null) {
      createFor = model.createFor!.toMap();
    }

    List<Map<String, dynamic>> virtualVisits = [];
    if (model.virtualVisits != null) {
      virtualVisits = model.virtualVisits!.map((e) => e.toMap()).toList();
    } else {
      virtualVisits = [VisitsModel().emptyMap()];
    }

    List<Map<String, dynamic>> auctionParticipants = [];
    if (model.auctionParticipants != null) {
      auctionParticipants =
          model.auctionParticipants!.map((e) => e.toMap()).toList();
    } else {
      auctionParticipants = [AuctionParticipant().emptyMap()];
    }

    //List<Map<String, dynamic>> offerts = [];
    // if (model.offerts != null) {
    //   offerts = model.offerts!.map((e) => e.toMap()).toList();
    // } else {
    //   offerts = [OfertModel('', '', 0, 0, '').toMap()];
    // }
    return residences.doc(id).update({
      "id": model.id,
      "idUser": model.idUser,
      "idSalesman": model.idSalesman,
      "idAuctioner": model.idAuctioner,
      "idAdminAssistant": model.idAdminAssistant,
      "idDocumentation": model.idDocumentation,
      "createFor": createFor,
      "ownerPhoneNumber": model.ownerPhoneNumber,
      "ownerName": model.ownerName,
      "ownerEmail": model.ownerEmail,
      "ownerIdentification": model.ownerIdentification,
      "stateInApp": model.stateInApp,
      "applicationStatusDate": model.applicationStatusDate,
      "creationStatusDate": model.creationStatusDate,
      "reviewStatusDate": model.reviewStatusDate,
      "publicationStatusDate": model.publicationStatusDate,
      "auctionStatusDate": model.auctionStatusDate,
      "documentationStatusDate": model.documentationStatusDate,
      "availability": model.availability,
      "managment": model.managment,
      "price": model.price,
      "area": model.area,
      "room": model.room,
      "bath": model.bath,
      "garage": model.garage,
      "name": model.name,
      "neighborhood": model.neighborhood,
      "buildersName": model.buildersName,
      "typeOfResidence": model.typeOfResidence,
      "typeOfAuction": model.typeOfAuction,
      "condition": model.condition,
      "stratum": model.stratum,
      "features": model.features,
      "featuresSVG": model.featuresSVG,
      "commonAreas": model.commonAreas,
      "commonAreasSVG": model.commonAreasSVG,
      "location": model.location,
      "nearbySpaces": model.nearbySpaces,
      "description": model.description,
      "stories": stories,
      "city": model.city,
      "state": model.state,
      "country": model.country,
      "propertyNumber": model.propertyNumber,
      "constructedArea": model.constructedArea,
      "lotArea": model.lotArea,
      "levelsNumber": model.levelsNumber,
      "constructedYear": model.constructedYear,
      "specialFeatures": model.specialFeatures,
      "nearbyNeighborhoods": model.nearbyNeighborhoods,
      'ownerCity': model.ownerCity,
      'ownerState': model.ownerState,
      'ownerCountry': model.ownerCountry,
      'ownerDirection': model.ownerDirection,
      'baseAuctionPrice': model.baseAuctionPrice,
      'valuePerM2': model.valuePerM2,
      'initialFee': model.initialFee,
      'monthTerm': model.monthTerm,
      'subsidy': model.subsidy,
      'preregistroFormObservations': model.preregistroFormObservations,
      'infraestructuraFormObservations': model.infraestructuraFormObservations,
      'informacionFormObservations': model.informacionFormObservations,
      'financionFormObservations': model.financionFormObservations,
      'agendaFormObservations': model.agendaFormObservations,
      'propietarioFormObservations': model.propietarioFormObservations,
      'auctionDate': model.auctionDate,
      'presentialVisits': presentialVisits,
      'virtualVisits': virtualVisits,
      'linkVirtualRoute': model.linkVirtualRoute,
      'nameAuctionRoom': model.nameAuctionRoom,
      'rejectedRequest': model.rejectedRequest,
      'auctionerName': model.auctionerName,
      'salesmanName': model.salesmanName,
      'adminAssistantName': model.adminAssistantName,
      'usersOfWhatsapp': model.usersOfWhatsapp,
      'auctionOrder': model.auctionOrder,
      'auctionState': model.auctionState,
      'auctionLink': model.auctionLink,
      'initAuctionTime': model.initAuctionTime,
      'finalAuctionTime': model.finalAuctionTime,
      'auctionParticipants': auctionParticipants,
      'isForm1': model.isForm1,
      'isForm2': model.isForm2,
      'isForm3': model.isForm3,
      'isForm4': model.isForm4,
      'isForm5': model.isForm5,
      'isForm6': model.isForm6,
      'auctionInitValue': model.auctionInitValue,
      'auctionLastValue': model.auctionLastValue,
      // 'offerts': offerts,
    }).then((value) {
      log("Residence update");
      // ignore: invalid_return_type_for_catch_error
    }).catchError((error) => log("❌Failed to update residence: $error"));
  }

  List<String> listDynamicToString(List<dynamic> listDynamic) {
    List<String> newList = [];
    for (String i in listDynamic) {
      newList.add(i);
    }

    return newList;
  }

  List<Story> listDynamicToStory(List<dynamic> listDynamic) {
    List<Story> newList = [];
    if (listDynamic.isNotEmpty) {
      for (var i = 0; i < listDynamic.length; i++) {
        newList.add(Story.fromMap(listDynamic[i]));
      }
    }

    return newList;
  }

  EmployeeModel dynamicToEmployee(dynamic employee) {
    EmployeeModel employeeModel = EmployeeModel.fromMap(employee);
    return employeeModel;
  }

  List<AuctionParticipant> listDynamicToAuctionParticipant(
      List<dynamic> listDynamic) {
    List<AuctionParticipant> newList = [];
    if (listDynamic.isNotEmpty) {
      for (var i = 0; i < listDynamic.length; i++) {
        newList.add(AuctionParticipant.fromMap(listDynamic[i]));
      }
    }

    return newList;
  }

  List<OfferModel> listDynamicToOffer(List<dynamic> listDynamic) {
    List<OfferModel> newList = [];
    if (listDynamic.isNotEmpty) {
      for (var i = 0; i < listDynamic.length; i++) {
        newList.add(OfferModel.fromMap(listDynamic[i]));
      }
    }

    return newList;
  }

  List<VisitsModel> listDynamicToScheduleVisit(List<dynamic> listDynamic) {
    List<VisitsModel> newList = [];
    if (listDynamic.isNotEmpty) {
      for (var i = 0; i < listDynamic.length; i++) {
        newList.add(VisitsModel.fromMap(listDynamic[i]));
      }
    }

    return newList;
  }

  List<Map<String, dynamic>> listdynamicToMap(List<dynamic> listDynamic) {
    List<Map<String, dynamic>> newList = [];
    for (var i in listDynamic) {
      newList.add(i);
    }

    return newList;
  }

  Future<void> updateStory(
      List<dynamic> story, ResidenceModel residence) async {
    await residences
        .doc(residence.id)
        .update({
          "stories": story,
        })
        // ignore: avoid_print
        .then((value) => print("my story update"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to updaate story: $error"));
  }
}
