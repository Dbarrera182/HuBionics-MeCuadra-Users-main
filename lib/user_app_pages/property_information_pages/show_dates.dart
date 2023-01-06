// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:me_cuadra_users/services/notifications/schedule_visit_notifications.dart';
import 'package:me_cuadra_users/widgets/simple_dialog_success_widget.dart';
import 'package:provider/provider.dart';

import '../../../colors/colors_data.dart';
import '../../../models/user_model.dart';
import '../../../widgets/simple_error_dialog_widget.dart';
import '../../models/residence_model.dart';
import '../../preferences/user_preference.dart';
import '../../providers/user_provider.dart';
import '../../services/const/json_const.dart';
import '../../services/firebase/residences_crud.dart';
import '../../services/firebase/user_crud.dart';

// ignore: must_be_immutable
class ShowDates extends StatefulWidget {
  ResidenceModel model;
  UserModel user;
  ShowDates({Key? key, required this.model, required this.user})
      : super(key: key);

  @override
  State<ShowDates> createState() => _ShowDatesState();
}

class _ShowDatesState extends State<ShowDates> {
  final sb10 = const SizedBox(height: 10);
  bool _isVirtual = false;
  ScrollController scrollController = ScrollController();
  List<int> selectedPresential = [];
  List<int> selectedVirtual = [];
  @override
  void initState() {
    super.initState();
    visitsAgended();
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      RemoteNotification? notifiication = remoteMessage.notification;
      AndroidNotification? android = remoteMessage.notification!.android;
      if (notifiication != null && android != null) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 2,
                channelKey: 'scheduled_channel',
                title: notifiication.title,
                body: notifiication.body,
                showWhen: true,
                displayOnForeground: true,
                displayOnBackground: true));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
      RemoteNotification? notifiication = remoteMessage.notification;
      AndroidNotification? android = remoteMessage.notification!.android;
      if (notifiication != null && android != null) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 2,
                channelKey: 'scheduled_channel',
                title: notifiication.title,
                body: notifiication.body,
                showWhen: true,
                displayOnForeground: true,
                displayOnBackground: true));
      }
    });
  }

  visitsAgended() {
    for (var i = 0; i < widget.model.presentialVisits!.length; i++) {
      if (widget.model.presentialVisits![i].visitingUsers!
          .contains(widget.user.id!)) {
        selectedPresential.add(i);
      }
    }
    for (var j = 0; j < widget.model.virtualVisits!.length; j++) {
      if (widget.model.virtualVisits![j].visitingUsers!
          .contains(widget.user.id!)) {
        selectedVirtual.add(j);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                _initialText(),
                sb10,
                _rowButtons(),
                const SizedBox(height: 30),
                _isVirtual ? dateVirtualList() : datePresentialList(),
                _finalMessage()
              ],
            )),
      ),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset(
            'assets/Icons/Flecha Atras.svg',
            width: 25,
            height: 25,
            color: Colors.white,
          )),
      centerTitle: true,
      title: SvgPicture.asset(
        'assets/Icons/LogoSVG.svg',
        width: 30,
        height: 30,
        color: MyColors.blue2,
      ),
    );
  }

  Widget _initialText() {
    return Column(
      children: [
        Text('Agenda',
            style: GoogleFonts.montserrat(
                color: MyColors.blue2,
                fontSize: 30,
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.center),
        const SizedBox(height: 15),
        Text('Selecciona el tipo de recorrido',
            style: GoogleFonts.montserrat(
                color: MyColors.grey,
                fontSize: 18,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.center),
      ],
    );
  }

  Widget _rowButtons() {
    return Column(
      children: [
        Row(children: [
          Expanded(
              flex: 11,
              child: GestureDetector(
                onTap: () {
                  if (_isVirtual) {
                    _isVirtual = false;
                  }
                  setState(() {});
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: !_isVirtual ? MyColors.blue2 : MyColors.whiteBox),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: Text(
                      'Visita Presencial',
                      style: GoogleFonts.montserrat(
                          color: !_isVirtual ? Colors.white : MyColors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              flex: 8,
              child: GestureDetector(
                onTap: () {
                  if (!_isVirtual) {
                    _isVirtual = true;
                  }
                  setState(() {});
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: _isVirtual ? MyColors.blue2 : MyColors.whiteBox),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: Text(
                      'Visita Virtual',
                      style: GoogleFonts.montserrat(
                          color: _isVirtual ? Colors.white : MyColors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ))
        ]),
        const SizedBox(height: 40),
        Text(
          'Seleccione una fecha',
          style: GoogleFonts.montserrat(
              color: MyColors.grey, fontSize: 18, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget datePresentialList() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
            width: double.maxFinite,
            height: 200,
            child: ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, _) => const SizedBox(width: 10),
              scrollDirection: Axis.horizontal,
              itemCount: widget.model.presentialVisits![0].initTime != ''
                  ? widget.model.presentialVisits!.length
                  : 0,
              itemBuilder: (context, index) =>
                  cardHorizontalWidgetPresential(index),
            )));
  }

  Widget dateVirtualList() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
            width: double.maxFinite,
            height: 200,
            child: ListView.separated(
              separatorBuilder: (context, _) => const SizedBox(width: 10),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.model.virtualVisits![0].initTime != ''
                  ? widget.model.virtualVisits!.length
                  : 0,
              itemBuilder: (context, index) =>
                  cardHorizontalWidgetVirtual(index),
            )));
  }

  Widget cardHorizontalWidgetPresential(int index) {
    late DateTime finalPresential;
    String initDate = '';
    String finalDate = '';
    finalPresential =
        DateTime.parse(widget.model.presentialVisits![index].finalTime!);
    initDate =
        widget.model.presentialVisits![index].initTime!.substring(11, 16);
    finalDate =
        widget.model.presentialVisits![index].finalTime!.substring(11, 16);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedPresential.contains(index)) {
            selectedPresential.remove(index);
            widget.model.presentialVisits![index].visitingUsers!
                .remove(widget.user.id!);
          } else {
            selectedPresential.add(index);
            widget.model.presentialVisits![index].visitingUsers!
                .add(widget.user.id!);
          }
        });
      },
      child: Container(
        width: 105,
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: selectedPresential.contains(index)
                ? MyColors.blueMarine
                : Colors.white,
            border: selectedPresential.contains(index)
                ? Border.all(color: Colors.transparent)
                : Border.all(color: MyColors.grey, width: 1)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Text(
              JsonConst.dateToDay(finalPresential),
              style: GoogleFonts.montserrat(
                  color: selectedPresential.contains(index)
                      ? Colors.white
                      : MyColors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            Text(
              finalPresential.day.toString(),
              style: GoogleFonts.montserrat(
                  color: selectedPresential.contains(index)
                      ? Colors.white
                      : MyColors.grey,
                  fontSize: 36,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            Text(
              dateTitleShort(finalPresential),
              style: GoogleFonts.montserrat(
                  color: selectedPresential.contains(index)
                      ? Colors.white
                      : MyColors.grey,
                  fontSize: 25,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(),
            Text(
              initDate + '\n|\n' + finalDate,
              style: GoogleFonts.montserrat(
                  color: selectedPresential.contains(index)
                      ? Colors.white
                      : MyColors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget cardHorizontalWidgetVirtual(int index) {
    late DateTime finalPresential;
    String initDate = '';
    String finalDate = '';

    finalPresential =
        DateTime.parse(widget.model.virtualVisits![index].finalTime!);
    initDate = widget.model.virtualVisits![index].initTime!.substring(11, 16);
    finalDate = widget.model.virtualVisits![index].finalTime!.substring(11, 16);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedVirtual.contains(index)) {
            selectedVirtual.remove(index);
            widget.model.virtualVisits![index].visitingUsers!
                .remove(widget.user.id!);
          } else {
            selectedVirtual.add(index);
            widget.model.virtualVisits![index].visitingUsers!
                .add(widget.user.id!);
          }
        });
      },
      child: Container(
        width: 105,
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: selectedVirtual.contains(index)
                ? MyColors.blueMarine
                : Colors.white,
            border: selectedVirtual.contains(index)
                ? Border.all(color: Colors.transparent)
                : Border.all(color: MyColors.grey, width: 1)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Text(
              JsonConst.dateToDay(finalPresential),
              style: GoogleFonts.montserrat(
                  color: selectedVirtual.contains(index)
                      ? Colors.white
                      : MyColors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            Text(
              finalPresential.day.toString(),
              style: GoogleFonts.montserrat(
                  color: selectedVirtual.contains(index)
                      ? Colors.white
                      : MyColors.grey,
                  fontSize: 36,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            Text(
              dateTitleShort(finalPresential),
              style: GoogleFonts.montserrat(
                  color: selectedVirtual.contains(index)
                      ? Colors.white
                      : MyColors.grey,
                  fontSize: 25,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(),
            Text(
              initDate + '\n|\n' + finalDate,
              style: GoogleFonts.montserrat(
                  color: selectedVirtual.contains(index)
                      ? Colors.white
                      : MyColors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _finalMessage() {
    final userProvider = Provider.of<UserProvider>(context);
    return Column(children: [
      const SizedBox(height: 20),
      Text(
        'Al solicitar una visita a la propiedad, esta se añadira automaticamente a tu lista de favoritos',
        style: GoogleFonts.montserrat(
            color: MyColors.grey, fontSize: 16, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(40),
              primary: MyColors.fuchsia,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0))),
          onPressed: () {
            if (selectedVirtual.isNotEmpty || selectedPresential.isNotEmpty) {
              if (!widget.user.userScheduledProperties!
                  .contains(widget.model.id!)) {
                widget.user.userScheduledProperties!.add(widget.model.id!);
                UserPreferences().saveData(widget.user);
                UserCrud().updateUser(widget.user.id!, widget.user);
                userProvider.setUser(widget.user);
              }

              ResidenceCrud().updateResidence(widget.model.id!, widget.model);
              showDialog(
                  context: context,
                  builder: (context) => SimpleSuccessDialogWidget(
                      description: "Recorrido solicitado con exito"));
              for (var i = 0; i < selectedVirtual.length; i++) {
                DateTime initVisitDate = DateTime.parse(
                    widget.model.virtualVisits![selectedVirtual[i]].initTime!);
                initVisitDate =
                    initVisitDate.subtract(const Duration(minutes: 5));
                createReminderNotification(initVisitDate);
              }
              for (var i = 0; i < selectedPresential.length; i++) {
                DateTime initVisitDate = DateTime.parse(widget
                    .model.presentialVisits![selectedPresential[i]].initTime!);
                initVisitDate =
                    initVisitDate.subtract(const Duration(minutes: 5));
                createReminderNotification(initVisitDate);
              }
            } else {
              showDialog(
                  context: context,
                  builder: (context) => SimpleErrorDialogWidget(
                      description:
                          'Seleccione primero una fecha de recorrido'));
            }
          },
          child: Text(
            'Solicitar',
            style: GoogleFonts.montserrat(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ),
      )
    ]);
  }

  String dateTitleShort(DateTime date) {
    dynamic monthData =
        '{ "1" : "Ene", "2" : "Feb", "3" : "Mar", "4" : "Abr", "5" : "May", "6" : "Jun", "7" : "Jul", "8" : "Ago", "9" : "Sep", "10" : "Oct", "11" : "Nov", "12" : "Dic" }';

    return json.decode(monthData)['${date.month}'];
  }
}
