// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:me_cuadra_users/models/user_model.dart';
import 'package:me_cuadra_users/preferences/user_preference.dart';
import 'package:me_cuadra_users/providers/user_provider.dart';
import 'package:me_cuadra_users/services/const/firebase_constants.dart';
import 'package:me_cuadra_users/services/firebase/user_crud.dart';
import 'package:me_cuadra_users/user_app_pages/profile_views/change_password.dart';
import 'package:me_cuadra_users/user_app_pages/profile_views/profile_pages/profile_page.dart';
import 'package:me_cuadra_users/widgets/simple_dialog_success_widget.dart';
import 'package:me_cuadra_users/widgets/simple_error_dialog_widget.dart';
import 'package:provider/provider.dart';

import '../../colors/colors_data.dart';

class ProfileInformation extends StatefulWidget {
  UserModel user;
  ProfileInformation({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileInformation> createState() => _ProfileInformationState();
}

class _ProfileInformationState extends State<ProfileInformation> {
  final sb30 = const SizedBox(height: 30);
  final sb15 = const SizedBox(height: 15);
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  PlatformFile? pickedFile;
  String? urlDownload;

  @override
  void initState() {
    super.initState();
    userNameController.text = widget.user.userName!;
    phoneNumberController.text = widget.user.phoneNumber!.replaceAll('+57', '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _getAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              _initText(),
              sb30,
              _profileImage(),
              sb30,
              sb15,
              _informationInputs(),
              sb30,
              sb30,
              _saveButton(),
              sb30,
              _finalMessage()
            ]),
          ),
        ));
  }

  AppBar _getAppBar() {
    return AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(
                          user: widget.user, isWantedToOffer: false)));
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

  Widget _initText() {
    return Column(
      children: [
        Text('Cuenta',
            style: GoogleFonts.montserrat(
                color: MyColors.blue2,
                fontSize: 28,
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.center),
        sb15,
        Text(
            'Actualiza la información de tu perfil, recuerda oprimir guardar al finalizar',
            style: GoogleFonts.montserrat(
                color: MyColors.blue2,
                fontSize: 16,
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.center)
      ],
    );
  }

  Widget _profileImage() {
    final userProvider = Provider.of<UserProvider>(context);
    return Stack(
      children: [
        pickedFile != null
            ? Material(
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: InkWell(
                  splashColor: Colors.black26,
                  onTap: () {
                    pickImage();
                  },
                  child: Ink.image(
                    image: FileImage(File(pickedFile!.path!)),
                    height: 140,
                    width: 140,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : Material(
                borderRadius: BorderRadius.circular(100),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.black26,
                  onTap: () {
                    pickImage();
                  },
                  child: CachedNetworkImage(
                    imageUrl: userProvider.user.photoURL != null &&
                            userProvider.user.photoURL != ''
                        ? userProvider.user.photoURL!
                        : widget.user.photoURL!,
                    imageBuilder: (context, imageProvider) => Ink.image(
                      image: imageProvider,
                      height: 140,
                      width: 140,
                      fit: BoxFit.cover,
                    ),
                    fadeInDuration: const Duration(microseconds: 0),
                    fadeOutDuration: const Duration(milliseconds: 0),
                    placeholder: (context, url) => Container(
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => SvgPicture.asset(
                      'assets/LogoM.svg',
                      width: 30,
                      height: 30,
                      color: MyColors.blue2,
                    ),
                  ),
                ),
              ),
        Positioned(
            top: 0,
            right: 0,
            child: Material(
              borderRadius: BorderRadius.circular(100),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: InkWell(
                onTap: () {
                  pickImage();
                },
                child: const CircleAvatar(
                  backgroundColor: MyColors.whiteBox,
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.edit,
                      size: 30,
                      color: MyColors.blue2,
                    ),
                  ),
                ),
              ),
            ))
      ],
    );
  }

  Widget _informationInputs() {
    return Column(children: [
      Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(27), color: MyColors.whiteBox),
        child: TextField(
          obscureText: false,
          controller: userNameController,
          textAlign: TextAlign.left,
          style: GoogleFonts.montserrat(
              color: MyColors.grey, fontSize: 18, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 20),
            hintText: 'Nombre de Usuario',
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
      sb15,
      Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(27), color: MyColors.whiteBox),
        child: TextField(
          obscureText: false,
          controller: phoneNumberController,
          textAlign: TextAlign.left,
          keyboardType: TextInputType.phone,
          style: GoogleFonts.montserrat(
              color: MyColors.grey, fontSize: 18, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 20),
            hintText: 'Teléfono Móvil',
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
      sb15,
      widget.user.singinMethod == 'Correo'
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(45),
                  primary: MyColors.blueMarine,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27.0))),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) =>
                            ChangePassword(user: widget.user))));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cambiar contraseña',
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  const Icon(Icons.play_arrow, color: Colors.white, size: 25)
                ],
              ),
            )
          : const Center(),
    ]);
  }

  Widget _saveButton() {
    final userProvider = Provider.of<UserProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 60),
            primary: MyColors.fuchsia,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0))),
        onPressed: () {
          if (widget.user.userName != userNameController.text ||
              widget.user.phoneNumber != phoneNumberController.text ||
              urlDownload != null) {
            widget.user.userName = userNameController.text;
            widget.user.phoneNumber = phoneNumberController.text;
            urlDownload != null
                ? widget.user.photoURL = urlDownload
                : widget.user.photoURL = widget.user.photoURL;
            UserPreferences().saveData(widget.user);
            UserCrud().updateUser(widget.user.id!, widget.user);
            userProvider.getUserFromPreference();
            showDialog(
                context: context,
                builder: (context) => SimpleSuccessDialogWidget(
                    description: "Tu información ha sido actualizada"));
          } else {
            showDialog(
                context: context,
                builder: (context) => SimpleErrorDialogWidget(
                    description: "No has hecho cambios en tu información"));
          }
        },
        child: Text(
          'Guardar',
          style: GoogleFonts.montserrat(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _finalMessage() {
    return Column(children: [
      Text('¿Tiene otra cuenta?',
          style: GoogleFonts.montserrat(
              color: MyColors.blue2, fontSize: 14, fontWeight: FontWeight.w400),
          textAlign: TextAlign.center),
      TextButton(
        onPressed: () {
          showDialog(context: context, builder: (context) => confirmLogOut());
        },
        child: Text('Cerrar sesión',
            style: GoogleFonts.montserrat(
                color: MyColors.blue2,
                fontSize: 20,
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.center),
      ),
      const SizedBox(height: 10),
    ]);
  }

  Widget confirmLogOut() {
    final userProvider = Provider.of<UserProvider>(context);
    final size = MediaQuery.of(context).size;
    return Dialog(
      insetPadding: const EdgeInsets.all(0),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
            width: double.maxFinite,
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
                  const Text(
                    '¿Estas seguro de que deseas cerrar sesión?',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 100.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          onPrimary: MyColors.fuchsia,
                          minimumSize: const Size.fromHeight(45),
                          primary: MyColors.whiteBox,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0))),
                      onPressed: () {
                        authInstance.signOut();
                        GoogleSignIn().signOut();
                        UserPreferences().clearData();
                        userProvider.cleanUser();
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(
                            context, 'home_page', (route) => false);
                      },
                      child: const Text(
                        'Aceptar',
                        style: TextStyle(
                            color: MyColors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(45),
                          primary: MyColors.fuchsia,
                          onPrimary: MyColors.whiteBox,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Future pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.media,
    );

    if (result == null) return;
    pickedFile = result.files.first;
    uploadFile();
    setState(() {});
  }

  Future uploadFile() async {
    final path = 'usersImage/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    var uploadTask = ref.putFile(file);

    final snapshot = await uploadTask.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();
  }
}
