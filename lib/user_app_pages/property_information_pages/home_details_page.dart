// ignore_for_file: deprecated_member_use, prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:me_cuadra_users/user_app_pages/auctions_page/auctions_rent/offer_list_rent_page.dart';
import 'package:me_cuadra_users/user_app_pages/auctions_page/offers_list_page.dart';
import 'package:me_cuadra_users/user_app_pages/user_login/verify_user.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../models/complement_models/story_model.dart';
import '../../colors/colors_data.dart';
import '../../models/residence_model.dart';
import '../../models/user_model.dart';
import '../../preferences/user_preference.dart';
import '../../providers/user_provider.dart';
import '../../services/const/json_const.dart';
import '../../services/firebase/crud_employee.dart';
import '../../services/firebase/residences_crud.dart';
import '../../services/firebase/user_crud.dart';
import '../../widgets/details_bar.dart';
import 'show_dates.dart';

class HomeDetails extends StatefulWidget {
  final ResidenceModel residence;
  const HomeDetails({Key? key, required this.residence}) : super(key: key);

  @override
  State<HomeDetails> createState() => _HomeDetailsState();
}

class _HomeDetailsState extends State<HomeDetails> {
  ScrollController scrollController = ScrollController();
  final price = NumberFormat("#,###", "en_US");
  UserModel user = UserModel();
  String salesmanPhoneNumber = '';
  List<ResidenceModel> residencesForAuction = [];
  List<ResidenceModel> allResidences = [];

  @override
  void initState() {
    super.initState();
    getSalesmanNumber();
    getUser();
  }

  getSalesmanNumber() async {
    final salesman =
        await CrudEmployee().getEmployee(widget.residence.idSalesman!);
    salesmanPhoneNumber = salesman.businessNumber!;
    setState(() {});
  }

  getUser() async {
    user = await UserPreferences().loadData();
    setState(() {});
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
        backgroundColor: Colors.white,
        appBar: getAppBar(),
        body: Container(
            padding: const EdgeInsets.symmetric(), child: buildDetals()),
        bottomNavigationBar: _contactAdviser(),
      ),
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

  Widget _contactAdviser() {
    final userProvider = Provider.of<UserProvider>(context);
    user = userProvider.user;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.16),
                    offset: const Offset(5, 6),
                    blurRadius: 11)
              ]),
          child: CircleAvatar(
            backgroundColor: MyColors.blue2,
            radius: 19,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 17,
              child: SvgPicture.asset('assets/Icons/Compartir.svg',
                  height: 24, width: 24, color: MyColors.blue2),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (user.email != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ShowDates(model: widget.residence, user: user),
                  ));
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VerifyUser(
                    user: user,
                  ),
                ),
              );
            }
          },
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              height: 38,
              decoration: BoxDecoration(
                  color: MyColors.fuchsia,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.16),
                        offset: const Offset(5, 6),
                        blurRadius: 11)
                  ]),
              child: Center(
                  child: Text('Solicitar Recorrido',
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)))),
        ),
        GestureDetector(
            onTap: () {
              openWhatsapp();
            },
            child: CircleAvatar(
              radius: 17,
              backgroundColor: Colors.white,
              child: Image.asset('assets/Icons/whatsappIcon.png'),
            )),
        user.email != null
            ? GestureDetector(
                onTap: () async {
                  if (user.userScheduledProperties!
                      .contains(widget.residence.id)) {
                    user.userScheduledProperties!.remove(widget.residence.id!);
                  } else {
                    user.userScheduledProperties!.add(widget.residence.id!);
                  }
                  userProvider.setUser(user);
                  await UserPreferences().saveData(user);
                  await UserCrud().updateUser(user.id!, user);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                            color: user.userScheduledProperties!
                                    .contains(widget.residence.id)
                                ? MyColors.fuchsia.withOpacity(0.16)
                                : Colors.black.withOpacity(0.16),
                            offset: const Offset(2, 2),
                            blurRadius: 2)
                      ]),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 19,
                    child: CircleAvatar(
                      backgroundColor:
                          user.userLikes!.contains(widget.residence.id)
                              ? MyColors.fuchsia
                              : MyColors.grey.withOpacity(0.84),
                      radius: 17,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: SvgPicture.asset('assets/Icons/Me Gusta.svg',
                            height: 22, width: 22, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              )
            : GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VerifyUser(
                        user: user,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.16),
                            offset: const Offset(2, 2),
                            blurRadius: 2)
                      ]),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 19,
                    child: CircleAvatar(
                      backgroundColor: MyColors.grey.withOpacity(0.84),
                      radius: 17,
                      child: SvgPicture.asset('assets/Icons/MisFavoritos.svg',
                          height: 24, width: 24, color: Colors.white),
                    ),
                  ),
                ),
              )
      ]),
    );
  }

  openWhatsapp() async {
    var number = '+57' + salesmanPhoneNumber;
    var message = "Hola!, estoy interesado en " + widget.residence.name!;
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

  Widget buildDetals() {
    return Stack(children: [
      SingleChildScrollView(
        controller: scrollController,
        child: Column(children: [
          const SizedBox(height: 40),
          Align(
              alignment: Alignment.topCenter,
              child: DetailsBar(
                  area: widget.residence.area!,
                  baths: widget.residence.bath!,
                  rooms: widget.residence.room!,
                  garages: widget.residence.garage!)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(children: [
              _threeImages(),
              _homeName(),
              _availability(),
              _homeType(),
              _features(),
              _commonAreas(),
              _rentalManagement(),
              _location(),
              _areaInformation(),
              _description(),
              _financing(),
              _infrastructure(),
            ]),
          )
        ]),
      ),
      _backButton(),
    ]);
  }

  Widget _backButton() {
    final size = MediaQuery.of(context).size;
    return Positioned(
      top: -50,
      left: size.width / 2.5,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
              context, 'home_page', (route) => false);
        },
        child: Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: MyColors.blueMarine, width: 3),
              boxShadow: [
                BoxShadow(
                  color: MyColors.shadow.withOpacity(0.16),
                  offset: const Offset(3, 6),
                  blurRadius: 16,
                )
              ]),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: RotatedBox(
              quarterTurns: -3,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: SvgPicture.asset('assets/Icons/Next.svg',
                      height: 20, width: 20, color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _threeImages() {
    final size = MediaQuery.of(context).size;
    var imageList = [];
    var count = 0;
    for (var i = 0; i < widget.residence.stories!.length; i++) {
      if (widget.residence.stories![i].media == MediaType.image) {
        imageList.add(widget.residence.stories![i].url);
        count = count + 1;
        i = (count == 3) ? widget.residence.stories!.length : i;
      }
    }
    return Stack(
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 4, bottom: 15),
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: imageList[0],
                  imageBuilder: (context, imageProvider) => Container(
                    height: size.height / 3 - 20,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        )),
                  ),
                  fadeInDuration: const Duration(microseconds: 0),
                  fadeOutDuration: const Duration(milliseconds: 0),
                  placeholder: (context, url) => Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => SvgPicture.asset(
                    'assets/Icons/LogoSVG.svg',
                    width: 30,
                    height: 30,
                    color: MyColors.blue2,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4, bottom: 10),
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: imageList[1],
                  imageBuilder: (context, imageProvider) => Container(
                    height: size.height / 3 + 20,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        )),
                  ),
                  fadeInDuration: const Duration(microseconds: 0),
                  fadeOutDuration: const Duration(milliseconds: 0),
                  placeholder: (context, url) => Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => SvgPicture.asset(
                    'assets/Icons/LogoSVG.svg',
                    width: 30,
                    height: 30,
                    color: MyColors.blue2,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 15),
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: imageList[2],
                  imageBuilder: (context, imageProvider) => Container(
                    height: size.height / 3 - 20,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        )),
                  ),
                  fadeInDuration: const Duration(microseconds: 0),
                  fadeOutDuration: const Duration(milliseconds: 0),
                  placeholder: (context, url) => Container(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => SvgPicture.asset(
                    'assets/Icons/LogoSVG.svg',
                    width: 30,
                    height: 30,
                    color: MyColors.blue2,
                  ),
                ),
              ),
            ),
          )
        ]),
        Align(
            alignment: const Alignment(0, 0),
            child: Padding(
              padding: EdgeInsets.only(top: (size.height / 3) - 10),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: MyColors.blue2,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 12),
                      child: Text(
                          '\$' +
                              price
                                  .format(widget.residence.baseAuctionPrice)
                                  .toString(),
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _homeName() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(children: [
        Text(widget.residence.name!,
            style: GoogleFonts.montserrat(
                color: MyColors.blue2,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(widget.residence.location!,
            style: GoogleFonts.montserrat(
                color: MyColors.blue2,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
        Text(widget.residence.city!,
            style: GoogleFonts.montserrat(
                color: MyColors.blue2,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
      ]),
    );
  }

  void startTimer() {
    /*
    final provider = Provider.of<HomeDetailController>(context);
    if (provider.secondsDifference > 0) {
      timer = Timer.periodic(Duration(seconds: 1), (_) {
        setState(() {
          provider.calculateDifference(timeLeft);
        });
      });
    }
    */
  }

  Widget _availability() {
    final auctionDate = DateTime.parse(widget.residence.auctionDate!);
    return Column(
      children: [
        Text(
          'Disponibilidad',
          style: GoogleFonts.montserrat(
              color: MyColors.blue2, fontSize: 16, fontWeight: FontWeight.w800),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Subasta en: ',
                        style: GoogleFonts.montserrat(
                            color: MyColors.blue2,
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
                    TextSpan(
                        text:
                            widget.residence.availability!.contains('Arriendo')
                                ? 'Arriendo'
                                : widget.residence.availability!,
                        style: GoogleFonts.montserrat(
                            color: MyColors.blueMarine,
                            fontSize: 14,
                            fontWeight: FontWeight.w900)),
                  ]),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  children: [
                    Text(
                      'Inicia el ' + JsonConst.dateToDay(auctionDate),
                      style: GoogleFonts.montserrat(
                          color: MyColors.blue2,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      auctionDate.day.toString() +
                          ' ' +
                          JsonConst.dateToShortMonth(auctionDate) +
                          ' ' +
                          auctionDate.hour.toString() +
                          ':00 PM',
                      style: GoogleFonts.montserrat(
                          color: MyColors.blue2,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
                primary: MyColors.fuchsia,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            onPressed: () async {
              if (user.email != null && user.email != '') {
                residencesForAuction = await ResidenceCrud()
                    .getResidencesOfAuctionDate(widget.residence.auctionDate!);
                allResidences = await ResidenceCrud()
                    .getResidencesOfStateInApp('Publicada');
                List<ResidenceModel> newList = [];
                for (var i = 0; i < residencesForAuction.length; i++) {
                  if (residencesForAuction[i].typeOfAuction == 'Subasta') {
                    newList.add(residencesForAuction[i]);
                  }
                }
                if (widget.residence.typeOfAuction == 'Subasta') {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OfferListClass(
                                residenceModel: widget.residence,
                                user: user,
                              )),
                      (_) => false);
                } else if (widget.residence.typeOfAuction == 'Express') {
                  List<ResidenceModel> newList = [];
                  for (var j = 0; j < allResidences.length; j++) {
                    if (allResidences[j].typeOfAuction == 'Express') {
                      newList.add(allResidences[j]);
                    }
                  }
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OfferListRentPage(
                                residenceModel: widget.residence,
                                user: user,
                              )),
                      (_) => false);
                }
              } else {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VerifyUser(user: user),
                    ),
                    (_) => false);
              }
            },
            child: Text('Ofertar',
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _homeType() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Column(children: [
          Text("Tipo de residencia",
              style: GoogleFonts.montserrat(
                  color: MyColors.blue2,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                  color: MyColors.whiteBox,
                  borderRadius: BorderRadius.circular(15)),
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Text(widget.residence.typeOfResidence!,
                  style: GoogleFonts.montserrat(
                      color: MyColors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center),
            ),
          )
        ]),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(children: [
                  Text("Estado",
                      style: GoogleFonts.montserrat(
                          color: MyColors.blue2,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: MyColors.whiteBox,
                        borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Text(widget.residence.condition!,
                        style: GoogleFonts.montserrat(
                            color: MyColors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center),
                  )
                ]),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(children: [
                  Text("Estado",
                      style: GoogleFonts.montserrat(
                          color: MyColors.blue2,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: MyColors.whiteBox,
                        borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Text(widget.residence.stratum.toString(),
                        style: GoogleFonts.montserrat(
                            color: MyColors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center),
                  )
                ]),
              ),
            )
          ],
        ),
      ]),
    );
  }

  Widget _features() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: MyColors.shadow.withOpacity(0.16),
                  offset: const Offset(5, 6),
                  blurRadius: 11,
                  spreadRadius: 0)
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            children: [
              Text("Características",
                  style: GoogleFonts.montserrat(
                      color: MyColors.blue2,
                      fontSize: 16,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 20),
              MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                controller: scrollController,
                shrinkWrap: true,
                itemCount: widget.residence.features!.length,
                itemBuilder: (context, index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 4,
                        child: SvgPicture.asset(
                          widget.residence.featuresSVG![index],
                          height: 20,
                          width: 20,
                          color: MyColors.blue2,
                        ),
                      ),
                      const Expanded(
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 16,
                        child: Text(widget.residence.features![index],
                            style: GoogleFonts.montserrat(
                                color: MyColors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _commonAreas() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: MyColors.shadow.withOpacity(0.16),
                  offset: const Offset(5, 6),
                  blurRadius: 11,
                  spreadRadius: 0)
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            children: [
              Text("Zonas comunes",
                  style: GoogleFonts.montserrat(
                      color: MyColors.blue2,
                      fontSize: 16,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 20),
              MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                controller: scrollController,
                itemCount: widget.residence.commonAreas!.length,
                itemBuilder: (context, index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 4,
                        child: SvgPicture.asset(
                          widget.residence.commonAreasSVG![index],
                          height: 20,
                          width: 20,
                          color: MyColors.blue2,
                        ),
                      ),
                      const Expanded(
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 16,
                        child: Text(widget.residence.commonAreas![index],
                            style: GoogleFonts.montserrat(
                                color: MyColors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rentalManagement() {
    return widget.residence.typeOfResidence == 'Apartamento'
        ? Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'Valor MENSUAL de administración',
                style: GoogleFonts.montserrat(
                    color: MyColors.blue2,
                    fontSize: 16,
                    fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: MyColors.whiteBox,
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      '\$' +
                          price
                              .format(widget.residence.baseAuctionPrice)
                              .toString(),
                      style: GoogleFonts.montserrat(
                          color: MyColors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            ],
          )
        : const SizedBox();
  }

  Widget _location() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.16),
                  offset: const Offset(5, 6),
                  blurRadius: 11)
            ]),
        child: Column(children: [
          const SizedBox(height: 15),
          Text('Ubicación',
              style: GoogleFonts.montserrat(
                  color: MyColors.blue2,
                  fontSize: 16,
                  fontWeight: FontWeight.w800),
              textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            widget.residence.location == ''
                ? const Text('')
                : Text(widget.residence.location!,
                    style: GoogleFonts.montserrat(
                        color: MyColors.blue2.withOpacity(0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
            widget.residence.neighborhood == ''
                ? const Text('')
                : Text(", " + widget.residence.neighborhood!,
                    style: GoogleFonts.montserrat(
                        color: MyColors.blue2.withOpacity(0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            widget.residence.city == ''
                ? const Text('')
                : Text(widget.residence.city!,
                    style: GoogleFonts.montserrat(
                        color: MyColors.blue2.withOpacity(0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
            widget.residence.state == ''
                ? const Text('')
                : Text(", " + widget.residence.state!,
                    style: GoogleFonts.montserrat(
                        color: MyColors.blue2.withOpacity(0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
            widget.residence.country == ''
                ? const Text('')
                : Text(", " + widget.residence.country!,
                    style: GoogleFonts.montserrat(
                        color: MyColors.blue2.withOpacity(0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 10),
          Container(
              width: double.maxFinite,
              height: 200,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://elcomercio.pe/resizer/OmdsixTC0G1Rc2rZS63JEalTb6E=/980x528/smart/filters:format(jpeg):quality(75)/arc-anglerfish-arc2-prod-elcomercio.s3.amazonaws.com/public/A5QUERQJSVBXBL6W56TX5IF7FQ.jpg'),
                      fit: BoxFit.cover))),
          widget.residence.valuePerM2 != 0
              ? Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Valor por metro 2 en la zona',
                      style: GoogleFonts.montserrat(
                          color: MyColors.blue2,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            color: MyColors.whiteBox,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            '\$ ' +
                                price.format(widget.residence.valuePerM2) +
                                ' COP',
                            style: GoogleFonts.montserrat(
                                color: MyColors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                )
              : const Center()
        ]),
      ),
    );
  }

  Widget _areaInformation() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(children: [
        Text('Información de la zona',
            style: GoogleFonts.montserrat(
                color: MyColors.blue2,
                fontSize: 16,
                fontWeight: FontWeight.w800),
            textAlign: TextAlign.center),
        const SizedBox(height: 10),
        Text('Espacios estratégicos cercanos al inmueble',
            style: GoogleFonts.montserrat(
                color: MyColors.blue2,
                fontSize: 12,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.center),
        const SizedBox(height: 10),
        Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: MyColors.shadow.withOpacity(0.16),
                    offset: const Offset(5, 6),
                    blurRadius: 11)
              ]),
          child: Wrap(
              spacing: 8,
              runSpacing: -8,
              alignment: WrapAlignment.start,
              children: List.generate(
                  widget.residence.nearbySpaces!.length,
                  (index) => Chip(
                        backgroundColor: MyColors.whiteBox,
                        label: Text(
                          widget.residence.nearbySpaces![index],
                          style: GoogleFonts.montserrat(
                              color: MyColors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ))),
        )
      ]),
    );
  }

  Widget _description() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
      child: Column(children: [
        Text("Descripción",
            style: GoogleFonts.montserrat(
                color: MyColors.blue2,
                fontSize: 16,
                fontWeight: FontWeight.w800),
            textAlign: TextAlign.center),
        const SizedBox(height: 12),
        Text(widget.residence.description!,
            style: GoogleFonts.montserrat(
                color: MyColors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center),
      ]),
    );
  }

  Widget _financing() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: [
          Text("Financiación",
              style: GoogleFonts.montserrat(
                  color: MyColors.blue2,
                  fontSize: 16,
                  fontWeight: FontWeight.w800),
              textAlign: TextAlign.center),
          const SizedBox(height: 10),
          /*
          Container(
            width: size.width,
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
            child: Column(
              children: [
                const SizedBox(height: 15),
                Text("Subsidio",
                    style: GoogleFonts.montserrat(
                        color: MyColors.blue2,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: MyColors.whiteBox,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Text("VIS",
                          style: GoogleFonts.montserrat(
                              color: MyColors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 35),
                  child: Text(
                      "La vivienda VIS esta diseñada para compra de inmuebles accesibles y cuenta con ayudas e incentivos económicos que otorga el Gobierno, Cajas de Compensación y los municipios de manera permanente.",
                      style: GoogleFonts.montserrat(
                          color: MyColors.blue2,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center),
                ),

                const SizedBox(height: 5),
                
                Container(
                  width: size.width - 80,
                  height: 2,
                  color: MyColors.blue2,
                ),*/
          const SizedBox(height: 12),
          Text('Cuota Inicial',
              style: GoogleFonts.montserrat(
                  color: MyColors.blue2,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Expanded(
              flex: 10,
              child: Column(
                children: [
                  Text('Valor',
                      style: GoogleFonts.montserrat(
                          color: MyColors.blue2,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          color: MyColors.whiteBox,
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                            "\$ " +
                                price
                                    .format(widget.residence.initialFee)
                                    .toString(),
                            style: GoogleFonts.montserrat(
                                color: MyColors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  children: [
                    Text('Plazo',
                        style: GoogleFonts.montserrat(
                            color: MyColors.blue2,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 5),
                    Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          color: MyColors.whiteBox,
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text("6 Meses",
                            style: GoogleFonts.montserrat(
                                color: MyColors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ])
        ],
      ),
    );
  }

  Widget _infrastructure() {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: [
          Text('Infraestructura',
              style: GoogleFonts.montserrat(
                  color: MyColors.blue2,
                  fontSize: 16,
                  fontWeight: FontWeight.w800),
              textAlign: TextAlign.center),
          const SizedBox(height: 15),
          Container(
            width: size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: MyColors.shadow.withOpacity(0.16),
                      offset: const Offset(5, 6),
                      blurRadius: 11)
                ]),
            child: Column(children: [
              const SizedBox(height: 15),
              Text('Constructora',
                  style: GoogleFonts.montserrat(
                      color: MyColors.blue2,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: MyColors.whiteBox,
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: Text('Constructora FENIX S.A.S',
                        style: GoogleFonts.montserrat(
                            color: MyColors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text('Año de\n construcción / remodelación',
                  style: GoogleFonts.montserrat(
                      color: MyColors.blue2,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center),
              const SizedBox(height: 3),
              Container(
                decoration: BoxDecoration(
                    color: MyColors.whiteBox,
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3.0, horizontal: 30),
                  child: Text('2011',
                      style: GoogleFonts.montserrat(
                          color: MyColors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: size.width - 80,
                height: 2,
                color: MyColors.blue2,
              ),
              const SizedBox(height: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text('Area construida',
                          style: GoogleFonts.montserrat(
                              color: MyColors.blue2,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 3),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              color: MyColors.whiteBox,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0),
                            child: Text(
                                widget.residence.constructedArea.toString() +
                                    'mt2',
                                style: GoogleFonts.montserrat(
                                    color: MyColors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          Text('Area lote',
                              style: GoogleFonts.montserrat(
                                  color: MyColors.blue2,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 3),
                          Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                color: MyColors.whiteBox,
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 3.0),
                              child: Text(widget.residence.lotArea.toString(),
                                  style: GoogleFonts.montserrat(
                                      color: MyColors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          Text('# Niveles',
                              style: GoogleFonts.montserrat(
                                  color: MyColors.blue2,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 3),
                          Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                color: MyColors.whiteBox,
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 3.0),
                              child: Text(
                                  widget.residence.levelsNumber.toString(),
                                  style: GoogleFonts.montserrat(
                                      color: MyColors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20)
            ]),
          )
        ],
      ),
    );
  }
}
