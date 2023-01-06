import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:me_cuadra_users/user_app_pages/welcome_pages/init_login_page.dart';
import 'package:me_cuadra_users/user_app_pages/welcome_pages/intro_page_widget.dart';
import 'package:me_cuadra_users/user_app_pages/welcome_pages/welcome_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../colors/colors_data.dart';

class IntroPages extends StatefulWidget {
  const IntroPages({Key? key}) : super(key: key);

  @override
  State<IntroPages> createState() => _IntroPagesState();
}

class _IntroPagesState extends State<IntroPages> {
  final pageController = PageController();
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const WelcomePage()),
            (_) => false);

        return false;
      },
      child: Scaffold(
        appBar: getAppBar(),
        body: PageView(
          controller: pageController,
          children: [
            IntroPageWidget(
                assetImage: 'assets/Intro/intro1.png',
                title: 'Encontrar arriendo',
                subtitle: 'La primera impresión importa, ',
                description:
                    'desliza a la izquierda para descartar y a la derecha para encontrar el arriendo perfecto para ti'),
            IntroPageWidget(
                assetImage: 'assets/Intro/intro2.png',
                title: 'Cuadrar una compra',
                subtitle: 'Encuentra el espacio a tu medida, ',
                description:
                    'aplicando filtros que aceleran la búsqueda de la propiedad de tus sueños'),
            IntroPageWidget(
                assetImage: 'assets/Intro/intro3.jpg',
                title: 'Dejar en arriendo',
                subtitle: '¡Tu propiedad al mejor postor! ',
                description:
                    'Subasta el arriendo y recibe las mejores ofertas'),
            IntroPageWidget(
                assetImage: 'assets/Intro/intro4.jpg',
                title: 'Cuadrar una venta',
                subtitle: 'Recibe atención personalizada ',
                description:
                    'y vende tu propiedad de forma rápida y al mejor precio'),
          ],
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Container(
            color: Colors.white,
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SmoothPageIndicator(
                  controller: pageController,
                  count: 4,
                  effect: const SwapEffect(
                      spacing: 16,
                      dotColor: MyColors.whiteBox,
                      activeDotColor: MyColors.fuchsia),
                  onDotClicked: (index) => pageController.animateToPage(index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOutExpo),
                ),
                GestureDetector(
                  onTap: () {
                    if (pageController.page != 3) {
                      pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOutExpo);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InitLoginPage()),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: MyColors.fuchsia,
                        boxShadow: [
                          BoxShadow(
                              color: MyColors.shadow.withOpacity(0.16),
                              offset: const Offset(0, 12),
                              blurRadius: 6)
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(
                        'assets/Icons/Next.svg',
                        width: 20,
                        height: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
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
                  MaterialPageRoute(builder: (_) => const WelcomePage()),
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
}
