import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:me_cuadra_users/user_app_pages/profile_views/profile_information.dart';
import 'package:me_cuadra_users/user_app_pages/profile_views/profile_pages/profile_drawer.dart';
import 'package:me_cuadra_users/user_app_pages/profile_views/send_property_request.dart';
import 'package:me_cuadra_users/widgets/simple_error_dialog_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../models/residence_model.dart';
import '../../../colors/colors_data.dart';
import '../../../models/user_model.dart';
import '../../../providers/user_provider.dart';
import '../../../services/firebase/residences_crud.dart';
import '../../property_information_pages/home_details_page.dart';

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  UserModel user;
  bool isWantedToOffer;
  ProfilePage({Key? key, required this.user, required this.isWantedToOffer})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //booleanos para contralar los tres estados en la ventana de perfil
  bool _myHome = false;
  bool _homeLikes = true;
  bool _homeFavs = false;
  int userProperties = 0;

  late ScrollController _controller;
  List<ResidenceModel> myPropertiesList = [];
  List<ResidenceModel> myFavoritesList = [];
  List<ResidenceModel> myLikesList = [];

  @override
  void initState() {
    super.initState();
    if (widget.isWantedToOffer) {
      _myHome = true;
      _homeLikes = false;
      _homeFavs = false;
    }
    _controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        await userProvider.getUserFromPreference();
        Navigator.pushNamedAndRemoveUntil(
            context, 'home_page', (route) => false);

        return false;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            openWhatsapp();
          },
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Image.asset('assets/Icons/whatsappIcon.png'),
          ),
        ),
        backgroundColor: Colors.white,
        appBar: getAppBar(),
        body: Stack(
          children: [
            SingleChildScrollView(
                controller: _controller,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Stack(
                        children: [
                          Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: MyColors.shadow.withOpacity(0.16),
                                    offset: const Offset(4, 4),
                                    blurRadius: 18,
                                    spreadRadius: 1)
                              ],
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20)),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Material(
                                  shape: const CircleBorder(),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: InkWell(
                                    splashColor: Colors.black26,
                                    onTap: () async {
                                      await userProvider
                                          .getUserFromPreference();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileInformation(
                                                      user: widget.user)));
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl: userProvider.user.photoURL !=
                                                  null &&
                                              userProvider.user.photoURL != ''
                                          ? userProvider.user.photoURL!
                                          : widget.user.photoURL!,
                                      imageBuilder: (context, imageProvider) =>
                                          Ink.image(
                                        image: imageProvider,
                                        height: 140,
                                        width: 140,
                                        fit: BoxFit.cover,
                                      ),
                                      fadeInDuration:
                                          const Duration(microseconds: 0),
                                      fadeOutDuration:
                                          const Duration(milliseconds: 0),
                                      placeholder: (context, url) => Container(
                                        alignment: Alignment.center,
                                        child:
                                            const CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          SvgPicture.asset(
                                        'assets/LogoM.svg',
                                        width: 30,
                                        height: 30,
                                        color: MyColors.blue2,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.user.userName!,
                                  style: GoogleFonts.montserrat(
                                      color: MyColors.blue2,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  widget.user.email!,
                                  style: GoogleFonts.montserrat(
                                      color: MyColors.blue2,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ),
                                _userLocation(),
                                const SizedBox(height: 8),
                                Container(
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(23),
                                      border: Border.all(
                                          color: MyColors.blueMarine, width: 2),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                MyColors.grey.withOpacity(0.1),
                                            offset: const Offset(0, 0),
                                            blurRadius: 11)
                                      ]),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              if (_myHome) {
                                              } else {
                                                setState(() {
                                                  _myHome = true;
                                                  _homeLikes = false;
                                                  _homeFavs = false;
                                                });
                                              }
                                            },
                                            child: Stack(
                                              children: [
                                                Container(
                                                  width: double.maxFinite,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      border: _myHome
                                                          ? Border.all(
                                                              color: MyColors
                                                                  .blueMarine,
                                                              width: 5)
                                                          : Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              21)),
                                                  child: Container(
                                                    width: 2,
                                                    height: 2,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color:
                                                            MyColors.whiteBox),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 6, right: 5),
                                                      child: Text(
                                                          widget
                                                              .user
                                                              .userProperties!
                                                              .length
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  color:
                                                                      MyColors
                                                                          .grey,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                          textAlign:
                                                              TextAlign.right),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 6,
                                                  top: 3,
                                                  child: Container(
                                                    height: 33,
                                                    width: 33,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: MyColors
                                                                  .shadow
                                                                  .withOpacity(
                                                                      0.16),
                                                              offset:
                                                                  const Offset(
                                                                      2, 2),
                                                              spreadRadius: 0)
                                                        ]),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: SvgPicture.asset(
                                                        'assets/Icons/Mispropiedades.svg',
                                                        color: MyColors.blue2,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              if (_homeLikes == true) {
                                              } else {
                                                setState(() {
                                                  _myHome = false;
                                                  _homeLikes = true;
                                                  _homeFavs = false;
                                                });
                                              }
                                            },
                                            child: Stack(
                                              children: [
                                                Container(
                                                  width: double.maxFinite,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      border: _homeLikes
                                                          ? Border.all(
                                                              color: MyColors
                                                                  .blueMarine,
                                                              width: 5)
                                                          : Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              21)),
                                                  child: Container(
                                                    width: 2,
                                                    height: 2,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(21),
                                                        color:
                                                            MyColors.whiteBox),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 6, right: 5),
                                                      child: Text(
                                                          widget.user.userLikes!
                                                              .length
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  color:
                                                                      MyColors
                                                                          .grey,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                          textAlign:
                                                              TextAlign.right),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 6,
                                                  top: 3,
                                                  child: Container(
                                                    height: 33,
                                                    width: 33,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: MyColors
                                                                  .shadow
                                                                  .withOpacity(
                                                                      0.16),
                                                              offset:
                                                                  const Offset(
                                                                      2, 2),
                                                              blurRadius: 2)
                                                        ]),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: SvgPicture.asset(
                                                        'assets/Icons/Me Gusta.svg',
                                                        color: MyColors.blue2,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              if (_homeFavs) {
                                              } else {
                                                setState(() {
                                                  _myHome = false;
                                                  _homeLikes = false;
                                                  _homeFavs = true;
                                                });
                                              }
                                            },
                                            child: Stack(
                                              children: [
                                                Container(
                                                  width: double.maxFinite,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      border: _homeFavs
                                                          ? Border.all(
                                                              color: MyColors
                                                                  .blueMarine,
                                                              width: 5)
                                                          : Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              21)),
                                                  child: Container(
                                                    width: 2,
                                                    height: 2,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color:
                                                            MyColors.whiteBox),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 6, right: 5),
                                                      child: Text(
                                                          widget
                                                              .user
                                                              .userScheduledProperties!
                                                              .length
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  color:
                                                                      MyColors
                                                                          .grey,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                          textAlign:
                                                              TextAlign.right),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 6,
                                                  top: 3,
                                                  child: Container(
                                                    height: 33,
                                                    width: 33,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: MyColors
                                                                  .shadow
                                                                  .withOpacity(
                                                                      0.16),
                                                              offset:
                                                                  const Offset(
                                                                      2, 2),
                                                              blurRadius: 2)
                                                        ]),
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.all(0.0),
                                                      child: Icon(Icons
                                                          .calendar_month_rounded),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ]),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 4,
                            top: 8,
                            child: InkWell(
                              onTap: () async {
                                await userProvider.getUserFromPreference();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProfileInformation(
                                                user: widget.user)));
                              },
                              child: const Icon(
                                Icons.more_vert,
                                size: 28,
                                color: MyColors.blue2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _myHome ? _homeForSale() : _empty(),
                    _homeLikes ? _homeLikesImgs() : _empty(),
                    _homeFavs ? _homeFavsImgs() : _empty(),
                  ],
                )),
            // Align(
            //     alignment: const Alignment(-0.3, 0.94),
            //     child: Padding(
            //       padding: const EdgeInsets.only(left: 40.0, right: 100),
            //       child: ElevatedButton(
            //         style: ElevatedButton.styleFrom(
            //             minimumSize: const Size.fromHeight(40),
            //             primary: MyColors.fuchsia,
            //             shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(15.0))),
            //         onPressed: () {
            //           Navigator.pushAndRemoveUntil(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (context) =>
            //                     SendPropertyRequest(user: widget.user),
            //               ),
            //               (route) => false);
            //         },

            //       ),
            //     ))
          ],
        ),
        drawer: Drawer(
            backgroundColor: MyColors.blueMarine,
            width: 270,
            child: SingleChildScrollView(
              child: Column(children: [
                ProfileDrawer(user: widget.user),
              ]),
            )),
      ),
    );
  }

  AppBar getAppBar() {
    final userProvider = Provider.of<UserProvider>(context);
    return AppBar(
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/', ModalRoute.withName('/'));
          },
          child: SvgPicture.asset(
            'assets/Icons/LogoSVG.svg',
            width: 30,
            height: 30,
            color: MyColors.blue2,
          ),
        ));
  }

  Widget _empty() {
    return Container();
  }

  openWhatsapp() async {
    var number = "+573166345286";
    var message = "Buenos dias, estoy interesado en";
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

  Widget _userLocation() {
    return widget.user.phoneNumber != ''
        ? Column(children: [
            const SizedBox(height: 8),
            widget.user.phoneNumber != ''
                ? Text(
                    widget.user.phoneNumber!,
                    style: GoogleFonts.montserrat(
                        color: MyColors.blue2,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  )
                : const Center(),
          ])
        : const Center();
  }

  Widget _homeLikesImgs() {
    return Column(
      children: [
        Text('Me cuadra',
            style: GoogleFonts.montserrat(
                color: MyColors.blue2,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        _buildLikesFuture(),
      ],
    );
  }

  Widget _homeForSale() {
    return Column(
      children: [
        Text('Mis propiedades',
            style: GoogleFonts.montserrat(
                color: MyColors.blue2,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        _buildMyPropersFuture(),
      ],
    );
  }

  Widget _homeFavsImgs() {
    return Column(
      children: [
        Text('Favoritos',
            style: GoogleFonts.montserrat(
                color: MyColors.blue2,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        _buildFavsFuture(),
      ],
    );
  }

  Widget _buildMyPropersFuture() {
    return myPropertiesList.isEmpty
        ? FutureBuilder(
            future: getMyProperties(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 15),
                    child: MasonryGridView.count(
                      controller: _controller,
                      shrinkWrap: true,
                      itemCount: myPropertiesList.length,
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      itemBuilder: (context, index) =>
                          _propertyCard(myPropertiesList[index]),
                    ));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                return Center(
                    child: Text(
                  'No se han agregado propiedades a favoritos',
                  style: GoogleFonts.montserrat(
                      fontSize: 24,
                      color: MyColors.blue2,
                      fontWeight: FontWeight.w900),
                ));
              }
            })
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            child: MasonryGridView.count(
              controller: _controller,
              shrinkWrap: true,
              itemCount: myPropertiesList.length,
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              itemBuilder: (context, index) =>
                  _propertyCard(myPropertiesList[index]),
            ));
  }

  Widget _buildLikesFuture() {
    return myLikesList.isEmpty
        ? FutureBuilder(
            future: getLikesProperties(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 15),
                    child: MasonryGridView.count(
                      controller: _controller,
                      shrinkWrap: true,
                      itemCount: myLikesList.length,
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      itemBuilder: (context, index) =>
                          propertyLike(myLikesList[index]),
                    ));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                return Center(
                    child: Text(
                  'No se han agregado propiedades a favoritos',
                  style: GoogleFonts.montserrat(
                      fontSize: 24,
                      color: MyColors.blue2,
                      fontWeight: FontWeight.w900),
                ));
              }
            })
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            child: MasonryGridView.count(
              controller: _controller,
              shrinkWrap: true,
              itemCount: myLikesList.length,
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              itemBuilder: (context, index) => propertyLike(myLikesList[index]),
            ));
  }

  Widget _buildFavsFuture() {
    return myFavoritesList.isEmpty
        ? FutureBuilder(
            future: getFavProperties(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 15),
                    child: MasonryGridView.count(
                      controller: _controller,
                      shrinkWrap: true,
                      itemCount: myFavoritesList.length,
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      itemBuilder: (context, index) =>
                          propertyLike(myFavoritesList[index]),
                    ));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                return Center(
                    child: Text(
                  'No se han agregado propiedades a favoritos',
                  style: GoogleFonts.montserrat(
                      fontSize: 24,
                      color: MyColors.blue2,
                      fontWeight: FontWeight.w900),
                ));
              }
            })
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            child: MasonryGridView.count(
              controller: _controller,
              shrinkWrap: true,
              itemCount: myFavoritesList.length,
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              itemBuilder: (context, index) =>
                  propertyLike(myFavoritesList[index]),
            ));
  }

  Future<List<ResidenceModel>> getMyProperties() async {
    myPropertiesList = [];
    if (widget.user.userProperties!.isNotEmpty) {
      ResidenceModel rModel = ResidenceModel();
      for (var i = 0; i < widget.user.userProperties!.length; i++) {
        rModel =
            await ResidenceCrud().getResidence(widget.user.userProperties![i]);
        myPropertiesList.add(rModel);
      }
    }
    return myPropertiesList;
  }

  Future<List<ResidenceModel>> getLikesProperties() async {
    myLikesList = [];
    if (widget.user.userLikes!.isNotEmpty) {
      ResidenceModel rModel = ResidenceModel();
      for (var i = 0; i < widget.user.userLikes!.length; i++) {
        rModel = await ResidenceCrud().getResidence(widget.user.userLikes![i]);
        myLikesList.add(rModel);
      }
    }
    return myLikesList;
  }

  Future<List<ResidenceModel>> getFavProperties() async {
    myFavoritesList = [];
    if (widget.user.userScheduledProperties!.isNotEmpty) {
      ResidenceModel rModel = ResidenceModel();
      for (var i = 0; i < widget.user.userScheduledProperties!.length; i++) {
        rModel = await ResidenceCrud()
            .getResidence(widget.user.userScheduledProperties![i]);
        myFavoritesList.add(rModel);
      }
    }
    return myFavoritesList;
  }

  Widget _propertyCard(ResidenceModel model) {
    final size = MediaQuery.of(context).size;
    String firstImage =
        'https://static3.depositphotos.com/1006110/262/i/600/depositphotos_2628115-stock-photo-entryway-in-upscale-home.jpg';
    for (var i = 0; i < model.stories!.length; i++) {
      if (model.stories![i].imageName != '') {
        firstImage = model.stories![i].url!;
        i = model.stories!.length;
      }
    }
    return Material(
      color: MyColors.whiteBox,
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        splashColor: MyColors.whiteBox,
        onTap: () {
          if (model.stateInApp != 'Solicitud' &&
              model.stateInApp != 'Asignada' &&
              model.stateInApp != 'Creación' &&
              model.stateInApp != 'Revisión') {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeDetails(
                    residence: model,
                  ),
                ));
          } else {
            showDialog(
                context: context,
                builder: (context) => SimpleErrorDialogWidget(
                    description: "Su propiedad aún no ha sido publicada"));
          }
        },
        child: CachedNetworkImage(
          imageUrl: firstImage,
          color: MyColors.fuchsia,
          imageBuilder: (context, imageProvider) => Column(
            children: [
              Ink.image(
                image: imageProvider,
                height: ((size.width - 40) / 3),
                fit: BoxFit.cover,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                      model.stateInApp == 'Asignada'
                          ? 'Creación'
                          : model.stateInApp!,
                      style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: MyColors.grey,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ],
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
    );
  }

  Widget propertyLike(ResidenceModel model) {
    final size = MediaQuery.of(context).size;
    String firstImage =
        'https://static3.depositphotos.com/1006110/262/i/600/depositphotos_2628115-stock-photo-entryway-in-upscale-home.jpg';
    for (var i = 0; i < model.stories!.length; i++) {
      if (model.stories![i].imageName != '') {
        firstImage = model.stories![i].url!;
        i = model.stories!.length;
      }
    }
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeDetails(
                residence: model,
              ),
            ));
      },
      child: CachedNetworkImage(
        imageUrl: firstImage,
        imageBuilder: (context, imageProvider) => Container(
          height: ((size.width - 40) / 3),
          width: double.maxFinite,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
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
    );
  }
}
