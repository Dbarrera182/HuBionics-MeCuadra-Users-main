import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../models/residence_model.dart';
import '../../../models/user_model.dart';
import '../../../providers/filter_provider.dart';
import '../../../services/firebase/residences_crud.dart';
import '../../auctions_page/auction_page.dart';
import '../../auctions_page/auctions_rent/auction_rent_page.dart';
import '../../property_information_pages/home_filter_page.dart';
import '../send_property_request.dart';

class ProfileDrawer extends StatefulWidget {
  UserModel user;
  ProfileDrawer({Key? key, required this.user})
      : super(
          key: key,
        );

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

List<ResidenceModel> allResidences = [];

bool isLoading = false;

class _ProfileDrawerState extends State<ProfileDrawer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        children: [
          Container(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, 'home_page', (route) => false);
              },
              child: Text(
                'Buscar imueble',
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            child: GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SendPropertyRequest(user: widget.user),
                    ),
                    (route) => false);
              },
              child: Text(
                'Ofertar Propiedad',
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            child: GestureDetector(
              onTap: () {
                showFilters();
              },
              child: Text(
                'Filtrar',
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            child: GestureDetector(
              onTap: () {
                goAuctions();
              },
              child: Text(
                'Subastas por martillero',
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            child: GestureDetector(
              onTap: () {
                goExpressAuctions();
              },
              child: Text(
                'subastas express',
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            child: GestureDetector(
              onTap: () {},
              child: Text(
                'Preguntas frecuentes',
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  void showFilters() {
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => HomeFilter(filterProvider: filterProvider)),
        (_) => false);
  }

  void goAuctions() async {
    if (isLoading == false) {
      isLoading = true;

      allResidences =
          await ResidenceCrud().getResidencesOfStateInApp('Publicada');
      List<ResidenceModel> newList = [];
      for (var i = 0; i < allResidences.length; i++) {
        if (allResidences[i].typeOfAuction == 'Subasta') {
          newList.add(allResidences[i]);
        }
      }
      isLoading = false;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => AuctionPage(
                    residenceList: newList,
                    user: widget.user,
                  )),
          (_) => false);
    }
  }

  void goExpressAuctions() async {
    if (isLoading == false) {
      isLoading = true;

      allResidences =
          await ResidenceCrud().getResidencesOfStateInApp('Publicada');
      List<ResidenceModel> newList = [];
      for (var i = 0; i < allResidences.length; i++) {
        if (allResidences[i].typeOfAuction == 'Express') {
          newList.add(allResidences[i]);
        }
      }
      isLoading = false;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => AuctionRentPage(
                    residenceList: newList,
                    user: widget.user,
                  )),
          (_) => false);
    }
  }
}
