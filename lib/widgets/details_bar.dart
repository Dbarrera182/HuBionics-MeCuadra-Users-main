import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../colors/colors_data.dart';

class DetailsBar extends StatefulWidget {
  final int area;
  final int rooms;
  final int baths;
  final int garages;
  const DetailsBar(
      {Key? key,
      required this.area,
      required this.baths,
      required this.garages,
      required this.rooms})
      : super(key: key);

  @override
  State<DetailsBar> createState() => _DetailsBarState();
}

class _DetailsBarState extends State<DetailsBar> {
  @override
  Widget build(BuildContext context) {
    final int area = widget.area;
    final int room = widget.rooms;
    final int bath = widget.baths;
    final int garage = widget.garages;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: MyColors.shadow.withOpacity(0.16),
                offset: const Offset(5, 6),
                blurRadius: 11,
              )
            ]),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
              height: 40,
              width: 80,
              decoration: BoxDecoration(
                color: MyColors.blue2,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                  child: Text(
                '$area' 'mt2',
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ))),
          Container(
              height: 40,
              width: 80,
              decoration: BoxDecoration(
                  color: MyColors.shadow.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white, width: 2)),
              child: Stack(children: [
                Positioned(
                  left: -3,
                  top: 0,
                  child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white)),
                ),
                Positioned(
                  left: 0.8,
                  top: 3.5,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: MyColors.grey.withOpacity(0.4),
                    child: Text(
                      '$room',
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const Positioned(
                    right: 10,
                    top: 4,
                    child: Icon(Icons.bedroom_parent_rounded,
                        color: MyColors.blue2))
              ])),
          Container(
              height: 40,
              width: 80,
              decoration: BoxDecoration(
                  color: MyColors.shadow.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: Colors.white, width: 2)),
              child: Stack(children: [
                Positioned(
                  left: -3,
                  top: 0,
                  child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white)),
                ),
                Positioned(
                  left: 0.8,
                  top: 3.5,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: MyColors.grey.withOpacity(0.4),
                    child: Text(
                      '$bath',
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const Positioned(
                    right: 10,
                    top: 4,
                    child: Icon(Icons.bathtub, color: MyColors.blue2))
              ])),
          Container(
              height: 40,
              width: 80,
              decoration: BoxDecoration(
                  color: MyColors.shadow.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: Colors.white, width: 2)),
              child: Stack(children: [
                Positioned(
                  left: -3,
                  top: 0,
                  child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white)),
                ),
                Positioned(
                  left: 0.8,
                  top: 3.5,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: MyColors.grey.withOpacity(0.4),
                    child: Text(
                      '$garage',
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const Positioned(
                    right: 10,
                    top: 4,
                    child: Icon(Icons.directions_car, color: MyColors.blue2))
              ])),
        ]),
      ),
    );
  }
}
