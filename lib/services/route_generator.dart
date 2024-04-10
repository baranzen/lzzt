import 'package:flutter/material.dart';
import 'package:lzzt/pages/home_page.dart';
import 'package:lzzt/pages/login_page.dart';
import 'package:lzzt/pages/signin_page.dart';
import 'package:lzzt/pages/user_page.dart';

class RouteGenerator {
  static Route<dynamic>? routeGenerator(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => const HomePage(),
        );
      case '/logInPage':
        return MaterialPageRoute(
          builder: (context) => LoginPage(),
        );
      case '/signInPage':
        return MaterialPageRoute(
          builder: (context) => SignInPage(),
        );
      case '/userPage':
        return MaterialPageRoute(
          builder: (context) => const UserPage(),
        );
    }
    return null;
  }
}
