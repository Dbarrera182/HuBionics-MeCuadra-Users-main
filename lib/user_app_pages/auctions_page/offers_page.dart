// ignore_for_file: must_be_immutable, avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:me_cuadra_users/models/user_model.dart';
import 'package:me_cuadra_users/services/firebase/user_crud.dart';
import '../../../widgets/simple_error_dialog_widget.dart';
import '../../colors/colors_data.dart';
import '../../models/offer_model.dart';
import '../../models/offer_model_cloud.dart';
import '../../models/residence_model.dart';
import '../../preferences/user_preference.dart';
import '../../services/firebase/offer_cloud_crud.dart';
import '../../services/firebase/offer_crud.dart';
import '../../services/firebase/residences_crud.dart';
import '../../utils/currency_input_formatter.dart';

class OfferPage extends StatefulWidget {
  final Query offerQuery;
  ResidenceModel model;
  OfferModel lastOffer;
  OfferPage(
      {Key? key,
      required this.model,
      required this.offerQuery,
      required this.lastOffer})
      : super(key: key);

  @override
  State<OfferPage> createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  bool hundred = false;
  bool fiveHundred = true;
  bool million = false;
  TextEditingController offerController = TextEditingController();
  int offersNumber = 0;
  OfferModel thisOffer = OfferModel('', '', 0, 0, '');
  final price = NumberFormat("#,###", "en_US");
  late DateTime auctionDate;
  UserModel lastUser = UserModel();

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
                GestureDetector(
                  onTap: () async {
                    final user = await UserPreferences().loadData();
                    ResidenceModel lastResiden =
                        await ResidenceCrud().getResidence(widget.model.id!);
                    int userPalette = 0;
                    for (var i = 0;
                        i < lastResiden.auctionParticipants!.length;
                        i++) {
                      if (lastResiden.auctionParticipants![i].idUser ==
                          user.id) {
                        userPalette = i + 1;
                      }
                    }
                    String stringPrice =
                        (offerController.text).replaceAll(',', '');
                    if (int.parse(stringPrice) > thisOffer.ofertPrice!) {
                      OfferModel userOffer = OfferModel(
                          user.id,
                          user.userName,
                          userPalette,
                          int.parse(stringPrice),
                          DateTime.now().toString());
                      OfferModelCloud offerC =
                          await OfferCloudCrud().getOffer(widget.model.id!);
                      if (offerC.idResidence == null ||
                          offerC.idResidence == '') {
                        OfferCloudCrud().addOffer(OfferModelCloud(
                            idResidence: lastResiden.id, offers: [userOffer]));
                      } else {
                        offerC.offers!.add(userOffer);
                        OfferCloudCrud()
                            .updateOffer(offerC.idResidence!, offerC);
                      }
                      if (lastUser.userToken != null &&
                          lastUser.userToken != '') {
                        await sendPushMessage(lastUser.userToken!,
                            'Tu oferta ha sido superada', 'Subasta express');
                      }

                      OfferCrud().saveOffer(userOffer, widget.model.id!);
                      lastResiden.auctionLastValue = int.parse(stringPrice);
                      getToken(user);
                      ResidenceCrud()
                          .updateResidence(widget.model.id!, lastResiden);
                      Navigator.pop(context);
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => SimpleErrorDialogWidget(
                              description:
                                  "El valor de tu oferta debe ser superior a la oferta actual"));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
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
                          vertical: 8, horizontal: 50),
                      child: Text(
                        'Ofertar',
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ]),
        ),
      ),
    );
  }

  sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAkDSm7S4:APA91bE6YmP9P2XRhVx90IYknFM0v4xKosXmnnGkG3byGI4ExnPCAGnGsHohN03wHcACYFYWYGYZBLluTaThDBHPSddgwIFfu7nCwSf-aFJOGyhkFbAjwKZI5VeGYcRJgZ1vmwAYfW8l',
        },
        body: jsonEncode(<String, dynamic>{
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'body': body,
            'title': title,
          },
          "notification": <String, dynamic>{
            "title": title,
            "body": body,
          },
          "to": token,
        }),
      );
    } catch (e) {
      if (kDebugMode) {
        print('error push notifiication: ' + e.toString());
      }
    }
  }

  getToken(UserModel myUser) async {
    await FirebaseMessaging.instance.getToken().then((token) {
      print('My token is $token');
      saveToken(token!, myUser);
    });
  }

  saveToken(String myToken, UserModel myUser) {
    if (myUser.userToken != '') {
      if (myUser.userToken != myToken) {
        myUser.userToken = myToken;

        UserCrud().updateUser(myUser.id!, myUser);
        UserPreferences().saveData(myUser);
      }
    } else {
      myUser.userToken = myToken;

      UserCrud().updateUser(myUser.id!, myUser);
      UserPreferences().saveData(myUser);
    }
  }
}
