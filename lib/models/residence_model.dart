import 'package:me_cuadra_users/models/employee_model.dart';

import 'complement_models/auction_participan.dart';
import 'complement_models/story_model.dart';
import 'complement_models/visits_model.dart';

class ResidenceModel {
  String? id;
  String? idUser;
  String? idSalesman;
  String? idAuctioner;
  String? idAdminAssistant;
  String? idDocumentation;
  EmployeeModel? createFor;
  List<String>? ownerName;
  List<String>? ownerPhoneNumber;
  List<String>? ownerIdentification;
  List<String>? ownerEmail;
  String? stateInApp;
  String? applicationStatusDate;
  String? creationStatusDate;
  String? reviewStatusDate;
  String? publicationStatusDate;
  String? auctionStatusDate;
  String? documentationStatusDate;
  String? availability;
  int? managment;
  int? price;
  int? area;
  int? room;
  int? bath;
  int? garage;
  String? buildersName;
  String? name;
  String? neighborhood;
  String? city;
  String? state;
  String? country;
  String? typeOfResidence;
  String? typeOfAuction;
  String? condition;
  int? stratum;
  List<String>? features;
  List<String>? featuresSVG;
  List<String>? commonAreas;
  List<String>? commonAreasSVG;
  String? location;
  List<String>? nearbySpaces;
  String? description;
  List<Story>? stories;
  String? propertyNumber;
  int? constructedArea;
  int? lotArea;
  int? levelsNumber;
  int? constructedYear;
  List<String>? specialFeatures;
  List<String>? nearbyNeighborhoods;
  String? ownerCity;
  String? ownerState;
  String? ownerCountry;
  String? ownerDirection;
  int? baseAuctionPrice;
  int? valuePerM2;
  String? subsidy;
  int? initialFee;
  int? monthTerm;
  String? preregistroFormObservations;
  String? infraestructuraFormObservations;
  String? informacionFormObservations;
  String? financionFormObservations;
  String? agendaFormObservations;
  String? propietarioFormObservations;
  String? auctionDate;
  List<VisitsModel>? presentialVisits;
  List<VisitsModel>? virtualVisits;
  String? linkVirtualRoute;
  String? nameAuctionRoom;
  bool? rejectedRequest;
  String? auctionerName;
  String? salesmanName;
  String? adminAssistantName;
  List<String>? usersOfWhatsapp;
  int? auctionOrder;
  String? auctionState;
  String? auctionLink;
  String? initAuctionTime;
  String? finalAuctionTime;
  List<AuctionParticipant>? auctionParticipants;
  bool? isForm1;
  bool? isForm2;
  bool? isForm3;
  bool? isForm4;
  bool? isForm5;
  bool? isForm6;
  int? auctionInitValue;
  int? auctionLastValue;

  ResidenceModel(
      {this.id,
      this.idUser,
      this.idSalesman,
      this.idAuctioner,
      this.idAdminAssistant,
      this.idDocumentation,
      this.createFor,
      this.ownerName,
      this.ownerPhoneNumber,
      this.ownerIdentification,
      this.ownerEmail,
      this.stateInApp,
      this.applicationStatusDate,
      this.creationStatusDate,
      this.reviewStatusDate,
      this.publicationStatusDate,
      this.auctionStatusDate,
      this.documentationStatusDate,
      this.availability,
      this.price,
      this.area,
      this.room,
      this.bath,
      this.garage,
      this.buildersName,
      this.name,
      this.neighborhood,
      this.city,
      this.state,
      this.country,
      this.typeOfResidence,
      this.typeOfAuction,
      this.condition,
      this.stratum,
      this.features,
      this.featuresSVG,
      this.commonAreas,
      this.commonAreasSVG,
      this.location,
      this.nearbySpaces,
      this.description,
      this.stories,
      this.managment,
      this.propertyNumber,
      this.constructedArea,
      this.lotArea,
      this.levelsNumber,
      this.constructedYear,
      this.specialFeatures,
      this.nearbyNeighborhoods,
      this.ownerCity,
      this.ownerCountry,
      this.ownerDirection,
      this.ownerState,
      this.baseAuctionPrice,
      this.initialFee,
      this.monthTerm,
      this.valuePerM2,
      this.subsidy,
      this.preregistroFormObservations,
      this.infraestructuraFormObservations,
      this.informacionFormObservations,
      this.financionFormObservations,
      this.agendaFormObservations,
      this.propietarioFormObservations,
      this.auctionDate,
      this.presentialVisits,
      this.virtualVisits,
      this.nameAuctionRoom,
      this.linkVirtualRoute,
      this.rejectedRequest,
      this.adminAssistantName,
      this.auctionerName,
      this.salesmanName,
      this.usersOfWhatsapp,
      this.auctionOrder,
      this.auctionState,
      this.auctionLink,
      this.initAuctionTime,
      this.finalAuctionTime,
      this.auctionParticipants,
      this.isForm1,
      this.isForm2,
      this.isForm3,
      this.isForm4,
      this.isForm5,
      this.isForm6,
      this.auctionInitValue,
      this.auctionLastValue});
}
