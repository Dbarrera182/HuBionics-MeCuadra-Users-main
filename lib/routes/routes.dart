import 'package:flutter/material.dart';
import 'package:me_cuadra_users/user_app_pages/welcome_pages/intro_pages.dart';

import '../user_app_pages/welcome_pages/check_login_user_page.dart';
import '../user_app_pages/welcome_pages/home_page.dart';
import '../user_app_pages/user_login/login_page.dart';
import '../user_app_pages/user_login/register_page.dart';

Map<String, WidgetBuilder> getApplicationRoute() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => VerifyLoginUser(),
    'home_page': (BuildContext context) => const HomePage(),
    'verify_login_user': (BuildContext context) => VerifyLoginUser(),
    'login_page': (BuildContext context) => const LoginPage(),
    'register_page': (BuildContext context) => const RegisterPage(),
    'intro_pages': (BuildContext context) => const IntroPages(),
  };
}
