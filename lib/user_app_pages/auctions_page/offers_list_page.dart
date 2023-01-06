// ignore_for_file: must_be_immutable, prefer_interpolation_to_compose_strings, use_build_context_synchronously, deprecated_member_use

import 'dart:developer';
import 'dart:io';

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:me_cuadra_users/models/complement_models/auction_participan.dart';
import 'package:me_cuadra_users/models/offer_model_cloud.dart';
import 'package:me_cuadra_users/services/firebase/crud_employee.dart';
import 'package:me_cuadra_users/services/firebase/offer_cloud_crud.dart';
import 'package:me_cuadra_users/services/firebase/residences_crud.dart';
import 'package:me_cuadra_users/services/firebase/user_crud.dart';
import 'package:me_cuadra_users/user_app_pages/user_login/verify_user.dart';
import 'package:me_cuadra_users/widgets/simple_dialog_success_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../colors/colors_data.dart';
import '../../../models/offer_model.dart';
import '../../../widgets/simple_error_dialog_widget.dart';
import '../../models/residence_model.dart';
import '../../models/user_model.dart';
import '../../preferences/user_preference.dart';
import '../../services/const/json_const.dart';
import '../../services/firebase/offer_crud.dart';
import '../../utils/youtubeToUid.dart';
import '../../widgets/offer_widget.dart';
import 'offers_page.dart';

class OfferListClass extends StatefulWidget {
  ResidenceModel residenceModel;
  UserModel user;
  OfferListClass({Key? key, required this.residenceModel, required this.user})
      : super(key: key);

  @override
  State<OfferListClass> createState() => _OfferListClassState();
}

class _OfferListClassState extends State<OfferListClass> {
  final price = NumberFormat("#,###", "en_US");
  ScrollController scrollController = ScrollController();
  List<OfferDB> offerList = [];
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId:
          YoutubeMethods.convertUrlToId(widget.residenceModel.auctionLink!)!,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: true,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {});
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
        onExitFullScreen: () {
          SystemChrome.setPreferredOrientations(DeviceOrientation.values);
        },
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.blueAccent,
          topActions: <Widget>[
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                _controller.metadata.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
                size: 25.0,
              ),
              onPressed: () {
                log('Settings Tapped!');
              },
            ),
          ],
          onReady: () {
            _isPlayerReady = true;
          },
        ),
        builder: (context, player) => WillPopScope(
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
                            player,
                            const SizedBox(height: 10),
                            Text('Ofertas',
                                style: GoogleFonts.montserrat(
                                    color: MyColors.blue2,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700)),
                            //for (int i = 0; i < offerList.length; i++)
                            //offerWidget(offerList[i])
                            _listenOffers()
                          ],
                        ),
                      ),
                      _offerButton()
                    ],
                  )),
            ));
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
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyUser(
            user: userModel,
          ),
        ),
        (_) => false);
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
    });
    return Expanded(
      child: FirebaseAnimatedList(
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollGoBottom());
    bool isRegister = false;
    String requestState = '';

    return Align(
      alignment: const Alignment(0, 0.98),
      child: GestureDetector(
        onTap: () async {
          ResidenceModel lastResiden =
              await ResidenceCrud().getResidence(widget.residenceModel.id!);
          if (lastResiden.auctionParticipants!.isNotEmpty) {
            for (var i = 0; i < lastResiden.auctionParticipants!.length; i++) {
              if (lastResiden.auctionParticipants![i].idUser ==
                  widget.user.id!) {
                isRegister = true;
                requestState =
                    lastResiden.auctionParticipants![i].requestState!;
              }
            }
          }

          if (lastResiden.auctionState == 'Iniciada') {
            if (isRegister) {
              if (requestState == 'Aprobado') {
                final user = await UserPreferences().loadData();
                OfferModel offerModel = OfferModel('', '', 0, 0, '');
                OfferModelCloud offersOfResidence =
                    await OfferCloudCrud().getOffer(widget.residenceModel.id!);
                if (offersOfResidence.idResidence != null) {
                  offerModel = offersOfResidence.offers!.last;
                  final query =
                      OfferCrud().getOffers(widget.residenceModel.id!);
                  if (offerModel.idUser != user.id) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => OfferPage(
                                  model: lastResiden,
                                  offerQuery: query,
                                  lastOffer: offerModel,
                                ))));
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => SimpleErrorDialogWidget(
                            description:
                                "Tu oferta es la más alta\nhasta el momento"));
                  }
                } else {
                  if (offerModel.idUser != user.id) {
                    final query =
                        OfferCrud().getOffers(widget.residenceModel.id!);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => OfferPage(
                                  model: lastResiden,
                                  offerQuery: query,
                                  lastOffer: offerModel,
                                ))));
                  }
                }
              } else if (requestState == 'Revisión') {
                showDialog(
                    context: context,
                    builder: (context) => _rejectedRequest(
                        "Su solicitud se encuentra en Revisión",
                        "Pongase en contacto con nuestro auxiliar administrativo para más información",
                        Icons.close_rounded,
                        widget.user,
                        widget.residenceModel));
              } else {
                showDialog(
                    context: context,
                    builder: (context) => _rejectedRequest(
                        "Su solicitud ha sido rechazada",
                        "Pongase en contacto con nuestro auxiliar administrativo para más información",
                        Icons.close_rounded,
                        widget.user,
                        widget.residenceModel));
              }
            } else {
              showDialog(
                  context: context,
                  builder: (context) => _errorMessageWithButtons(
                      "No estas registrado en la subasta",
                      "¿Deseas enviar tu solicitud de registro?\n Uno de nuestros trabajadores te contactará para validar tu información",
                      Icons.close_rounded,
                      widget.user,
                      widget.residenceModel));
            }
          } else if (widget.residenceModel.auctionState == 'Finalizada') {
            showDialog(
                context: context,
                builder: (context) =>
                    SimpleErrorDialogWidget(description: "Subasta finalizada"));
          } else if (widget.residenceModel.auctionState == '') {
            showDialog(
                context: context,
                builder: (context) => SimpleErrorDialogWidget(
                    description: "Subasta no ha iniciado"));
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
                color: MyColors.fuchsia,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                      color: MyColors.shadow.withOpacity(0.16),
                      offset: const Offset(5, 6),
                      blurRadius: 11)
                ]),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20),
              child: Text(
                'Ofertar',
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
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

  void _scrollGoBottom() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
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
                                vertical: 7, horizontal: 20),
                            primary: MyColors.fuchsia,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0))),
                        onPressed: () {
                          AuctionParticipant participant = AuctionParticipant(
                            idUser: userModel.id,
                            userName: userModel.userName,
                            userImage: userModel.photoURL,
                            userMail: userModel.email,
                            userPhoneNumber: userModel.phoneNumber.toString(),
                            requestDate: DateTime.now().toString(),
                            requestState: 'Revisión',
                          );
                          if (rModel.auctionParticipants!.isNotEmpty) {
                            if (rModel.auctionParticipants![0].idUser == '') {
                              rModel.auctionParticipants![0] = participant;
                              ResidenceCrud()
                                  .updateResidence(rModel.id!, rModel);
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
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (context) =>
                                      SimpleSuccessDialogWidget(
                                          description: "Solicitud enviada"));
                            }
                          } else {
                            rModel.auctionParticipants!.add(participant);
                            ResidenceCrud().updateResidence(rModel.id!, rModel);
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (context) => SimpleSuccessDialogWidget(
                                    description: "Solicitud enviada"));
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
