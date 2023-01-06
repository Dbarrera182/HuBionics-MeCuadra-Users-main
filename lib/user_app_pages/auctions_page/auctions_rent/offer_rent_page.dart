// ignore_for_file: must_be_immutable, avoid_print

import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:me_cuadra_users/colors/colors_data.dart';
import 'package:me_cuadra_users/models/offer_model.dart';
import 'package:me_cuadra_users/models/offer_model_cloud.dart';
import 'package:me_cuadra_users/models/residence_model.dart';
import 'package:me_cuadra_users/models/user_model.dart';
import 'package:me_cuadra_users/preferences/user_preference.dart';
import 'package:me_cuadra_users/services/firebase/offer_cloud_crud.dart';
import 'package:me_cuadra_users/services/firebase/offer_crud.dart';
import 'package:me_cuadra_users/services/firebase/residences_crud.dart';
import 'package:me_cuadra_users/services/firebase/user_crud.dart';
import 'package:me_cuadra_users/services/notifications/fcm_firebase_notification/fcm_service.dart';
import 'package:me_cuadra_users/user_app_pages/auctions_page/auctions_rent/offer_list_rent_page.dart';

import 'package:me_cuadra_users/utils/currency_input_formatter.dart';
import 'package:me_cuadra_users/utils/dateTime_convers.dart';
import 'package:me_cuadra_users/widgets/simple_error_dialog_widget.dart';

class OfferRentPage extends StatefulWidget {
  final Query offerQuery;
  ResidenceModel model;
  OfferModel lastOffer;

  OfferRentPage({
    Key? key,
    required this.model,
    required this.offerQuery,
    required this.lastOffer,
  }) : super(key: key);

  @override
  State<OfferRentPage> createState() => _OfferRentPageState();
}

class _OfferRentPageState extends State<OfferRentPage> {
  bool hundred = false;
  bool fiveHundred = true;
  bool million = false;
  TextEditingController offerController = TextEditingController();
  int offersNumber = 0;
  OfferModel thisOffer = OfferModel('', '', 0, 0, '');
  final price = NumberFormat("#,###", "en_US");
  late DateTime auctionDate;
  UserModel lastUser = UserModel();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    auctionDate = DateTime.parse(widget.model.auctionDate!);
    offerController.text = price.format(widget.model.auctionLastValue);
  }

  getRef() {
    return OfferCrud().getOffers(widget.model.id!).onValue;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Subasta',
                    style: GoogleFonts.montserrat(
                        color: MyColors.blue2,
                        fontSize: 30,
                        fontWeight: FontWeight.w700)),
                StreamBuilder(
                    stream: getRef(),
                    builder: ((context, AsyncSnapshot<DatabaseEvent> snapshot) {
                      if (!snapshot.hasData) {
                        // ignore: prefer_const_constructors
                        return Center(
                          child: const CircularProgressIndicator(),
                        );
                      } else if (snapshot.data!.snapshot.exists) {
                        if (snapshot.hasData) {
                          offersNumber =
                              snapshot.data!.snapshot.children.length;
                          thisOffer = OfferModel.fromMap(snapshot
                              .data!.snapshot.children
                              .elementAt(offersNumber - 1)
                              .value as Map);
                        }
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 4.0, bottom: 4, left: 8),
                              child: Container(
                                width: double.maxFinite - 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: MyColors.whiteBox),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0,
                                      bottom: 8.0,
                                      left: 25,
                                      right: 20),
                                  child: Column(children: [
                                    Text('Valor actual en subasta',
                                        style: GoogleFonts.montserrat(
                                            color: MyColors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600)),
                                    Text(
                                        '\$' +
                                            price.format(thisOffer.ofertPrice) +
                                            ' COP',
                                        style: GoogleFonts.montserrat(
                                            color: MyColors.grey,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w700))
                                  ]),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: MyColors.blueMarine,
                                      borderRadius: BorderRadius.circular(100),
                                      boxShadow: [
                                        BoxShadow(
                                            color: MyColors.shadow
                                                .withOpacity(0.16),
                                            offset: const Offset(3, 3),
                                            blurRadius: 1)
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Text(offersNumber.toString(),
                                            // widget.model.offerts![0].idUser != ''
                                            //     ? widget.model.offerts!.length
                                            //         .toString()
                                            //     : '0',
                                            style: GoogleFonts.montserrat(
                                                color: Colors.white,
                                                fontSize: 27,
                                                fontWeight: FontWeight.w700)),
                                        Text('# Ofertas',
                                            style: GoogleFonts.montserrat(
                                                color: Colors.white,
                                                fontSize: 9,
                                                fontWeight: FontWeight.w700)),
                                        const SizedBox(height: 1)
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        );
                      } else {
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 4.0, bottom: 4, left: 8),
                              child: Container(
                                width: double.maxFinite - 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: MyColors.whiteBox),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0,
                                      bottom: 8.0,
                                      left: 25,
                                      right: 20),
                                  child: Column(children: [
                                    Text('Valor actual en subasta',
                                        style: GoogleFonts.montserrat(
                                            color: MyColors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600)),
                                    Text(
                                        '\$' +
                                            price.format(
                                                widget.model.auctionInitValue) +
                                            ' COP',
                                        style: GoogleFonts.montserrat(
                                            color: MyColors.grey,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w700))
                                  ]),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: MyColors.blueMarine,
                                      borderRadius: BorderRadius.circular(100),
                                      boxShadow: [
                                        BoxShadow(
                                            color: MyColors.shadow
                                                .withOpacity(0.16),
                                            offset: const Offset(3, 3),
                                            blurRadius: 1)
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Text(offersNumber.toString(),
                                            // widget.model.offerts![0].idUser != ''
                                            //     ? widget.model.offerts!.length
                                            //         .toString()
                                            //     : '0',
                                            style: GoogleFonts.montserrat(
                                                color: Colors.white,
                                                fontSize: 27,
                                                fontWeight: FontWeight.w700)),
                                        Text('# Ofertas',
                                            style: GoogleFonts.montserrat(
                                                color: Colors.white,
                                                fontSize: 9,
                                                fontWeight: FontWeight.w700)),
                                        const SizedBox(height: 1)
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        );
                      }
                    })),
                Text(
                    'Selecciona la cantidad a incrementar\n o modifica de forma libre el valor \n final a ofertar',
                    style: GoogleFonts.montserrat(
                        color: MyColors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: GestureDetector(
                          onTap: () {
                            if (offerController.text == '') {
                              offerController.text =
                                  price.format(widget.model.auctionLastValue!);
                            }
                            String stringPrice =
                                (offerController.text).replaceAll(',', '');
                            int newPrice = int.parse(stringPrice);
                            offerController.text =
                                price.format((newPrice + 100000));
                            if (!hundred) {
                              setState(() {
                                hundred = true;
                                fiveHundred = false;
                                million = false;
                              });
                            }
                          },
                          child: hundred
                              ? Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: MyColors.grey, width: 0),
                                      borderRadius: BorderRadius.circular(12),
                                      color: MyColors.blue2,
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.16),
                                            offset: const Offset(0, 8),
                                            blurRadius: 5)
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text('100K',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: MyColors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.16),
                                            offset: const Offset(0, 3),
                                            blurRadius: 6)
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text('100K',
                                        style: GoogleFonts.montserrat(
                                            color: MyColors.grey,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center),
                                  ))),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: GestureDetector(
                          onTap: () {
                            if (offerController.text == '') {
                              offerController.text =
                                  price.format(widget.model.auctionLastValue!);
                            }
                            String stringPrice =
                                (offerController.text).replaceAll(',', '');
                            int newPrice = int.parse(stringPrice);
                            offerController.text =
                                price.format((newPrice + 500000));
                            if (!fiveHundred) {
                              setState(() {
                                hundred = false;
                                fiveHundred = true;
                                million = false;
                              });
                            }
                          },
                          child: fiveHundred
                              ? Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: MyColors.grey, width: 0),
                                      borderRadius: BorderRadius.circular(12),
                                      color: MyColors.blue2,
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.16),
                                            offset: const Offset(0, 8),
                                            blurRadius: 5)
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text('500K',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: MyColors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.16),
                                            offset: const Offset(0, 3),
                                            blurRadius: 6)
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      '500K',
                                      style: GoogleFonts.montserrat(
                                          color: MyColors.grey,
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    ),
                                  ))),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: GestureDetector(
                          onTap: () {
                            if (offerController.text == '') {
                              offerController.text =
                                  price.format(widget.model.auctionLastValue!);
                            }
                            String stringPrice =
                                (offerController.text).replaceAll(',', '');
                            int newPrice = int.parse(stringPrice);
                            offerController.text =
                                price.format((newPrice + 1000000));
                            if (!million) {
                              setState(() {
                                hundred = false;
                                fiveHundred = false;
                                million = true;
                              });
                            }
                          },
                          child: million
                              ? Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: MyColors.grey, width: 0),
                                      borderRadius: BorderRadius.circular(12),
                                      color: MyColors.blue2,
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.16),
                                            offset: const Offset(0, 8),
                                            blurRadius: 5)
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text('1M',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: MyColors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.16),
                                            offset: const Offset(0, 3),
                                            blurRadius: 6)
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text('1M',
                                        style: GoogleFonts.montserrat(
                                            color: MyColors.grey,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center),
                                  ))),
                    ),
                  ),
                ]),
                Column(
                  children: [
                    Text('Valor final a ofertar',
                        style: GoogleFonts.montserrat(
                            color: MyColors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    Container(
                        width: size.width - 80,
                        decoration: BoxDecoration(
                            color: MyColors.whiteBox,
                            borderRadius: BorderRadius.circular(24)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  '\$',
                                  style: GoogleFonts.montserrat(
                                      color: MyColors.grey,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: TextField(
                                  style: GoogleFonts.montserrat(
                                      color: MyColors.grey,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600),
                                  controller: offerController,
                                  maxLength: 13,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CurrencyInputFormatter()
                                  ],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.left,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    counterText: '',
                                    hintText: price
                                        .format(widget.model.auctionLastValue),
                                    hintStyle: GoogleFonts.montserrat(
                                        color: MyColors.grey,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('COP',
                                    style: GoogleFonts.montserrat(
                                        color: MyColors.grey,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ])),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 20),
                      primary: MyColors.fuchsia,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0))),
                  onPressed: () async {
                    if (isLoading == false) {
                      isLoading = true;
                      List<String> participantTokens = [];
                      final user = await UserPreferences().loadData();
                      ResidenceModel lastResiden =
                          await ResidenceCrud().getResidence(widget.model.id!);
                      int userPalette = 0;
                      for (var i = 0;
                          i < lastResiden.auctionParticipants!.length;
                          i++) {
                        participantTokens.add(
                            lastResiden.auctionParticipants![i].userToken!);
                        if (lastResiden.auctionParticipants![i].idUser ==
                            user.id) {
                          userPalette = i + 1;
                        }
                      }

                      String stringPrice =
                          (offerController.text).replaceAll(',', '');
                      if (int.parse(stringPrice) > thisOffer.ofertPrice!) {
                        DateTime nowDate =
                            DateTimeConver.getDateTimeNowInUTCFormat();
                        DateTime finalAuctionDate =
                            DateTime.parse(lastResiden.finalAuctionTime!);
                        if (nowDate.isBefore(finalAuctionDate)) {
                          DateTime finalAdd1 =
                              nowDate.add(const Duration(minutes: 1));
                          if (finalAdd1.isAfter(finalAuctionDate)) {
                            finalAuctionDate = finalAuctionDate
                                .add(const Duration(minutes: 3));
                            lastResiden.finalAuctionTime =
                                finalAuctionDate.toString();
                          }
                          OfferModel userOffer = OfferModel(
                              user.id,
                              user.userName,
                              userPalette,
                              int.parse(stringPrice),
                              DateTime.now().toString());
                          OfferModelCloud offerC =
                              await OfferCloudCrud().getOffer(lastResiden.id!);
                          if (offerC.idResidence == null ||
                              offerC.idResidence == '') {
                            OfferCloudCrud().addOffer(OfferModelCloud(
                                idResidence: lastResiden.id,
                                offers: [userOffer]));
                          } else {
                            lastUser = await UserCrud().getUser(offerC
                                .offers![offerC.offers!.length - 1].idUser!);
                            offerC.offers!.add(userOffer);
                            sendNotifications(
                                participantTokens, (userPalette - 1));

                            OfferCloudCrud()
                                .updateOffer(offerC.idResidence!, offerC);
                          }

                          OfferCrud().saveOffer(userOffer, widget.model.id!);
                          lastResiden.auctionLastValue = int.parse(stringPrice);

                          ResidenceCrud()
                              .updateResidence(widget.model.id!, lastResiden);
                          isLoading = false;
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OfferListRentPage(
                                        residenceModel: lastResiden,
                                        user: user,
                                      )),
                              (_) => false);
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
                                description:
                                    "El valor de tu oferta debe ser superior a la oferta actual"));
                      }
                    }
                  },
                  child: Text(
                    'Ofertar',
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                )
              ]),
        ),
      ),
    );
  }

  //Get tokens list to use the fcm service and the oferent client to remove that position of token list
  sendNotifications(
      List<String> participantTokens, int tokenUserPosition) async {
    participantTokens.removeAt(tokenUserPosition);
    for (var i = 0; i < participantTokens.length; i++) {
      await sendPushMessage(
          participantTokens[i],
          'Una nueva oferta se ha añadido al inmueble de tu interés',
          'Subasta express');
    }
  }
}
