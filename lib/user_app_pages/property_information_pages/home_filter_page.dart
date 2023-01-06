import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:me_cuadra_users/models/user_model.dart';
import 'package:me_cuadra_users/preferences/user_preference.dart';
import 'package:me_cuadra_users/services/firebase/user_crud.dart';
import 'package:me_cuadra_users/user_app_pages/user_login/verify_user.dart';
import 'package:provider/provider.dart';

import '../../colors/colors_data.dart';
import '../../models/complement_models/filters_model.dart';
import '../../preferences/filter_preference.dart';
import '../../providers/card_provider.dart';
import '../../providers/filter_provider.dart';
import '../../utils/currency_input_formatter.dart';
import '../welcome_pages/home_page.dart';

class HomeFilter extends StatefulWidget {
  final FilterProvider filterProvider;
  const HomeFilter({Key? key, required this.filterProvider}) : super(key: key);

  @override
  State<HomeFilter> createState() => _HomeFilterState();
}

class _HomeFilterState extends State<HomeFilter> {
  final price = NumberFormat("#,###", "en_US");
  var controller2 = TextEditingController();
  var minCopController = TextEditingController();
  var maxCopController = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<String> allCitys = [
    "Cucuta",
    "Bucaramanga",
    "Cartagena",
    "Santa Marta",
    "Sincelejo",
    "Barranquilla",
    "Bogota",
    "Tunja",
    "Neiva",
    "Medellin"
  ];
  List<String> allCitys2 = [];
  String query = '';
  FiltersModel filters = FiltersModel();

  @override
  void initState() {
    super.initState();
    filters = widget.filterProvider.filter;
    minCopController.text = price.format(filters.minPrice);
    maxCopController.text = price.format(filters.maxPrice);
    controller2.text = filters.city!;
  }

  @override
  Widget build(BuildContext context) {
    const sb18 = SizedBox(height: 18);
    const sb4 = SizedBox(height: 4);
    return WillPopScope(
      onWillPop: () async {
        backFilters();
        return false;
      },
      child: Scaffold(
          appBar: getAppBar(),
          backgroundColor: MyColors.grey,
          body: Stack(//overflow: Overflow.visible,
              children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Container(width: double.maxFinite, color: Colors.white),
            ),
            Center(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Filtrar Busqueda',
                          style: GoogleFonts.montserrat(
                              color: MyColors.blue2,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        sb4,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Text(
                            'Selecciona las caracteristicas de tu interes',
                            style: GoogleFonts.montserrat(
                                color: MyColors.blue2,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        sb18,
                        Text('Disponibilidad',
                            style: GoogleFonts.montserrat(
                                color: MyColors.blue2,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                        sb4,
                        _availibityFilter(),
                        sb18,
                        Text('Tipo de subasta',
                            style: GoogleFonts.montserrat(
                                color: MyColors.blue2,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                        sb4,
                        _auctionTypeFilter(),
                        sb18,
                        Text('Tipo de residencia',
                            style: GoogleFonts.montserrat(
                                color: MyColors.blue2,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                        sb4,
                        _typesFilter(),
                        sb18,
                        Text('Estado',
                            style: GoogleFonts.montserrat(
                                color: MyColors.blue2,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                        sb4,
                        _conditionFilter(),
                        sb18,
                        Text('Características',
                            style: GoogleFonts.montserrat(
                                color: MyColors.blue2,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                        sb4,
                        sb4,
                        _features(),
                        sb18,
                        Text('Sector',
                            style: GoogleFonts.montserrat(
                                color: MyColors.blue2,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                        sb18,
                        _filterLocation2(),
                        sb18,
                        Text('Presupuesto',
                            style: GoogleFonts.montserrat(
                                color: MyColors.blue2,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                        sb4,
                        _budgetFilter(),
                        sb18,
                        _buttons()
                      ]),
                ),
              ),
            )
          ])),
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
      actions: [
        IconButton(
            onPressed: () {
              backFilters();
            },
            icon: SvgPicture.asset('assets/Icons/Filtro.svg',
                height: 35, width: 35, color: Colors.white))
      ],
    );
  }

  Widget _availibityFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
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
            alignment: WrapAlignment.spaceEvenly,
            spacing: 8,
            runSpacing: -8,
            children: [
              FilterChip(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                  showCheckmark: false,
                  label: const Text('Arriendo'),
                  labelStyle: GoogleFonts.montserrat(
                      color: filters.availibity!.contains('Arriendo')
                          ? Colors.white
                          : MyColors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  selected: filters.availibity!.contains('Arriendo'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(21.0),
                  ),
                  backgroundColor: MyColors.whiteBox,
                  onSelected: (isSelected) {
                    if (filters.availibity!.contains('Arriendo')) {
                      filters.availibity!.remove('Arriendo');
                    } else {
                      filters.availibity!.add('Arriendo');
                    }
                    notifyFilter();
                  },
                  selectedColor: MyColors.blueMarine),
              FilterChip(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 45),
                  showCheckmark: false,
                  label: const Text('Venta'),
                  labelStyle: GoogleFonts.montserrat(
                      color: filters.availibity!.contains('Venta')
                          ? Colors.white
                          : MyColors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  selected: filters.availibity!.contains('Venta'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(21.0),
                  ),
                  backgroundColor: MyColors.whiteBox,
                  onSelected: (isSelected) {
                    if (filters.availibity!.contains('Venta')) {
                      filters.availibity!.remove('Venta');
                    } else {
                      filters.availibity!.add('Venta');
                    }
                    notifyFilter();
                  },
                  selectedColor: MyColors.blueMarine)
            ]),
      ),
    );
  }

  Widget _auctionTypeFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
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
            alignment: WrapAlignment.spaceEvenly,
            spacing: 8,
            runSpacing: -8,
            children: [
              FilterChip(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                  showCheckmark: false,
                  label: const Text('Subasta'),
                  labelStyle: GoogleFonts.montserrat(
                      color: filters.typeOfAuction!.contains('Subasta')
                          ? Colors.white
                          : MyColors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  selected: filters.typeOfAuction!.contains('Subasta'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(21.0),
                  ),
                  backgroundColor: MyColors.whiteBox,
                  onSelected: (isSelected) {
                    if (filters.typeOfAuction!.contains('Subasta')) {
                      filters.typeOfAuction!.remove('Subasta');
                    } else {
                      filters.typeOfAuction!.add('Subasta');
                    }
                    notifyFilter();
                  },
                  selectedColor: MyColors.blueMarine),
              FilterChip(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                  showCheckmark: false,
                  label: const Text('Subasta Express'),
                  labelStyle: GoogleFonts.montserrat(
                      color: filters.typeOfAuction!.contains('Express')
                          ? Colors.white
                          : MyColors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  selected: filters.typeOfAuction!.contains('Express'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(21.0),
                  ),
                  backgroundColor: MyColors.whiteBox,
                  onSelected: (isSelected) {
                    if (filters.typeOfAuction!.contains('Express')) {
                      filters.typeOfAuction!.remove('Express');
                    } else {
                      filters.typeOfAuction!.add('Express');
                    }
                    notifyFilter();
                  },
                  selectedColor: MyColors.blueMarine)
            ]),
      ),
    );
  }

  Widget _typesFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
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
        child: Column(children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    spacing: 0,
                    runSpacing: 0,
                    children: [
                      FilterChip(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 5),
                          showCheckmark: false,
                          label: const Text('Apartamento'),
                          labelStyle: GoogleFonts.montserrat(
                              color: filters.typeOfResidence!
                                      .contains('Apartamento')
                                  ? Colors.white
                                  : MyColors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                          selected:
                              filters.typeOfResidence!.contains('Apartamento'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(21.0),
                          ),
                          backgroundColor: MyColors.whiteBox,
                          onSelected: (isSelected) {
                            if (filters.typeOfResidence!
                                .contains('Apartamento')) {
                              filters.typeOfResidence!.remove('Apartamento');
                            } else {
                              filters.typeOfResidence!.add('Apartamento');
                            }
                            notifyFilter();
                          },
                          selectedColor: MyColors.blueMarine),
                      FilterChip(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 20),
                          showCheckmark: false,
                          label: const Text('Casa'),
                          labelStyle: GoogleFonts.montserrat(
                              color: filters.typeOfResidence!.contains('Casa')
                                  ? Colors.white
                                  : MyColors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                          selected: filters.typeOfResidence!.contains('Casa'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(21.0),
                          ),
                          backgroundColor: MyColors.whiteBox,
                          onSelected: (isSelected) {
                            if (filters.typeOfResidence!.contains('Casa')) {
                              filters.typeOfResidence!.remove('Casa');
                            } else {
                              filters.typeOfResidence!.add('Casa');
                            }
                            notifyFilter();
                          },
                          selectedColor: MyColors.blueMarine),
                      FilterChip(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 10),
                          showCheckmark: false,
                          label: const Text('Oficina'),
                          labelStyle: GoogleFonts.montserrat(
                              color:
                                  filters.typeOfResidence!.contains('Oficina')
                                      ? Colors.white
                                      : MyColors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                          selected:
                              filters.typeOfResidence!.contains('Oficina'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(21.0),
                          ),
                          backgroundColor: MyColors.whiteBox,
                          onSelected: (isSelected) {
                            if (filters.typeOfResidence!.contains('Oficina')) {
                              filters.typeOfResidence!.remove('Oficina');
                            } else {
                              filters.typeOfResidence!.add('Oficina');
                            }
                            notifyFilter();
                          },
                          selectedColor: MyColors.blueMarine)
                    ]),
              )
            ],
          ),
          const SizedBox(height: 0),
          Row(
            children: [
              Expanded(
                child: Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    spacing: 0,
                    runSpacing: 0,
                    children: [
                      FilterChip(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 2),
                          showCheckmark: false,
                          label: const Text('Apartaestudio'),
                          labelStyle: GoogleFonts.montserrat(
                              color: filters.typeOfResidence!
                                      .contains('Apartaestudio')
                                  ? Colors.white
                                  : MyColors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                          selected: filters.typeOfResidence!
                              .contains('Apartaestudio'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(21.0),
                          ),
                          backgroundColor: MyColors.whiteBox,
                          onSelected: (isSelected) {
                            if (filters.typeOfResidence!
                                .contains('Apartaestudio')) {
                              filters.typeOfResidence!.remove('Apartaestudio');
                            } else {
                              filters.typeOfResidence!.add('Apartaestudio');
                            }
                            notifyFilter();
                          },
                          selectedColor: MyColors.blueMarine),
                      FilterChip(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 10),
                          showCheckmark: false,
                          label: const Text('Duplex'),
                          labelStyle: GoogleFonts.montserrat(
                              color: filters.typeOfResidence!.contains('Duplex')
                                  ? Colors.white
                                  : MyColors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                          selected: filters.typeOfResidence!.contains('Duplex'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(21.0),
                          ),
                          backgroundColor: MyColors.whiteBox,
                          onSelected: (isSelected) {
                            if (filters.typeOfResidence!.contains('Duplex')) {
                              filters.typeOfResidence!.remove('Duplex');
                            } else {
                              filters.typeOfResidence!.add('Duplex');
                            }
                            notifyFilter();
                          },
                          selectedColor: MyColors.blueMarine),
                      FilterChip(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 10),
                          showCheckmark: false,
                          label: const Text('Finca'),
                          labelStyle: GoogleFonts.montserrat(
                              color: filters.typeOfResidence!.contains('Finca')
                                  ? Colors.white
                                  : MyColors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                          selected: filters.typeOfResidence!.contains('Finca'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(21.0),
                          ),
                          backgroundColor: MyColors.whiteBox,
                          onSelected: (isSelected) {
                            if (filters.typeOfResidence!.contains('Finca')) {
                              filters.typeOfResidence!.remove('Finca');
                            } else {
                              filters.typeOfResidence!.add('Finca');
                            }
                            notifyFilter();
                          },
                          selectedColor: MyColors.blueMarine)
                    ]),
              )
            ],
          ),
          const SizedBox(height: 0),
          Row(
            children: [
              Expanded(
                child: Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    spacing: 0,
                    runSpacing: 0,
                    children: [
                      FilterChip(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 2),
                          showCheckmark: false,
                          label: const Text('Penthouse'),
                          labelStyle: GoogleFonts.montserrat(
                              color:
                                  filters.typeOfResidence!.contains('Penthouse')
                                      ? Colors.white
                                      : MyColors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                          selected:
                              filters.typeOfResidence!.contains('Penthouse'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(21.0),
                          ),
                          backgroundColor: MyColors.whiteBox,
                          onSelected: (isSelected) {
                            if (filters.typeOfResidence!
                                .contains('Penthouse')) {
                              filters.typeOfResidence!.remove('Penthouse');
                            } else {
                              filters.typeOfResidence!.add('Penthouse');
                            }
                            notifyFilter();
                          },
                          selectedColor: MyColors.blueMarine),
                    ]),
              )
            ],
          )
        ]),
      ),
    );
  }

  Widget _conditionFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: double.maxFinite,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: MyColors.shadow.withOpacity(0.16),
                  offset: const Offset(5, 6),
                  blurRadius: 11,
                  spreadRadius: 1)
            ]),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: InkWell(
                      onTap: () {
                        if (filters.stateOfResidence!.contains('Nuevo')) {
                          filters.stateOfResidence!.remove('Nuevo');
                        } else {
                          filters.stateOfResidence!.add('Nuevo');
                        }
                        notifyFilter();
                      },
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 4, bottom: 4),
                            child: Container(
                                height: 22,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: filters.stateOfResidence!
                                            .contains('Nuevo')
                                        ? MyColors.blueMarine
                                        : MyColors.whiteBox)),
                          ),
                          Positioned(
                              right: 15,
                              top: 6,
                              child: Text(
                                'Nuevo',
                                style: GoogleFonts.montserrat(
                                    color: filters.stateOfResidence!
                                            .contains('Nuevo')
                                        ? Colors.white
                                        : MyColors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              )),
                          Positioned(
                              top: -2,
                              left: 0,
                              child: Container(
                                  height: 33,
                                  width: 33,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: MyColors.whiteBox),
                                  child: const Icon(Icons.auto_awesome_sharp,
                                      color: MyColors.grey))),
                        ],
                      )),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (filters.stateOfResidence!.contains('Proyecto')) {
                      filters.stateOfResidence!.remove('Proyecto');
                    } else {
                      filters.stateOfResidence!.add('Proyecto');
                    }
                    notifyFilter();
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, top: 4, bottom: 4),
                    child: Container(
                      height: 22,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: filters.stateOfResidence!.contains('Proyecto')
                              ? MyColors.blueMarine
                              : MyColors.whiteBox),
                      child: Text(
                        'Proyecto',
                        style: GoogleFonts.montserrat(
                            color:
                                filters.stateOfResidence!.contains('Proyecto')
                                    ? Colors.white
                                    : MyColors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: InkWell(
                      onTap: () {
                        if (filters.stateOfResidence!.contains('Usado')) {
                          filters.stateOfResidence!.remove('Usado');
                        } else {
                          filters.stateOfResidence!.add('Usado');
                        }
                        notifyFilter();
                      },
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 4, bottom: 4),
                            child: Container(
                                height: 22,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: filters.stateOfResidence!
                                            .contains('Usado')
                                        ? MyColors.blueMarine
                                        : MyColors.whiteBox)),
                          ),
                          Positioned(
                              right: 15,
                              top: 6,
                              child: Text(
                                'Usado',
                                style: GoogleFonts.montserrat(
                                    color: filters.stateOfResidence!
                                            .contains('Usado')
                                        ? Colors.white
                                        : MyColors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              )),
                          Positioned(
                              top: -1,
                              left: 0,
                              child: Container(
                                  height: 33,
                                  width: 33,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: MyColors.whiteBox),
                                  child: const Icon(Icons.autorenew,
                                      color: MyColors.grey))),
                        ],
                      )),
                ),
              )
            ]),
      ),
    );
  }

  Widget _features() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: MyColors.shadow.withOpacity(0.16),
                    offset: const Offset(5, 6),
                    blurRadius: 11,
                    spreadRadius: 1)
              ]),
          child: Column(children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                        color: MyColors.shadow.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white, width: 2)),
                    child: Stack(children: [
                      Positioned(
                        left: 0,
                        top: 1,
                        child: InkWell(
                          onTap: () {
                            if (filters.room! > 0) {
                              filters.room = filters.room! - 1;
                            }
                            notifyFilter();
                          },
                          child: Container(
                            width: 33,
                            height: 33,
                            decoration: BoxDecoration(
                              color: MyColors.blueMarine,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child:
                                const Icon(Icons.remove, color: Colors.white),
                          ),
                        ),
                      ),
                      Positioned(
                          right: 55,
                          top: 10,
                          child: Text(
                            filters.room.toString(),
                            style: GoogleFonts.montserrat(
                                color: MyColors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          )),
                      Positioned(
                        right: 0,
                        top: 1,
                        child: SizedBox(
                          width: 33,
                          height: 33,
                          child: InkWell(
                            onTap: () {
                              filters.room = filters.room! + 1;
                              notifyFilter();
                            },
                            child: Container(
                              width: 33,
                              height: 33,
                              decoration: BoxDecoration(
                                color: MyColors.blueMarine,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ])),
                SizedBox(
                    width: 120,
                    height: 20,
                    child: Text("Habitaciones",
                        style: GoogleFonts.montserrat(
                            color: MyColors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left))
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                        color: MyColors.shadow.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white, width: 2)),
                    child: Stack(children: [
                      Positioned(
                        left: 0,
                        top: 1,
                        child: SizedBox(
                          width: 33,
                          height: 33,
                          child: InkWell(
                            onTap: () {
                              if (filters.bath! > 0) {
                                filters.bath = filters.bath! - 1;
                              }
                              notifyFilter();
                            },
                            child: Container(
                              width: 33,
                              height: 33,
                              decoration: BoxDecoration(
                                color: MyColors.blueMarine,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child:
                                  const Icon(Icons.remove, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          right: 55,
                          top: 10,
                          child: Text(
                            filters.bath.toString(),
                            style: GoogleFonts.montserrat(
                                color: MyColors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          )),
                      Positioned(
                        right: 0,
                        top: 1,
                        child: SizedBox(
                          width: 33,
                          height: 33,
                          child: InkWell(
                            onTap: () {
                              filters.bath = filters.bath! + 1;
                              notifyFilter();
                            },
                            child: Container(
                              width: 33,
                              height: 33,
                              decoration: BoxDecoration(
                                color: MyColors.blueMarine,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ])),
                SizedBox(
                    width: 120,
                    height: 20,
                    child: Text("Baños",
                        style: GoogleFonts.montserrat(
                            color: MyColors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left))
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                        color: MyColors.shadow.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white, width: 2)),
                    child: Stack(children: [
                      Positioned(
                        left: 0,
                        top: 1,
                        child: SizedBox(
                          width: 33,
                          height: 33,
                          child: InkWell(
                            onTap: () {
                              if (filters.garage! > 0) {
                                filters.garage = filters.garage! - 1;
                              }
                              notifyFilter();
                            },
                            child: Container(
                              width: 33,
                              height: 33,
                              decoration: BoxDecoration(
                                color: MyColors.blueMarine,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child:
                                  const Icon(Icons.remove, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          right: 55,
                          top: 10,
                          child: Text(
                            filters.garage.toString(),
                            style: GoogleFonts.montserrat(
                                color: MyColors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          )),
                      Positioned(
                        right: 0,
                        top: 1,
                        child: SizedBox(
                          width: 33,
                          height: 33,
                          child: InkWell(
                            onTap: () {
                              filters.garage = filters.garage! + 1;
                              notifyFilter();
                            },
                            child: Container(
                              width: 33,
                              height: 33,
                              decoration: BoxDecoration(
                                color: MyColors.blueMarine,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ])),
                SizedBox(
                    width: 120,
                    height: 20,
                    child: Text("Parqueaderos",
                        style: GoogleFonts.montserrat(
                            color: MyColors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left)),
              ],
            ),
            const SizedBox(height: 10)
          ])),
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

  void backFilters() {
    Navigator.pushNamedAndRemoveUntil(context, 'home_page', (route) => false);
  }

  Widget _filterLocation2() {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: MyColors.shadow.withOpacity(0.16),
                      offset: const Offset(5, 6),
                      blurRadius: 11,
                      spreadRadius: 1)
                ]),
            child: TextField(
                textAlign: TextAlign.left,
                style: GoogleFonts.montserrat(
                    color: MyColors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
                controller: controller2,
                decoration: InputDecoration(
                    hintStyle: GoogleFonts.montserrat(
                        color: MyColors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                    suffixIcon: const Icon(Icons.search, color: MyColors.blue2),
                    hintText: 'Ciudades',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
                onChanged: _searchCity)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60),
        child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                    color: MyColors.shadow.withOpacity(0.16),
                    offset: const Offset(5, 6),
                    blurRadius: 11,
                    spreadRadius: 1)
              ]),
          child: ListView.builder(
            controller: scrollController,
            shrinkWrap: true,
            itemCount: allCitys2.length,
            itemBuilder: (context, index) {
              final city = allCitys2[index];
              return ListTile(
                title: Text(
                  city,
                  style: GoogleFonts.montserrat(
                      color: MyColors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  controller2.text = city;
                  allCitys2 = [];
                  setState(() {});
                  //Filtrar por ciudad
                },
              );
            },
          ),
        ),
      )
    ]);
  }

  void _searchCity(String query) {
    allCitys2 = allCitys;
    if (query.length >= 3) {
      final suggestions = allCitys2.where((city) {
        final cityLower = city.toLowerCase();
        final input = query.toLowerCase();
        return cityLower.contains(input);
      }).toList();
      setState(() {
        allCitys2 = suggestions;
      });
    } else {
      allCitys2 = [];
      setState(() {});
    }
  }

  Widget _budgetFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: MyColors.shadow.withOpacity(0.16),
                    offset: const Offset(5, 6),
                    blurRadius: 11,
                    spreadRadius: 1)
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text("Minimo COP",
                        style: GoogleFonts.montserrat(
                            color: MyColors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(21),
                          color: MyColors.whiteBox,
                        ),
                        child: TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CurrencyInputFormatter()
                          ],
                          keyboardType: TextInputType.number,
                          autofocus: false,
                          dragStartBehavior: DragStartBehavior.down,
                          onChanged: (value) {
                            if (value != '') {
                              filters.minPrice = int.tryParse(
                                  value.replaceAll(RegExp(','), ''));
                            } else {
                              filters.minPrice = 0;
                            }
                            notifyFilter();
                          },
                          controller: minCopController,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              color: MyColors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                          decoration: _buildInputDecoration(),
                          maxLength: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10)
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text("Máximo COP",
                        style: GoogleFonts.montserrat(
                            color: MyColors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(21),
                          color: MyColors.whiteBox,
                        ),
                        child: TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CurrencyInputFormatter()
                          ],
                          keyboardType: TextInputType.number,
                          autofocus: false,
                          dragStartBehavior: DragStartBehavior.down,
                          onChanged: (value) {
                            if (value != '') {
                              filters.maxPrice = int.tryParse(
                                  value.replaceAll(RegExp(','), ''));
                            } else {
                              filters.maxPrice = 0;
                            }
                            notifyFilter();
                          },
                          textAlign: TextAlign.center,
                          controller: maxCopController,
                          style: GoogleFonts.montserrat(
                              color: MyColors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                          decoration: _buildInputDecoration(),
                          maxLength: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10)
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget _buttons() {
    final provider = Provider.of<FilterProvider>(context);
    return Column(children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: MyColors.fuchsia,
            boxShadow: [
              BoxShadow(
                  color: MyColors.shadow.withOpacity(0.16),
                  offset: const Offset(5, 6),
                  blurRadius: 11,
                  spreadRadius: 1)
            ]),
        child: InkWell(
          onTap: () {
            filters.city = controller2.text;
            FilterPreference().saveData(filters);
            provider.setFilter(filters);
            final providerCard =
                Provider.of<CardProvider>(context, listen: false);
            providerCard.resetResidences();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false);
          },
          child: Text(
            'Aplicar Filtros',
            style: GoogleFonts.montserrat(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: MyColors.whiteBox,
            boxShadow: [
              BoxShadow(
                  color: MyColors.shadow.withOpacity(0.16),
                  offset: const Offset(5, 6),
                  blurRadius: 11,
                  spreadRadius: 1)
            ]),
        child: InkWell(
          onTap: () {
            minCopController.text = '0';
            maxCopController.text = '0';
            controller2.text = '';
            filters = FiltersModel().emptyModel();
            widget.filterProvider.setFilter(filters);
            FilterPreference().saveData(filters);
          },
          child: Text(
            'Eliminar Filtros',
            style: GoogleFonts.montserrat(
                color: MyColors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      )
    ]);
  }

  _buildInputDecoration() {
    return InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      focusedBorder: _buildOutlineBorder(),
      enabledBorder: _buildOutlineBorder(),
      disabledBorder: InputBorder.none,
      hintText: '0',
      hintStyle: GoogleFonts.montserrat(
          color: MyColors.grey, fontSize: 14, fontWeight: FontWeight.w600),
      counterText: '',
    );
  }

  _buildOutlineBorder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(color: Colors.transparent, width: 0));
  }

  notifyFilter() {
    widget.filterProvider.setFilter(filters);
    FilterPreference().saveData(filters);
  }
}
