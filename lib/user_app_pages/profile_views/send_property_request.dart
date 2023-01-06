// ignore_for_file: no_leading_underscores_for_local_identifiers, deprecated_member_use, avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mailjet/mailjet.dart';
import 'package:me_cuadra_users/models/employee_model.dart';
import 'package:me_cuadra_users/preferences/user_preference.dart';
import 'package:me_cuadra_users/providers/user_provider.dart';
import 'package:me_cuadra_users/services/firebase/crud_employee.dart';
import 'package:me_cuadra_users/services/firebase/user_crud.dart';
import 'package:me_cuadra_users/services/mail/notification_mailjet.dart';
import 'package:me_cuadra_users/user_app_pages/profile_views/profile_pages/profile_page.dart';
import 'package:provider/provider.dart';

import '../../../colors/colors_data.dart';
import '../../../widgets/simple_error_dialog_widget.dart';
import '../../models/residence_model.dart';
import '../../models/user_model.dart';
import '../../services/firebase/residences_crud.dart';

// ignore: must_be_immutable
class SendPropertyRequest extends StatefulWidget {
  UserModel user;
  SendPropertyRequest({Key? key, required this.user}) : super(key: key);

  @override
  State<SendPropertyRequest> createState() => _SendPropertyRequestState();
}

class _SendPropertyRequestState extends State<SendPropertyRequest> {
  ResidenceModel residence = ResidenceModel();
  ScrollController scrollController = ScrollController();
  List<String> residenceTypes = [
    'Apartamento',
    'Apartaestudio',
    'Casa',
    'Duplex',
    'Finca',
    'Oficina',
    'Penthouse'
  ];
  List<String> citys = ['Bucaramanga', 'Floridablanca', 'Girón', 'Piedecuesta'];
  final sb30 = const SizedBox(height: 30);
  final sb15 = const SizedBox(height: 15);
  final _formKey = GlobalKey<FormState>();
  String? city;
  String? residenType;

  @override
  void initState() {
    super.initState();
    residence.ownerEmail = [''];
    residence.ownerIdentification = [''];
    residence.ownerName = [''];
    residence.ownerPhoneNumber = [''];
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        userProvider.setUser(widget.user);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProfilePage(user: widget.user, isWantedToOffer: true),
            ),
            (route) => false);

        return false;
      },
      child: Scaffold(
        appBar: getAppBar(),
        body: SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _welcomeText(),
                  sb15,
                  _ownerInputs(),
                  sb30,
                  _ownerExtras(),
                  sb30,
                  _propertyInputs(),
                  sb15,
                  _finalMessage(),
                  sb30,
                  _requestButton()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar getAppBar() {
    return AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfilePage(user: widget.user, isWantedToOffer: true),
                  ),
                  (route) => false);
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
        ));
  }

  Widget _welcomeText() {
    return Column(
      children: [
        Text('Solicitud de Oferta',
            style: GoogleFonts.montserrat(
                color: MyColors.blue2,
                fontSize: 28,
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.center),
        const SizedBox(height: 15),
        Text(
            'Para publicar su propiedad en nuestra plataforma, por favor ingrese la información',
            style: GoogleFonts.montserrat(
                color: MyColors.blue2,
                fontSize: 16,
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.center),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _ownerInputs() {
    String countryDial = '+57';
    return Column(
      children: [
        Text('Información del propietario',
            style: GoogleFonts.montserrat(
                color: MyColors.blue2,
                fontSize: 18,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.center),
        sb15,
        Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(27),
              color: MyColors.whiteBox),
          child: TextFormField(
            validator: (String? value) {
              if (value!.isEmpty ||
                  value.length < 4 ||
                  value.length > 50 ||
                  !RegExp(r'^[a-z A-Z á-ú Á-Ú]+$').hasMatch(value)) {
                return 'Ingrese un nombre válido';
              } else {
                return null;
              }
            },
            onChanged: (value) {
              setState(() {
                _formKey.currentState!.validate();
                residence.ownerName![0] = value;
              });
            },
            textAlign: TextAlign.left,
            style: GoogleFonts.montserrat(
                color: MyColors.grey,
                fontSize: 18,
                fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              hintText: 'Nombre Completo',
              hintStyle: GoogleFonts.montserrat(
                  color: MyColors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
              border: InputBorder.none,
              counterText: '',
            ),
            maxLength: 50,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(27),
              color: MyColors.whiteBox),
          child: TextFormField(
            validator: (String? value) {
              if (value!.isEmpty ||
                  value.length < 8 ||
                  value.length > 50 ||
                  !RegExp(r'^[a-z A-Z á-ú Á-Ú 0-9 .]+$').hasMatch(value)) {
                return 'Ingrese una cédula válida';
              } else {
                return null;
              }
            },
            onChanged: (value) {
              setState(() {
                _formKey.currentState!.validate();
                residence.ownerIdentification![0] = value;
              });
            },
            textAlign: TextAlign.left,
            style: GoogleFonts.montserrat(
                color: MyColors.grey,
                fontSize: 18,
                fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              hintText: 'Cédula de ciudadanía',
              hintStyle: GoogleFonts.montserrat(
                  color: MyColors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
              border: InputBorder.none,
              counterText: '',
            ),
            maxLength: 50,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(27),
              color: MyColors.whiteBox),
          child: IntlPhoneField(
            flagsButtonPadding: const EdgeInsets.only(left: 20),
            searchText: 'Buscar País',
            pickerDialogStyle: PickerDialogStyle(
                backgroundColor: MyColors.whiteBox,
                countryCodeStyle: GoogleFonts.montserrat(
                    color: MyColors.blue2,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
                countryNameStyle: GoogleFonts.montserrat(
                    color: MyColors.blue2,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            invalidNumberMessage: 'Número de teléfono incorrecto',
            dropdownTextStyle: GoogleFonts.montserrat(
                color: MyColors.grey,
                fontSize: 18,
                fontWeight: FontWeight.w600),
            showCountryFlag: true,
            showDropdownIcon: true,
            textAlignVertical: TextAlignVertical.center,
            initialValue: countryDial,
            textAlign: TextAlign.left,
            style: GoogleFonts.montserrat(
                color: MyColors.grey,
                fontSize: 18,
                fontWeight: FontWeight.w600),
            onCountryChanged: (country) {
              setState(() {
                countryDial = "+" + country.dialCode;
              });
            },
            onChanged: (number) {
              residence.ownerPhoneNumber![0] = number.completeNumber;
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              hintText: 'Teléfono Móvil',
              hintStyle: GoogleFonts.montserrat(
                  color: MyColors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
              border: InputBorder.none,
              counterText: '',
            ),
          ),
        ),
        sb15,
        // ElevatedButton(
        //   style: ElevatedButton.styleFrom(
        //       padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        //       primary: MyColors.fuchsia,
        //       shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(15.0))),
        //   onPressed: () {
        //     residence.ownerEmail!.add('');
        //     residence.ownerIdentification!.add('');
        //     residence.ownerName!.add('');
        //     residence.ownerPhoneNumber!.add('');
        //     setState(() {});
        //   },
        //   child: Text(
        //     'Agregar propietario extra',
        //     style: GoogleFonts.montserrat(
        //         color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
        //     textAlign: TextAlign.center,
        //   ),
        // ),
      ],
    );
  }

  Widget _ownerExtras() {
    return residence.ownerIdentification!.length > 1
        ? MasonryGridView.count(
            controller: scrollController,
            itemCount: residence.ownerIdentification!.length - 1,
            mainAxisSpacing: 30,
            crossAxisCount: 1,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              String countryDial = '+57';
              return Column(
                children: [
                  Text('Información propietario ' + (index + 2).toString(),
                      style: GoogleFonts.montserrat(
                          color: MyColors.blue2,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center),
                  sb15,
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(27),
                        color: MyColors.whiteBox),
                    child: TextFormField(
                      validator: (String? value) {
                        if (value!.isEmpty ||
                            value.length < 4 ||
                            value.length > 50 ||
                            !RegExp(r'^[a-z A-Z á-ú Á-Ú]+$').hasMatch(value)) {
                          return 'Ingrese un nombre válido';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          _formKey.currentState!.validate();
                          residence.ownerName![index + 1] = value;
                        });
                      },
                      textAlign: TextAlign.left,
                      style: GoogleFonts.montserrat(
                          color: MyColors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        hintText: 'Nombre Completo',
                        hintStyle: GoogleFonts.montserrat(
                            color: MyColors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      maxLength: 50,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(27),
                        color: MyColors.whiteBox),
                    child: TextFormField(
                      validator: (String? value) {
                        if (value!.isEmpty ||
                            value.length < 8 ||
                            value.length > 50 ||
                            !RegExp(r'^[a-z A-Z á-ú Á-Ú 0-9 .]+$')
                                .hasMatch(value)) {
                          return 'Ingrese una cédula válida';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          _formKey.currentState!.validate();
                          residence.ownerIdentification![index + 1] = value;
                        });
                      },
                      textAlign: TextAlign.left,
                      style: GoogleFonts.montserrat(
                          color: MyColors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        hintText: 'Cédula de ciudadanía',
                        hintStyle: GoogleFonts.montserrat(
                            color: MyColors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      maxLength: 50,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(27),
                        color: MyColors.whiteBox),
                    child: IntlPhoneField(
                      flagsButtonPadding: const EdgeInsets.only(left: 20),
                      searchText: 'Buscar País',
                      pickerDialogStyle: PickerDialogStyle(
                          backgroundColor: MyColors.whiteBox,
                          countryCodeStyle: GoogleFonts.montserrat(
                              color: MyColors.blue2,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                          countryNameStyle: GoogleFonts.montserrat(
                              color: MyColors.blue2,
                              fontSize: 18,
                              fontWeight: FontWeight.w600)),
                      invalidNumberMessage: 'Número de teléfono incorrecto',
                      dropdownTextStyle: GoogleFonts.montserrat(
                          color: MyColors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                      showCountryFlag: true,
                      showDropdownIcon: true,
                      textAlignVertical: TextAlignVertical.center,
                      initialValue: countryDial,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.montserrat(
                          color: MyColors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                      onCountryChanged: (country) {
                        setState(() {
                          countryDial = "+" + country.dialCode;
                        });
                      },
                      onChanged: (number) {
                        residence.ownerPhoneNumber![index + 1] =
                            number.completeNumber;
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        hintText: 'Teléfono Móvil',
                        hintStyle: GoogleFonts.montserrat(
                            color: MyColors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                        border: InputBorder.none,
                        counterText: '',
                      ),
                    ),
                  ),
                  sb15,
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 10),
                        primary: MyColors.fuchsia,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0))),
                    onPressed: () {
                      residence.ownerEmail!.removeAt(index + 1);
                      residence.ownerIdentification!.removeAt(index + 1);
                      residence.ownerName!.removeAt(index + 1);
                      residence.ownerPhoneNumber!.removeAt(index + 1);
                      setState(() {});
                    },
                    child: Text(
                      'Eliminar propietario',
                      style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            })
        : const Center();
  }

  Widget _propertyInputs() {
    return Column(children: [
      Text('Información de la propiedad',
          style: GoogleFonts.montserrat(
              color: MyColors.blue2, fontSize: 18, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center),
      const SizedBox(height: 15),
      // Container(
      //   width: double.maxFinite,
      //   decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(27), color: MyColors.whiteBox),
      //   child: TextFormField(
      //     validator: (String? value) {
      //       if (value!.isEmpty ||
      //           value.length < 4 ||
      //           value.length > 50 ||
      //           !RegExp(r'^[a-z A-Z á-ú Á-Ú]+$').hasMatch(value)) {
      //         return 'Ingrese un país válido';
      //       } else {
      //         return null;
      //       }
      //     },
      //     onChanged: (value) {
      //       setState(() {
      //         _formKey.currentState!.validate();
      //         residence.ownerCountry = value;
      //       });
      //     },
      //     textAlign: TextAlign.left,
      //     style: GoogleFonts.montserrat(
      //         color: MyColors.grey, fontSize: 20, fontWeight: FontWeight.w600),
      //     decoration: InputDecoration(
      //       contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      //       hintText: 'País de Ubicación',
      //       hintStyle: GoogleFonts.montserrat(
      //           color: MyColors.grey,
      //           fontSize: 20,
      //           fontWeight: FontWeight.w600),
      //       border: InputBorder.none,
      //       counterText: '',
      //     ),
      //     maxLength: 50,
      //   ),
      // ),
      // const SizedBox(height: 10),
      // Container(
      //   width: double.maxFinite,
      //   decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(27), color: MyColors.whiteBox),
      //   child: TextFormField(
      //     validator: (String? value) {
      //       if (value!.isEmpty ||
      //           value.length < 4 ||
      //           value.length > 50 ||
      //           !RegExp(r'^[a-z A-Z á-ú Á-Ú]+$').hasMatch(value)) {
      //         return 'Ingrese un departamento válido';
      //       } else {
      //         return null;
      //       }
      //     },
      //     onChanged: (value) {
      //       setState(() {
      //         _formKey.currentState!.validate();
      //         residence.ownerState = value;
      //       });
      //     },
      //     textAlign: TextAlign.left,
      //     style: GoogleFonts.montserrat(
      //         color: MyColors.grey, fontSize: 20, fontWeight: FontWeight.w600),
      //     decoration: InputDecoration(
      //       contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      //       hintText: 'Departamento',
      //       hintStyle: GoogleFonts.montserrat(
      //           color: MyColors.grey,
      //           fontSize: 20,
      //           fontWeight: FontWeight.w600),
      //       border: InputBorder.none,
      //       counterText: '',
      //     ),
      //     maxLength: 50,
      //   ),
      // ),
      // const SizedBox(height: 10),
      Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(27), color: MyColors.whiteBox),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: DropdownButton<String>(
              hint: Text(
                'Ciudad',
                style: GoogleFonts.montserrat(
                    color: MyColors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              isExpanded: true,
              value: city,
              style: GoogleFonts.montserrat(
                  color: MyColors.blue2,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
              items: citys.map(buildMenuCity).toList(),
              borderRadius: BorderRadius.circular(27),
              alignment: AlignmentDirectional.center,
              onChanged: (value) {
                city = value;
                setState(() {});
              },
              underline: Container(
                height: 0,
              )),
        ),
      ),
      const SizedBox(height: 10),
      Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(27), color: MyColors.whiteBox),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: DropdownButton<String>(
              hint: Text(
                'Tipo de inmueble',
                style: GoogleFonts.montserrat(
                    color: MyColors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              isExpanded: true,
              value: residenType,
              style: GoogleFonts.montserrat(
                  color: MyColors.blue2,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
              items: residenceTypes.map(buildMenuRecidenceType).toList(),
              borderRadius: BorderRadius.circular(27),
              alignment: AlignmentDirectional.center,
              onChanged: (value) {
                residenType = value;
                setState(() {});
              },
              underline: Container(
                height: 0,
              )),
        ),
      ),
      // Container(
      //   width: double.maxFinite,
      //   decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(27), color: MyColors.whiteBox),
      //   child: TextFormField(
      //     textCapitalization: TextCapitalization.sentences,
      //     validator: (String? value) {
      //       if (value!.isEmpty ||
      //           value.length < 8 ||
      //           value.length > 100 ||
      //           !RegExp(r'^[a-z A-Z á-ú Á-Ú + $ # -]').hasMatch(value)) {
      //         return 'Ingrese una dirección válida';
      //       } else {
      //         return null;
      //       }
      //     },
      //     onChanged: (value) {
      //       setState(() {
      //         _formKey.currentState!.validate();
      //         residence.ownerDirection = value;
      //       });
      //     },
      //     textAlign: TextAlign.left,
      //     style: GoogleFonts.montserrat(
      //         color: MyColors.grey, fontSize: 20, fontWeight: FontWeight.w600),
      //     decoration: InputDecoration(
      //       contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      //       hintText: 'Dirección',
      //       hintStyle: GoogleFonts.montserrat(
      //           color: MyColors.grey,
      //           fontSize: 20,
      //           fontWeight: FontWeight.w600),
      //       border: InputBorder.none,
      //       counterText: '',
      //     ),
      //     maxLength: 50,
      //   ),
      // ),
    ]);
  }

  DropdownMenuItem<String> buildMenuRecidenceType(String item) {
    setState(() {});
    return DropdownMenuItem(
        value: item,
        onTap: () {
          residence.typeOfResidence = item;
        },
        child: Text(
          item,
          style: GoogleFonts.montserrat(
              color: MyColors.grey, fontSize: 18, fontWeight: FontWeight.w600),
          textAlign: TextAlign.start,
        ));
  }

  DropdownMenuItem<String> buildMenuCity(String item) {
    setState(() {});
    return DropdownMenuItem(
        value: item,
        onTap: () {
          residence.city = item;
        },
        child: Text(
          item,
          style: GoogleFonts.montserrat(
              color: MyColors.grey, fontSize: 18, fontWeight: FontWeight.w600),
          textAlign: TextAlign.start,
        ));
  }

  Widget _finalMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Text(
          'Al hacer clic en "Enviar solicitud", aceptas nuestra Política de privacidad de manejo de información personal',
          style: GoogleFonts.montserrat(
              color: MyColors.grey, fontSize: 12, fontWeight: FontWeight.w400),
          textAlign: TextAlign.center),
    );
  }

  Widget _requestButton() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(35),
                primary: MyColors.fuchsia,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            onPressed: () async {
              final _isValid = _formKey.currentState!.validate();

              if (_isValid && validateInputs()) {
                residence.idUser = widget.user.id;
                residence.ownerEmail![0] = widget.user.email!;

                await ResidenceCrud()
                    .addResidenceFromProfileUSer(residence, widget.user);
                UserModel userUpdate = await UserPreferences().loadData();
                List<EmployeeModel> admins =
                    await CrudEmployee().getAllWorkers('Admin');
                List<String> emails = [];
                List<String> admNames = [];
                for (var i = 0; i < admins.length; i++) {
                  emails.add(admins[i].email!);
                  admNames.add(admins[i].name!);
                }
                await getToken(userUpdate);

                List<Recipient> recipients = [];
                for (var rec = 0; rec < emails.length; rec++) {
                  recipients
                      .add(Recipient(email: emails[rec], name: admNames[rec]));
                }
                await NotificationMailjet(
                    recipients: recipients,
                    message: 'UN NUEVO INMUEBLE HA SIDO OFERTADO');
                // await NotificationMail(
                //     message: 'NOTIFICATION EMAIL',
                //     adminEmails: emails,
                //     adminNames: admNames,
                //     userName: userUpdate.userName,
                //     userEmail: userUpdate.email);
                showDialog(
                    context: context,
                    builder: (context) => successDialogWidget(
                          "¡NOS CUADRA TU INMUEBLE!",
                          "Los datos de tu inmueble se han registrado con éxito.",
                          "Podrás dar seguimiento a tu negocio y recibir buenas noticias de tu proceso en tu perfil, en poco tiempo un agente de servicio te contactar para brindarte asesoría personalizada.",
                          Icons.check_rounded,
                        ));
              } else {
                showDialog(
                    context: context,
                    builder: (context) => SimpleErrorDialogWidget(
                        description:
                            "Asegurese de llenar todos los campos correctamente"));
              }
            },
            child: Text(
              'Enviar Solicitud',
              style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  bool validateInputs() {
    bool isComlete = true;
    if (residence.typeOfResidence == null ||
        residence.typeOfResidence == '' ||
        residence.city == null ||
        residence.city == '') {
      isComlete = false;
    }
    return isComlete;
  }

  Widget successDialogWidget(
      String title, String subtitle, String description, IconData icon) {
    return Dialog(
      elevation: 0,
      insetPadding: const EdgeInsets.all(0),
      backgroundColor: MyColors.grey,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfilePage(user: widget.user, isWantedToOffer: true),
                  ),
                  (route) => false);
            },
            child: SizedBox(
              width: double.maxFinite,
              height: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 24.0),
                    CircleAvatar(
                      radius: 105,
                      backgroundColor: MyColors.blueMarine.withOpacity(0.4),
                      child: CircleAvatar(
                        radius: 90,
                        backgroundColor: MyColors.blueMarine,
                        child: Icon(
                          icon,
                          color: Colors.white,
                          size: 140,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Text(
                      subtitle,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30.0),
                    Text(
                      description,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Get the user token and update the userdb
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
      } else {
        UserCrud().updateUser(myUser.id!, myUser);
        UserPreferences().saveData(myUser);
      }
    } else {
      myUser.userToken = myToken;

      UserCrud().updateUser(myUser.id!, myUser);
      UserPreferences().saveData(myUser);
    }
  }

  // senEmail() async {
  //   const email = 'jhohan1406@gmail.com';
  //   List<EmployeeModel> admins = await CrudEmployee().getAllWorkers('Admin');
  //   List<String> emails = [];
  //   for (var i = 0; i < admins.length; i++) {
  //     emails.add(admins[i].email!);
  //   }
  //   final smtpServer = gmailSaslXoauth2(email, token)
  //   final message = Message()
  //     ..from = const Address(email, 'Soporte')
  //     ..recipients = [emails]
  //     ..subject = 'Soporte de MeCuadra'
  //     ..text = 'NUEVO INMUEBLE OFERTADO para asignación de cliente';

  //     try{
  //       await send(message, smtpServer);
  //     } on MailerException catch (e) {
  //       print(e.message);
  //     }
  // }
}
