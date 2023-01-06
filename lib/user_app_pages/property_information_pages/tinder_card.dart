// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:me_cuadra_users/services/const/json_const.dart';
import 'package:me_cuadra_users/user_app_pages/auctions_page/auctions_rent/offer_list_rent_page.dart';
import 'package:me_cuadra_users/user_app_pages/auctions_page/offers_list_page.dart';
import 'package:me_cuadra_users/user_app_pages/user_login/verify_user.dart';
import 'package:me_cuadra_users/utils/youtubeToUid.dart';
import 'package:me_cuadra_users/widgets/vertical_details_bar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../colors/colors_data.dart';
import '../../dependencies/story_controller2.dart';
import '../../dependencies/story_view2.dart';
import '../../models/complement_models/story_model.dart';
import '../../models/residence_model.dart';
import '../../models/user_model.dart';
import '../../preferences/user_preference.dart';
import '../../providers/card_provider.dart';
import '../../providers/user_provider.dart';
import '../../services/firebase/crud_employee.dart';
import '../../services/firebase/residences_crud.dart';
import '../../services/firebase/user_crud.dart';
import 'home_details_page.dart';

class TinderCard extends StatefulWidget {
  final ResidenceModel residence;
  final bool isFront;
  const TinderCard({Key? key, required this.residence, required this.isFront})
      : super(key: key);

  @override
  State<TinderCard> createState() => _TinderCardState();
}

class _TinderCardState extends State<TinderCard> {
  UserModel user = UserModel();
  final StoryController2 controller = StoryController2();
  List<StoryItem2> storyItems = [];
  Duration auctionDuration = const Duration(seconds: 0);
  String salesmanPhoneNumber = '';
  bool isAuctionActive = false;
  bool isLoading = false;
  List<ResidenceModel> residencesForAuction = [];
  List<ResidenceModel> allResidences = [];
  @override
  void initState() {
    super.initState();
    getSalesmanNumber();
    List<String> videoListString = [];
    List<bool> isVideoList = [];
    for (var story in widget.residence.stories!) {
      if (story.media == MediaType.image) {
        isVideoList.add(false);
        videoListString.add(story.url!);
        storyItems.add(StoryItem2.pageProviderImage(story.url!));
      } else if (story.media == MediaType.video) {
        if (story.url!.contains('https://www.youtube.com/shorts/')) {
          story.url =
              story.url!.replaceAll('https://www.youtube.com/shorts/', '');
          videoListString.add(story.url!);
        } else {
          videoListString.add(YoutubeMethods.convertUrlToId(story.url!)!);
        }
        isVideoList.add(true);

        storyItems.add(StoryItem2.pageVideo(story.url!,
            controller: controller,
            isFront: widget.isFront,
            videoList: videoListString,
            isVideoList: isVideoList));
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;

      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
  }

  getSalesmanNumber() async {
    final salesman =
        await CrudEmployee().getEmployee(widget.residence.idSalesman!);
    salesmanPhoneNumber = salesman.businessNumber!;
    setState(() {});
  }

  getStoryItems() {
    storyItems = [];
    List<String> videoListString = [];
    List<bool> _isVideoList = [];
    for (var story in widget.residence.stories!) {
      if (story.media == MediaType.image) {
        _isVideoList.add(false);
        videoListString.add(story.url!);
        storyItems.add(StoryItem2.pageProviderImage(story.url!));
      } else if (story.media == MediaType.video) {
        _isVideoList.add(true);
        if (story.url!.contains('https://www.youtube.com/shorts/')) {
          story.url =
              story.url!.replaceAll('https://www.youtube.com/shorts/', '');
          videoListString.add(story.url!);
        } else {
          videoListString.add(YoutubeMethods.convertUrlToId(story.url!)!);
        }

        storyItems.add(StoryItem2.pageVideo(story.url!,
            controller: controller,
            isFront: widget.isFront,
            videoList: videoListString,
            isVideoList: _isVideoList));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: widget.isFront ? buildFrontCard() : buildCard(),
    );
  }

  Widget buildFrontCard() {
    final user = Provider.of<UserProvider>(context);
    return GestureDetector(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final provider = Provider.of<CardProvider>(context);
          final position = provider.position;
          final miliseconds = provider.isDragging ? 0 : 400;
          final center = constraints.smallest.center(Offset.zero);
          final angle = provider.angle * pi / 180;
          final rotatedMatrix = Matrix4.identity()
            ..translate(center.dx, center.dy)
            ..rotateZ(angle)
            ..translate(-center.dx, -center.dy);

          return AnimatedContainer(
              duration: Duration(milliseconds: miliseconds),
              curve: Curves.easeInOut,
              transform: rotatedMatrix..translate(position.dx, position.dy),
              child: Stack(children: [
                buildCard(),
                buildStamps(),
              ]));
        },
      ),
      onPanStart: (details) {
        final provider = Provider.of<CardProvider>(context, listen: false);
        provider.startPosition(details);
      },
      onPanUpdate: (details) {
        final provider = Provider.of<CardProvider>(context, listen: false);
        provider.updatePosition(details);
      },
      onPanEnd: (details) {
        final provider = Provider.of<CardProvider>(context, listen: false);
        provider.endPosition(details, user, widget.residence, context);
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildCard() {
    getStoryItems();
    final size = MediaQuery.of(context).size;
    return ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: Stack(children: [
          GestureDetector(
              onTapDown: (details) {
                final double dx = details.globalPosition.dx;
                final double screenWidth = MediaQuery.of(context).size.width;
                if (dx < screenWidth / 3) {
                  controller.previous();
                } else {
                  controller.next();
                }
              },
              child: Material(
                  child: Stack(children: [
                StoryView2(
                  storyItems: storyItems,
                  controller: controller,
                  repeat: true,
                  inline: true,
                ),
              ]))),
          Positioned(
            bottom: -20,
            left: size.width / 2.5,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          HomeDetails(residence: widget.residence),
                      transitionDuration: const Duration(milliseconds: 400),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(0.0, 1.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                    (_) => false);
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
                child: CircleAvatar(
                    backgroundColor: MyColors.shadow.withOpacity(0.16),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Column(
                        children: [
                          RotatedBox(
                            quarterTurns: -1,
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: SvgPicture.asset('assets/Icons/Next.svg',
                                    height: 20,
                                    width: 20,
                                    color: Colors.white)),
                          ),
                          const SizedBox(height: 4),
                          Text('Información',
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600)),
                          Text('de la propiedad',
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600))
                        ],
                      ),
                    )),
              ),
            ),
          ),
          VerticalDetailsBar(
              typeResidence: widget.residence.typeOfResidence!,
              area: widget.residence.area!,
              baths: widget.residence.bath!,
              garages: widget.residence.garage!,
              rooms: widget.residence.room!),
          buildShareButon(),
          buildDetailsButton(),
          buildLikeButon(),
          buildMessageButton()
        ]));
  }

  Widget buildShareButon() {
    return Align(
      alignment: const Alignment(-0.45, 0.96),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 23,
        child: CircleAvatar(
          backgroundColor: Colors.black.withOpacity(0.5),
          radius: 21,
          child: Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: SvgPicture.asset('assets/Icons/Compartir.svg',
                height: 28, width: 28, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget buildLikeButon() {
    final userProvider = Provider.of<UserProvider>(context);
    user = userProvider.user;
    return Align(
        alignment: const Alignment(0.53, 0.96),
        child: user.email != null
            ? GestureDetector(
                onTap: () async {
                  if (user.userLikes!.contains(widget.residence.id)) {
                    user.userLikes!.remove(widget.residence.id!);
                  } else {
                    user.userLikes!.add(widget.residence.id!);
                  }
                  userProvider.setUser(user);
                  await UserPreferences().saveData(user);
                  await UserCrud().updateUser(user.id!, user);
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 23,
                  child: CircleAvatar(
                    backgroundColor:
                        user.userLikes!.contains(widget.residence.id)
                            ? MyColors.fuchsia
                            : Colors.black.withOpacity(0.5),
                    radius: 21,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: SvgPicture.asset('assets/Icons/Me Gusta.svg',
                          height: 26, width: 26, color: Colors.white),
                    ),
                  ),
                ),
              )
            : GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerifyUser(user: user),
                      ),
                      (_) => false);
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 23,
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.84),
                    radius: 21,
                    child: SvgPicture.asset('assets/Icons/Me Gusta.svg',
                        height: 28, width: 28, color: Colors.white),
                  ),
                ),
              ));
  }

  Widget buildMessageButton() {
    final userProvider = Provider.of<UserProvider>(context);
    user = userProvider.user;
    return Align(
      alignment: const Alignment(0.90, 0.96),
      child: GestureDetector(
        onTap: () {
          if (user.email != null && user.email != '') {
            openWhatsapp();
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => VerifyUser(user: user),
                ),
                (_) => false);
          }
        },
        child: CircleAvatar(
          radius: 23,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Image.asset('assets/Icons/whatsappIcon.png'),
          ),
        ),
      ),
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

  Widget buildDetailsButton() {
    final userProvider = Provider.of<UserProvider>(context);
    user = userProvider.user;
    if (widget.residence.auctionDate != '') {
      DateTime stringDate = DateTime.parse(widget.residence.initAuctionTime!);
      String hour = '';
      String minute = '';
      stringDate.hour < 10
          ? hour = '0' + stringDate.hour.toString()
          : hour = stringDate.hour.toString();

      stringDate.minute < 10
          ? minute = '0' + stringDate.minute.toString()
          : minute = stringDate.minute.toString();

      return Stack(
        children: [
          Align(
            alignment: const Alignment(0, -1),
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SizedBox(
                height: 100,
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: MyColors.blue2,
                            borderRadius: BorderRadius.circular(9)),
                        child: Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, bottom: 16, left: 12, right: 12),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: [
                                TextSpan(
                                    text: widget.residence.availability!
                                            .contains('Venta')
                                        ? 'Subasta de Venta'
                                        : 'Subasta de ' +
                                            widget.residence.availability!
                                                .substring(
                                                    0,
                                                    widget
                                                        .residence.availability!
                                                        .lastIndexOf("-")),
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                TextSpan(
                                    text: '\n' +
                                        stringDate.day.toString() +
                                        ' ' +
                                        JsonConst.onlyDateToMonth(stringDate) +
                                        ' ' +
                                        hour +
                                        ':' +
                                        minute,
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold)),
                              ]),
                            )),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: MyColors.fuchsia,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 3),
                              minimumSize: Size.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0))),
                          child: Text('Ofertar',
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                          onPressed: () async {
                            if (isLoading == false) {
                              if (user.email != null && user.email != '') {
                                isLoading = true;
                                ResidenceModel lastResiden =
                                    await ResidenceCrud()
                                        .getResidence(widget.residence.id!);
                                // residencesForAuction = await ResidenceCrud()
                                //     .getResidencesOfAuctionDate(
                                //         widget.residence.auctionDate!);
                                // allResidences = await ResidenceCrud()
                                //     .getResidencesOfStateInApp('Publicada');
                                // List<ResidenceModel> newList = [];
                                // for (var i = 0;
                                //     i < residencesForAuction.length;
                                //     i++) {
                                //   if (residencesForAuction[i].typeOfAuction ==
                                //       'Subasta') {
                                //     newList.add(residencesForAuction[i]);
                                //   }
                                // }
                                if (widget.residence.typeOfAuction ==
                                    'Subasta') {
                                  isLoading = false;
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OfferListClass(
                                                residenceModel: lastResiden,
                                                user: user,
                                              )),
                                      (_) => false);
                                } else if (widget.residence.typeOfAuction ==
                                    'Express') {
                                  // List<ResidenceModel> newList = [];
                                  // for (var j = 0;
                                  //     j < allResidences.length;
                                  //     j++) {
                                  //   if (allResidences[j].typeOfAuction ==
                                  //       'Express') {
                                  //     newList.add(allResidences[j]);
                                  //   }
                                  // }
                                  isLoading = false;
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              OfferListRentPage(
                                                residenceModel: lastResiden,
                                                user: user,
                                              )),
                                      (_) => false);
                                }
                              } else {
                                isLoading = false;
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          VerifyUser(user: user),
                                    ),
                                    (_) => false);
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Container(
        decoration: BoxDecoration(
            color: MyColors.blue2, borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20),
          child: Column(children: [
            Text('Esperando día de subasta',
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ]),
        ),
      );
    }
  }

  Widget buildStamps() {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<CardProvider>(context);
    final status = provider.getStatus();

    switch (status) {
      case CardStatus.like:
        final child = Column(children: [
          CircleAvatar(
            backgroundColor: MyColors.fuchsia.withOpacity(0.4),
            radius: 55,
            child: CircleAvatar(
              backgroundColor: MyColors.fuchsia,
              radius: 45,
              child: SvgPicture.asset('assets/Icons/Me Gusta.svg',
                  height: 44, width: 44, color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          Text('Me cuadra',
              style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
        ]);

        return Positioned(
            top: size.height / 4, left: size.width / 3, child: child);

      case CardStatus.dislike:
        final child = Column(children: [
          CircleAvatar(
            backgroundColor: MyColors.fuchsia.withOpacity(0.4),
            radius: 55,
            child: CircleAvatar(
              backgroundColor: MyColors.fuchsia,
              radius: 45,
              child: SvgPicture.asset('assets/Icons/X.svg',
                  height: 44, width: 44, color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          Text('Cancelado',
              style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
        ]);
        return Positioned(top: 150, left: 150, child: child);
      case CardStatus.goDetailsResidence:
        return Container();
      case null:
        return Container();
    }
  }

  Widget buildStamp(
      {double angle = 0,
      required Color color,
      required String text,
      required double opacity}) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color, width: 4)),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
                color: color, fontSize: 48, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
