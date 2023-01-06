// ignore_for_file: prefer_interpolation_to_compose_strings, must_be_immutable

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../colors/colors_data.dart';
import '../models/offer_model.dart';
import '../models/user_model.dart';
import '../services/const/json_const.dart';

class OfferWidget extends StatefulWidget {
  final Query query;
  OfferModel offer;
  UserModel user;
  OfferWidget(
      {Key? key, required this.query, required this.offer, required this.user})
      : super(key: key);

  @override
  State<OfferWidget> createState() => _OfferWidgetState();
}

class _OfferWidgetState extends State<OfferWidget> {
  final price = NumberFormat("#,###", "en_US");

  @override
  Widget build(BuildContext context) {
    bool isUserOffer = false;
    DateTime offerDate = DateTime.parse(widget.offer.ofertDate!);
    if (widget.offer.idUser == widget.user.id) {
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
                                    widget.offer.userPalette.toString() +
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
                                  '\$' + price.format(widget.offer.ofertPrice),
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
                                    widget.offer.userPalette.toString() +
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
                                  '\$' + price.format(widget.offer.ofertPrice),
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
}
