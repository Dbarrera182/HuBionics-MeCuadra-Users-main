import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../colors/colors_data.dart';

class VerticalDetailsBar extends StatefulWidget {
  final String typeResidence;
  final int area;
  final int rooms;
  final int baths;
  final int garages;
  const VerticalDetailsBar(
      {Key? key,
      required this.typeResidence,
      required this.area,
      required this.baths,
      required this.garages,
      required this.rooms})
      : super(key: key);

  @override
  State<VerticalDetailsBar> createState() => _VerticalDetailsBarState();
}

class _VerticalDetailsBarState extends State<VerticalDetailsBar> {
  @override
  Widget build(BuildContext context) {
    final int area = widget.area;
    final int room = widget.rooms;
    final int bath = widget.baths;
    final int garage = widget.garages;
    final String typeResidence = widget.typeResidence;
    return Align(
      alignment: const Alignment(1, 0.65),
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: SizedBox(
          height: 200,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: MyColors.blue2,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: MyColors.shadow.withOpacity(0.16),
                              offset: const Offset(5, 6),
                              blurRadius: 11)
                        ]),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                                text: typeResidence + '\n',
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: '$area' 'mt2',
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400)),
                          ]),
                        ))),
                Stack(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 4, top: 4, bottom: 4.0),
                      child: Container(
                        height: 32,
                        width: 68,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    Positioned(
                      left: 2,
                      top: 3,
                      child: Container(
                        height: 34,
                        width: 34,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: MyColors.shadow.withOpacity(0.16),
                                  offset: const Offset(2, 2),
                                  blurRadius: 2)
                            ]),
                      ),
                    ),
                    Positioned(
                      left: 4,
                      top: 5,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: MyColors.grey5656.withOpacity(0.5),
                        child: Text(
                          '$room',
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Positioned(
                        right: 6,
                        top: 12,
                        child: SvgPicture.asset('assets/Icons/Habitaciones.svg',
                            height: 15, width: 15, color: MyColors.blue2))
                  ],
                ),
                Stack(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 4, top: 4, bottom: 4.0),
                      child: Container(
                        height: 32,
                        width: 68,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    Positioned(
                      left: 2,
                      top: 3,
                      child: Container(
                        height: 34,
                        width: 34,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: MyColors.shadow.withOpacity(0.16),
                                  offset: const Offset(2, 2),
                                  blurRadius: 2)
                            ]),
                      ),
                    ),
                    Positioned(
                      left: 4,
                      top: 5,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: MyColors.grey5656.withOpacity(0.5),
                        child: Text(
                          '$bath',
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Positioned(
                        right: 8,
                        top: 10,
                        child: SvgPicture.asset('assets/Icons/Baños.svg',
                            height: 17, width: 17, color: MyColors.blue2))
                  ],
                ),
                Stack(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 4, top: 4, bottom: 4.0),
                      child: Container(
                        height: 32,
                        width: 68,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    Positioned(
                      left: 2,
                      top: 3,
                      child: Container(
                        height: 34,
                        width: 34,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: MyColors.shadow.withOpacity(0.16),
                                  offset: const Offset(2, 2),
                                  blurRadius: 2)
                            ]),
                      ),
                    ),
                    Positioned(
                      left: 4,
                      top: 5,
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: MyColors.grey5656.withOpacity(0.5),
                        child: Text(
                          '$garage',
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Positioned(
                        right: 3,
                        top: 13,
                        child: SvgPicture.asset('assets/Icons/Parqueaderos.svg',
                            height: 12, width: 12, color: MyColors.blue2))
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}
