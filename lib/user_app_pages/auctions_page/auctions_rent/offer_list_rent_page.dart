// ignore_for_file: must_be_immutable, prefer_interpolation_to_compose_strings, use_build_context_synchronously, deprecated_member_use

import 'dart:io';

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:me_cuadra_users/models/complement_models/auction_participan.dart';
import 'package:me_cuadra_users/models/offer_model_cloud.dart';
import 'package:me_cuadra_users/services/firebase/crud_employee.dart';
import 'package:me_cuadra_users/services/firebase/offer_cloud_crud.dart';
import 'package:me_cuadra_users/services/firebase/residences_crud.dart';
import 'package:me_cuadra_users/services/firebase/user_crud.dart';
import 'package:me_cuadra_users/services/notifications/fcm_firebase_notification/fcm_service.dart';
import 'package:me_cuadra_users/services/notifications/schedule_visit_notifications.dart';
import 'package:me_cuadra_users/user_app_pages/auctions_page/auctions_rent/offer_rent_page.dart';
import 'package:me_cuadra_users/user_app_pages/user_login/verify_user.dart';
import 'package:me_cuadra_users/utils/dateTime_convers.dart';
import 'package:me_cuadra_users/widgets/simple_dialog_success_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../colors/colors_data.dart';
import '../../../models/offer_model.dart';
import '../../../models/residence_model.dart';
import '../../../models/user_model.dart';
import '../../../preferences/user_preference.dart';
import '../../../services/const/json_const.dart';
import '../../../services/firebase/offer_crud.dart';
import '../../../widgets/offer_widget.dart';
import '../../../widgets/simple_error_dialog_widget.dart';

class OfferListRentPage extends StatefulWidget {
  ResidenceModel residenceModel;
  UserModel user;
  OfferListRentPage(
      {Key? key, required this.residenceModel, required this.user})
      : super(key: key);

  @override
  State<OfferListRentPage> createState() => _OfferListRentPageState();
}

class _OfferListRentPageState extends State<OfferListRentPage> {
  final price = NumberFormat("#,###", "en_US");
  ScrollController scrollController = ScrollController();
  List<OfferDB> offerList = [];
  DateTime initAuctionDate = DateTime.now();
  bool isAuctionEndend = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initAuctionDate = DateTime.parse(widget.residenceModel.initAuctionTime!);
  }

  void _scrollGoBottom() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(
            context, 'home_page', (route) => false);

        return false;
      },
      child: Scaffold(
          appBar: getAppBar(),
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 60, left: 15, right: 15, top: 15),
                child: Column(
                  children: [
                    _buildTitle(),
                    const SizedBox(
                      height: 15,
                    ),
                    _listenOffers()
                  ],
                ),
              ),
              _offerButton()
            ],
          )),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          goUserProfile();
        },
        icon: SvgPicture.asset('assets/Icons/Usuario.svg',
            height: 35, width: 35, color: Colors.white),
      ),
      centerTitle: true,
      title: SvgPicture.asset(
        'assets/Icons/LogoSVG.svg',
        width: 30,
        height: 30,
        color: MyColors.blue2,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 4.0, right: 8),
          child: IconButton(
              onPressed: () {
                updateResidence();
              },
              icon: const Icon(
                Icons.update_rounded,
                color: Colors.white,
                size: 40,
              )),
        )
      ],
    );
  }

  void goUserProfile() async {
    UserModel userModel = await UserPreferences().loadData();
    if (userModel.id != '') {
      userModel = await UserCrud().getUser(userModel.id!);
    }
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyUser(
            user: userModel,
          ),
        ),
        (_) => false);
  }

  updateResidence() async {
    widget.residenceModel =
        await ResidenceCrud().getResidence(widget.residenceModel.id!);
    setState(() => widget.residenceModel);
  }

  Widget _buildTitle() {
    // DocumentReference reference = FirebaseFirestore.instance
    //     .collection('residences')
    //     .doc(widget.residenceModel.id);
    // reference.snapshots().listen((querySnapshot) {
    //   setState(() {
    //     finalAuctionDateString = querySnapshot.get("finalAuctionTime");
    //   });
    // });
    DateTime nowDate = DateTimeConver.getDateTimeNowInUTCFormat();
    DateTime finalAuctionDate =
        DateTime.parse(widget.residenceModel.finalAuctionTime!);
    if (nowDate.isBefore(finalAuctionDate)) {
      isAuctionEndend = false;
    } else {
      isAuctionEndend = true;
    }
    String hour = '';
    String minute = '';
    finalAuctionDate.hour < 10
        ? hour = '0' + finalAuctionDate.hour.toString()
        : hour = finalAuctionDate.hour.toString();

    finalAuctionDate.minute < 10
        ? minute = '0' + finalAuctionDate.minute.toString()
        : minute = finalAuctionDate.minute.toString();
    return Column(
      children: [
        Text(
          isAuctionEndend ? 'Subasta finalizada' : 'Lista de ofertas',
          style: GoogleFonts.montserrat(
              color: MyColors.blue2, fontSize: 30, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        isAuctionEndend
            ? Text(
                'Fecha de cierre: ' +
                    finalAuctionDate.day.toString() +
                    ' ' +
                    JsonConst.onlyDateToMonth(finalAuctionDate) +
                    ' ' +
                    hour +
                    ':' +
                    minute,
                style: GoogleFonts.montserrat(
                    color: MyColors.blue2,
                    fontSize: 11,
                    fontWeight: FontWeight.w700))
            : Text(
                'Finaliza el: ' +
                    finalAuctionDate.day.toString() +
                    ' ' +
                    JsonConst.onlyDateToMonth(finalAuctionDate) +
                    ' ' +
                    hour +
                    ':' +
                    minute,
                style: GoogleFonts.montserrat(
                    color: MyColors.blue2,
                    fontSize: 11,
                    fontWeight: FontWeight.w700))
      ],
    );
  }

  Widget offerWidget(OfferDB offerDB) {
    bool isUserOffer = false;
    DateTime offerDate = DateTime.parse(offerDB.offerModel!.ofertDate!);
    if (offerDB.offerModel!.idUser == widget.user.id) {
      isUserOffer = true;
    }
    if (isUserOffer) {
      return Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              const Expanded(flex: 35, child: Center()),
              Expanded(
                  flex: 65,
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyColors.blueMarine,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 3, left: 20, right: 8),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                'Usuario ' +
                                    offerDB.offerModel!.userPalette.toString() +
                                    ' ha propuesto',
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(height: 3),
                          Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  '\$' +
                                      price.format(
                                          offerDB.offerModel!.ofertPrice),
                                  style: GoogleFonts.montserrat(
                                      color: MyColors.blue2,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(getSpecificDate(offerDate),
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500)),
                          )
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  flex: 65,
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyColors.whiteBox,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 3, left: 20, right: 8),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                'Usuario ' +
                                    offerDB.offerModel!.userPalette.toString() +
                                    ' ha propuesto',
                                style: GoogleFonts.montserrat(
                                    color: MyColors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(height: 3),
                          Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  '\$' +
                                      price.format(
                                          offerDB.offerModel!.ofertPrice),
                                  style: GoogleFonts.montserrat(
                                      color: MyColors.blue2,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(getSpecificDate(offerDate),
                                style: GoogleFonts.montserrat(
                                    color: MyColors.grey,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500)),
                          )
                        ],
                      ),
                    ),
                  )),
              const Expanded(flex: 35, child: Center())
            ],
          ),
        ],
      );
    }
  }

  Widget _listenOffers() {
    offerList = [];
    OfferCrud()
        .getOffers(widget.residenceModel.id!)
        .onChildAdded
        .listen((event) {
      OfferModel offerModel = OfferModel.fromMap(event.snapshot.value as Map);
      OfferDB offerDB =
          OfferDB(key: event.snapshot.key, offerModel: offerModel);
      offerList.add(offerDB);
      _scrollGoBottom();
    });
    return Expanded(
      child: FirebaseAnimatedList(
        shrinkWrap: false,
        reverse: false,
        controller: scrollController,
        query: OfferCrud().getOffers(widget.residenceModel.id!),
        itemBuilder: (context, snapshot, animation, index) {
          final json = snapshot.value as Map<dynamic, dynamic>;
          final offer = OfferModel.fromMap(json);
          return OfferWidget(
              query: OfferCrud().getOffers(widget.residenceModel.id!),
              offer: offer,
              user: widget.user);
        },
      ),
    );
  }

  Widget _offerButton() {
    bool isRegister = false;
    String requestState = '';

    return isAuctionEndend
        ? const Center()
        : Align(
            alignment: const Alignment(0, 0.98),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                  primary: MyColors.fuchsia,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0))),
              onPressed: () async {
                if (isLoading == false) {
                  isLoading = true;
                  ResidenceModel lastResiden = await ResidenceCrud()
                      .getResidence(widget.residenceModel.id!);

                  DateTime finalAuctionDate =
                      DateTime.parse(lastResiden.finalAuctionTime!);
                  DateTime nowDate = DateTimeConver.getDateTimeNowInUTCFormat();
                  if (lastResiden.auctionParticipants!.isNotEmpty) {
                    for (var i = 0;
                        i < lastResiden.auctionParticipants!.length;
                        i++) {
                      if (lastResiden.auctionParticipants![i].idUser ==
                          widget.user.id!) {
                        isRegister = true;
                        requestState =
                            lastResiden.auctionParticipants![i].requestState!;
                      }
                    }
                  }
                  if (isRegister) {
                    if (requestState == 'Aprobado') {
                      if (nowDate.isAfter(initAuctionDate)) {
                        if (nowDate.isBefore(finalAuctionDate)) {
                          final user = await UserPreferences().loadData();
                          OfferModel offerModel = OfferModel('', '', 0, 0, '');
                          OfferModelCloud offersOfResidence =
                              await OfferCloudCrud()
                                  .getOffer(widget.residenceModel.id!);
                          if (offersOfResidence.idResidence != null) {
                            offerModel = offersOfResidence.offers!.last;
                            final query = OfferCrud()
                                .getOffers(widget.residenceModel.id!);
                            if (offerModel.idUser != user.id) {
                              isLoading = false;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => OfferRentPage(
                                            model: lastResiden,
                                            offerQuery: query,
                                            lastOffer: offerModel,
                                          ))));
                            } else {
                              isLoading = false;
                              showDialog(
                                  context: context,
                                  builder: (context) => SimpleErrorDialogWidget(
                                      description:
                                          "Tu oferta es la más alta\nhasta el momento"));
                            }
                          } else {
                            if (offerModel.idUser != user.id) {
                              final query = OfferCrud()
                                  .getOffers(widget.residenceModel.id!);
                              isLoading = false;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => OfferRentPage(
                                            model: lastResiden,
                                            offerQuery: query,
                                            lastOffer: offerModel,
                                          ))));
                            }
                          }
                        } else {
                          isLoading = false;
                          showDialog(
                              context: context,
                              builder: (context) => SimpleErrorDialogWidget(
                                  description: "Subasta finalizada"));
                        }
                      } else {
                        isLoading = false;
                        showDialog(
                            context: context,
                            builder: (context) => SimpleErrorDialogWidget(
                                description: "Subasta no ha iniciado"));
                      }
                    } else if (requestState == 'Revisión') {
                      isLoading = false;
                      showDialog(
                          context: context,
                          builder: (context) => _rejectedRequest(
                              "Su solicitud se encuentra en Revisión",
                              "Pongase en contacto con nuestro auxiliar administrativo para más información",
                              Icons.close_rounded,
                              widget.user,
                              lastResiden));
                    } else {
                      isLoading = false;
                      showDialog(
                          context: context,
                          builder: (context) => _rejectedRequest(
                              "Su solicitud ha sido rechazada",
                              "Pongase en contacto con nuestro auxiliar administrativo para más información",
                              Icons.close_rounded,
                              widget.user,
                              lastResiden));
                    }
                  } else {
                    isLoading = false;
                    showDialog(
                        context: context,
                        builder: (context) => _errorMessageWithButtons(
                            "No estas registrado en la subasta",
                            "¿Deseas enviar tu solicitud de registro?\n Uno de nuestros trabajadores te contactará para validar tu información",
                            Icons.close_rounded,
                            widget.user,
                            lastResiden));
                  }
                }
              },
              child: Text(
                'Ofertar',
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            ),
          );
  }

  openWhatsapp(ResidenceModel rModel, String adminAssistantNumber) async {
    var number = '+57' + adminAssistantNumber;
    var message = "Hola!, estoy interesado en " + rModel.name!;
    var whatsappURLAndroid =
        "https://wa.me/$number/?text=${Uri.parse(message)}";
    var whatsappURLIos =
        "https://api.whatsapp.com/send?phone=$number=${Uri.parse(message)}";
    if (Platform.isAndroid) {
      if (await canLaunch(whatsappURLAndroid)) {
        await launch(whatsappURLAndroid);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("whatsapp no installed")));
      }
    } else {
      if (await canLaunch(whatsappURLIos)) {
        await launch(whatsappURLIos);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("whatsapp no installed")));
      }
    }
  }

  offerMessage(List<OfferModel>? data, int index) {
    bool isUserOffer = false;
    DateTime offerDate = DateTime.parse(data![index].ofertDate!);
    if (data[index].idUser == widget.user.id) {
      isUserOffer = true;
    }
    if (isUserOffer) {
      return Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              const Expanded(flex: 35, child: Center()),
              Expanded(
                  flex: 65,
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyColors.blueMarine,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 3, left: 20, right: 8),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                'Usuario ' +
                                    data[index].userPalette.toString() +
                                    ' ha propuesto',
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(height: 3),
                          Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  '\$' + price.format(data[index].ofertPrice),
                                  style: GoogleFonts.montserrat(
                                      color: MyColors.blue2,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(getSpecificDate(offerDate),
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500)),
                          )
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  flex: 65,
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyColors.whiteBox,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 3, left: 20, right: 8),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                'Usuario ' +
                                    data[index].userPalette.toString() +
                                    ' ha propuesto',
                                style: GoogleFonts.montserrat(
                                    color: MyColors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(height: 3),
                          Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  '\$' + price.format(data[index].ofertPrice),
                                  style: GoogleFonts.montserrat(
                                      color: MyColors.blue2,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(getSpecificDate(offerDate),
                                style: GoogleFonts.montserrat(
                                    color: MyColors.grey,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500)),
                          )
                        ],
                      ),
                    ),
                  )),
              const Expanded(flex: 35, child: Center())
            ],
          ),
        ],
      );
    }
  }

  String getSpecificDate(DateTime offerDate) {
    String specificDate = offerDate.day.toString() +
        ' ' +
        JsonConst.dateToShortMonth(offerDate) +
        ' ' +
        offerDate.year.toString() +
        ' /' +
        offerDate.hour.toString() +
        ':' +
        offerDate.minute.toString();
    return specificDate;
  }

  Widget _rejectedRequest(String title, String description, IconData icon,
      UserModel userModel, ResidenceModel rModel) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: MyColors.grey,
      insetPadding: const EdgeInsets.all(0),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                width: size.width,
                height: size.height,
                decoration: const BoxDecoration(
                  color: MyColors.grey,
                  shape: BoxShape.rectangle,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24.0),
                      CircleAvatar(
                        radius: 105,
                        backgroundColor: MyColors.fuchsia.withOpacity(0.4),
                        child: CircleAvatar(
                          radius: 90,
                          backgroundColor: MyColors.fuchsia,
                          child: Icon(
                            icon,
                            color: Colors.white,
                            size: 140,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        description,
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24.0),
                      GestureDetector(
                        onTap: () async {
                          final adminAssistant = await CrudEmployee()
                              .getEmployee(rModel.idAdminAssistant!);
                          openWhatsapp(rModel, adminAssistant.businessNumber!);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                              color: MyColors.fuchsia,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: MyColors.shadow.withOpacity(0.16),
                                    offset: const Offset(5, 6),
                                    blurRadius: 11)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20),
                            child: Text(
                              'Contactar  ',
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 60.0),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _errorMessageWithButtons(String title, String description,
      IconData icon, UserModel userModel, ResidenceModel rModel) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      insetPadding: const EdgeInsets.all(0),
      backgroundColor: MyColors.grey,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              isLoading = false;
              Navigator.pop(context);
            },
            child: Container(
                width: size.width,
                height: size.height,
                decoration: const BoxDecoration(
                  color: MyColors.grey,
                  shape: BoxShape.rectangle,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24.0),
                      CircleAvatar(
                        radius: 105,
                        backgroundColor: MyColors.fuchsia.withOpacity(0.4),
                        child: CircleAvatar(
                          radius: 90,
                          backgroundColor: MyColors.fuchsia,
                          child: Icon(
                            icon,
                            color: Colors.white,
                            size: 140,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        description,
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 9, horizontal: 30),
                            primary: MyColors.fuchsia,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0))),
                        onPressed: () async {
                          if (isLoading == false) {
                            isLoading = true;
                            userModel.userToken =
                                await getTokenString(userModel);
                            AuctionParticipant participant = AuctionParticipant(
                              idUser: userModel.id,
                              userName: userModel.userName,
                              userImage: userModel.photoURL,
                              userMail: userModel.email,
                              userToken: userModel.userToken,
                              userPhoneNumber: userModel.phoneNumber.toString(),
                              requestDate: DateTime.now().toString(),
                              requestState: 'Revisión',
                            );
                            if (rModel.auctionParticipants!.isNotEmpty) {
                              if (rModel.auctionParticipants![0].idUser == '') {
                                rModel.auctionParticipants![0] = participant;
                                ResidenceCrud()
                                    .updateResidence(rModel.id!, rModel);
                                DateTime initAuctionDate =
                                    DateTime.parse(rModel.initAuctionTime!);
                                initAuctionDate = initAuctionDate
                                    .subtract(const Duration(minutes: 2));
                                createAuctionInitNotification(initAuctionDate);
                                isLoading = false;
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: (context) =>
                                        SimpleSuccessDialogWidget(
                                            description: "Solicitud enviada"));
                              } else {
                                rModel.auctionParticipants!.add(participant);

                                ResidenceCrud()
                                    .updateResidence(rModel.id!, rModel);
                                DateTime initAuctionDate =
                                    DateTime.parse(rModel.initAuctionTime!);
                                initAuctionDate
                                    .subtract(const Duration(minutes: 5));
                                createAuctionInitNotification(initAuctionDate);
                                isLoading = false;

                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: (context) =>
                                        SimpleSuccessDialogWidget(
                                            description: "Solicitud enviada"));
                              }
                            } else {
                              rModel.auctionParticipants!.add(participant);
                              ResidenceCrud()
                                  .updateResidence(rModel.id!, rModel);
                              DateTime initAuctionDate =
                                  DateTime.parse(rModel.initAuctionTime!);
                              initAuctionDate
                                  .subtract(const Duration(minutes: 2));
                              createAuctionInitNotification(initAuctionDate);
                              isLoading = false;

                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (context) =>
                                      SimpleSuccessDialogWidget(
                                          description: "Solicitud enviada"));
                            }
                          }
                        },
                        child: Text(
                          'Enviar',
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 60.0),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
