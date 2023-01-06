// ignore_for_file: prefer_interpolation_to_compose_strings, deprecated_member_use

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:me_cuadra_users/models/complement_models/auction_notification_model.dart';
import 'package:me_cuadra_users/preferences/auction_notification_preferences.dart';
import 'package:me_cuadra_users/services/firebase/user_crud.dart';
import 'package:me_cuadra_users/user_app_pages/auctions_page/auctions_rent/offer_list_rent_page.dart';
import 'package:me_cuadra_users/user_app_pages/property_information_pages/home_details_page.dart';
import 'package:me_cuadra_users/user_app_pages/user_login/verify_user.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../colors/colors_data.dart';
import '../../../models/complement_models/story_model.dart';
import '../../../models/offer_model.dart';
import '../../../models/residence_model.dart';
import '../../../models/user_model.dart';
import '../../../preferences/user_preference.dart';
import '../../../services/const/json_const.dart';
import '../../../services/firebase/offer_crud.dart';

// ignore: must_be_immutable
class AuctionRentPage extends StatefulWidget {
  List<ResidenceModel> residenceList;
  UserModel user;
  AuctionRentPage({Key? key, required this.residenceList, required this.user})
      : super(key: key);

  @override
  State<AuctionRentPage> createState() => _AuctionRentPageState();
}

class _AuctionRentPageState extends State<AuctionRentPage> {
  String dropdownValue = "Subastas por terminar";
  final filterAuctions = [
    "Subastas por terminar",
    "Precio",
    "En venta",
    "En arriendo"
  ];

  final price = NumberFormat("#,###", "en_US");
  List<OfferDB> offers = [];
  List<String> idsResidence = [];
  UserModel user = UserModel();
  AuctionNotificationModel notificationModel = AuctionNotificationModel();

  @override
  void initState() {
    super.initState();
    getUser();
    getNotificationPreferences();
  }

  getUser() async {
    user = await UserPreferences().loadData();
  }

  getNotificationPreferences() async {
    notificationModel = await AuctionNotificationPreferences().loadData();
    idsResidence = notificationModel.idsResidence!;
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
          body: SingleChildScrollView(
            child: Column(children: [
              const SizedBox(height: 20),
              _title(),
              // _orderAuctions(),
              const SizedBox(height: 20),
              _sliderCard()
            ]),
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
    );
  }

  void goUserProfile() async {
    UserModel userModel = await UserPreferences().loadData();
    if (userModel.id != '') {
      userModel = await UserCrud().getUser(userModel.id!);
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerifyUser(
          user: userModel,
        ),
      ),
    );
  }

  Widget _title() {
    return Text(
      'Subastas Express',
      style: GoogleFonts.montserrat(
          color: MyColors.blue2, fontSize: 18, fontWeight: FontWeight.w800),
      textAlign: TextAlign.center,
    );
  }

  getRef(int index) {
    return OfferCrud().getOffers(widget.residenceList[index].id!).onValue;
  }

  Widget _cardTitle(int index) {
    DateTime auctionDate =
        DateTime.parse(widget.residenceList[index].auctionDate!);
    return Stack(children: [
      Container(
          decoration: BoxDecoration(
              color: MyColors.blue2,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: MyColors.grey.withOpacity(0.1),
                    offset: const Offset(5, 6),
                    blurRadius: 5,
                    spreadRadius: 0.1)
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
            child: Text(
              'Finaliza: ' +
                  auctionDate.day.toString() +
                  ' ' +
                  JsonConst.dateToShortMonth(auctionDate) +
                  ' ' +
                  auctionDate.hour.toString() +
                  ':00',
              style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
          ))
    ]);
  }

  Widget _sliderCard() {
    final size = MediaQuery.of(context).size;
    String urlImage = '';

    return CarouselSlider.builder(
        itemCount: widget.residenceList.length,
        itemBuilder: (context, index, realIndex) {
          for (var i = 0;
              i < widget.residenceList[index].stories!.length;
              i++) {
            if (widget.residenceList[index].stories![i].media ==
                MediaType.image) {
              urlImage = widget.residenceList[index].stories![i].url!;
              i = widget.residenceList[index].stories!.length;
            }
          }
          return _auctionCard(urlImage, index);
        },
        options: CarouselOptions(height: size.height - 170));
  }

  Widget _auctionCard(String urlImage, int index) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: getRef(index),
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        int offerMaxIndex = 0;
        OfferModel offerModel = OfferModel('', '', 0, 0, '');

        if (!snapshot.hasData) {
          // ignore: prefer_const_constructors
          return Center(
            child: const CircularProgressIndicator(),
          );
        } else {
          if (snapshot.data!.snapshot.exists) {
            if (snapshot.hasData) {
              offerMaxIndex = snapshot.data!.snapshot.children.length;
              offerModel = OfferModel.fromMap(snapshot.data!.snapshot.children
                  .elementAt(offerMaxIndex - 1)
                  .value as Map);
            }
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 15),
                  child: Container(
                    padding: const EdgeInsets.only(top: 40),
                    width: double.maxFinite,
                    height: double.maxFinite,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.16),
                              offset: const Offset(5, 6),
                              blurRadius: 12)
                        ]),
                    child: Stack(
                      children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: CachedNetworkImage(
                                  imageUrl: urlImage,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: size.height / 2,
                                    width: double.maxFinite - 150,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(9),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                  fadeInDuration:
                                      const Duration(microseconds: 0),
                                  fadeOutDuration:
                                      const Duration(milliseconds: 0),
                                  placeholder: (context, url) => Container(
                                    alignment: Alignment.center,
                                    child: const CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      SvgPicture.asset(
                                    'assets/Icons/LogoSVG.svg',
                                    width: 30,
                                    height: 30,
                                    color: MyColors.blue2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4.0, right: 4),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.16),
                                                offset: const Offset(5, 6),
                                                blurRadius: 11)
                                          ]),
                                      child: CircleAvatar(
                                        backgroundColor: MyColors.blue2,
                                        radius: 19,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 17,
                                          child: SvgPicture.asset(
                                              'assets/Icons/Compartir.svg',
                                              height: 24,
                                              width: 24,
                                              color: MyColors.blue2),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        //Arreglar
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    OfferListRentPage(
                                                      residenceModel: widget
                                                          .residenceList[index],
                                                      user: user,
                                                    ))));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: MyColors.fuchsia,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: MyColors.shadow
                                                        .withOpacity(0.16),
                                                    offset: const Offset(5, 6),
                                                    blurRadius: 11)
                                              ]),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 16),
                                            child: Text(
                                              'Ver Ofertas',
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ]),
                        Align(
                          alignment: const Alignment(0, -1),
                          child: Stack(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Container(
                                height: 40,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  color: MyColors.whiteBox,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4, bottom: 4, left: 45, right: 15),
                                  child: Column(
                                    children: [
                                      Text('Valor actual en subasta',
                                          style: GoogleFonts.montserrat(
                                              color: MyColors.grey,
                                              fontSize: 9,
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.center),
                                      Text(
                                          widget.residenceList[index]
                                                      .auctionLastValue !=
                                                  0
                                              ? '\$' +
                                                  price.format(
                                                      offerModel.ofertPrice)
                                              : '\$' +
                                                  price.format(widget
                                                      .residenceList[index]
                                                      .baseAuctionPrice),
                                          style: GoogleFonts.montserrat(
                                              color: MyColors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900),
                                          textAlign: TextAlign.center)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: const Alignment(-0.8, -1),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(100),
                                      boxShadow: [
                                        BoxShadow(
                                            color: MyColors.shadow
                                                .withOpacity(0.16),
                                            offset: const Offset(3, 3),
                                            blurRadius: 1)
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: CircleAvatar(
                                      radius: 22,
                                      backgroundColor: MyColors.blueMarine,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                              snapshot.data!.snapshot.children
                                                  .length
                                                  .toString(),
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.white,
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.w700)),
                                          Text('# Ofertas',
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.white,
                                                  fontSize: 7,
                                                  fontWeight: FontWeight.w700)),
                                          const SizedBox(height: 8),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                          ]),
                        ),
                        Align(
                            alignment: const Alignment(0, 0.6),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                  height: 100,
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                    color: MyColors.whiteBox,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6.0, horizontal: 60),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 18),
                                        Text('SUBASTA:',
                                            style: GoogleFonts.montserrat(
                                                color: MyColors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600)),
                                        Text(
                                            widget.residenceList[index]
                                                .availability!,
                                            style: GoogleFonts.montserrat(
                                                color: MyColors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w800)),
                                        const SizedBox(height: 2),
                                        Container(
                                          height: 2,
                                          width: 130,
                                          color: MyColors.blue2,
                                        ),
                                        const SizedBox(height: 4),
                                        Text('Valor inicial de subasta',
                                            style: GoogleFonts.montserrat(
                                                color: MyColors.grey,
                                                fontSize: 9,
                                                fontWeight: FontWeight.w600)),
                                        Text(
                                            '\$' +
                                                price.format(widget
                                                    .residenceList[index]
                                                    .baseAuctionPrice),
                                            style: GoogleFonts.montserrat(
                                                color: MyColors.grey,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w900)),
                                        const SizedBox(height: 2),
                                      ],
                                    ),
                                  )),
                            )),
                        Align(
                            alignment: const Alignment(0, 0.33),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => HomeDetails(
                                              residence: widget
                                                  .residenceList[index]))));
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.16),
                                              offset: const Offset(5, 6),
                                              blurRadius: 11)
                                        ]),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6.0, horizontal: 20),
                                      child: Text(
                                        'Ver propiedad',
                                        style: GoogleFonts.montserrat(
                                            color: MyColors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center,
                                      ),
                                    ))))
                      ],
                    ),
                  ),
                ),
                Align(
                    alignment: const Alignment(0, -1),
                    child: _cardTitle(index)),
              ],
            );
          } else {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 15),
                  child: Container(
                    padding: const EdgeInsets.only(top: 40),
                    width: double.maxFinite,
                    height: double.maxFinite,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.16),
                              offset: const Offset(5, 6),
                              blurRadius: 12)
                        ]),
                    child: Stack(
                      children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: CachedNetworkImage(
                                  imageUrl: urlImage,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: size.height / 2,
                                    width: double.maxFinite - 150,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(9),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                  fadeInDuration:
                                      const Duration(microseconds: 0),
                                  fadeOutDuration:
                                      const Duration(milliseconds: 0),
                                  placeholder: (context, url) => Container(
                                    alignment: Alignment.center,
                                    child: const CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      SvgPicture.asset(
                                    'assets/Icons/LogoSVG.svg',
                                    width: 30,
                                    height: 30,
                                    color: MyColors.blue2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4.0, right: 4),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.16),
                                                offset: const Offset(5, 6),
                                                blurRadius: 11)
                                          ]),
                                      child: CircleAvatar(
                                        backgroundColor: MyColors.blue2,
                                        radius: 19,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 17,
                                          child: SvgPicture.asset(
                                              'assets/Icons/Compartir.svg',
                                              height: 24,
                                              width: 24,
                                              color: MyColors.blue2),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    OfferListRentPage(
                                                      residenceModel: widget
                                                          .residenceList[index],
                                                      user: user,
                                                    ))));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: MyColors.fuchsia,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: MyColors.shadow
                                                        .withOpacity(0.16),
                                                    offset: const Offset(5, 6),
                                                    blurRadius: 11)
                                              ]),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0, horizontal: 16),
                                            child: Text(
                                              'Ver Ofertas',
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ]),
                        Align(
                          alignment: const Alignment(0, -1),
                          child: Stack(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Container(
                                height: 40,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  color: MyColors.whiteBox,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4, bottom: 4, left: 45, right: 15),
                                  child: Column(
                                    children: [
                                      Text('Valor actual en subasta',
                                          style: GoogleFonts.montserrat(
                                              color: MyColors.grey,
                                              fontSize: 9,
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.center),
                                      Text(
                                          widget.residenceList[index]
                                                      .auctionLastValue !=
                                                  0
                                              ? '\$' +
                                                  price.format(widget
                                                      .residenceList[index]
                                                      .auctionLastValue)
                                              : '\$' +
                                                  price.format(widget
                                                      .residenceList[index]
                                                      .baseAuctionPrice),
                                          style: GoogleFonts.montserrat(
                                              color: MyColors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900),
                                          textAlign: TextAlign.center)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: const Alignment(-0.8, -1),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(100),
                                      boxShadow: [
                                        BoxShadow(
                                            color: MyColors.shadow
                                                .withOpacity(0.16),
                                            offset: const Offset(3, 3),
                                            blurRadius: 1)
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: CircleAvatar(
                                      radius: 22,
                                      backgroundColor: MyColors.blueMarine,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                              snapshot.data!.snapshot.children
                                                  .length
                                                  .toString(),
                                              // widget.residenceList[index].offerts![0]
                                              //             .idUser !=
                                              //         ''
                                              //     ? widget.residenceList[index].offerts!
                                              //         .length
                                              //         .toString()
                                              //     : 0.toString(),
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.white,
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.w700)),
                                          Text('# Ofertas',
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.white,
                                                  fontSize: 7,
                                                  fontWeight: FontWeight.w700)),
                                          const SizedBox(height: 8),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                          ]),
                        ),
                        Align(
                            alignment: const Alignment(0, 0.6),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                  height: 100,
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                    color: MyColors.whiteBox,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6.0, horizontal: 60),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 18),
                                        Text('SUBASTA:',
                                            style: GoogleFonts.montserrat(
                                                color: MyColors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600)),
                                        Text(
                                            widget.residenceList[index]
                                                .availability!,
                                            style: GoogleFonts.montserrat(
                                                color: MyColors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w800)),
                                        const SizedBox(height: 2),
                                        Container(
                                          height: 2,
                                          width: 130,
                                          color: MyColors.blue2,
                                        ),
                                        const SizedBox(height: 4),
                                        Text('Valor inicial de subasta',
                                            style: GoogleFonts.montserrat(
                                                color: MyColors.grey,
                                                fontSize: 9,
                                                fontWeight: FontWeight.w600)),
                                        Text(
                                            '\$' +
                                                price.format(widget
                                                    .residenceList[index]
                                                    .baseAuctionPrice),
                                            style: GoogleFonts.montserrat(
                                                color: MyColors.grey,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w900)),
                                        const SizedBox(height: 2),
                                      ],
                                    ),
                                  )),
                            )),
                        Align(
                            alignment: const Alignment(0, 0.33),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => HomeDetails(
                                              residence: widget
                                                  .residenceList[index]))));
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.16),
                                              offset: const Offset(5, 6),
                                              blurRadius: 11)
                                        ]),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6.0, horizontal: 20),
                                      child: Text(
                                        'Ver propiedad',
                                        style: GoogleFonts.montserrat(
                                            color: MyColors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center,
                                      ),
                                    ))))
                      ],
                    ),
                  ),
                ),
                Align(
                    alignment: const Alignment(0, -1),
                    child: _cardTitle(index)),
              ],
            );
          }
        }
      },
    );
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
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
}
