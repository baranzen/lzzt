import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lzzt/pages/admin_page.dart';
import 'package:lzzt/pages/admin_page_products.dart';
import 'package:lzzt/pages/home_page.dart';
import 'package:lzzt/pages/login_page.dart';
import 'package:lzzt/pages/signin_page.dart';
import 'package:lzzt/pages/user_page.dart';
import 'package:lzzt/providers/app_provider.dart';

class RouteGenerator {
  static Route<dynamic>? routeGenerator(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _buildRouteForHome();
      case '/logInPage':
        return pageRouteBuilder(LoginPage());
      case '/signInPage':
        return pageRouteBuilder(SignInPage());
      case '/userPage':
        return pageRouteBuilder(const UserPage());
      case '/adminPage':
        return pageRouteBuilder(const AdminPage());
      case '/adminPageProducts':
        return pageRouteBuilder(const AdminPageProducts());
    }
    return null;
  }

  static PageRouteBuilder<dynamic> _buildRouteForHome() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return Consumer(
          builder: (context, ref, child) {
            final isAdmin = ref.watch(isAdminNotifierProvider);
            return isAdmin ? const AdminPage() : const HomePage();
          },
        );
      },
    );
  }

  static PageRouteBuilder<dynamic> pageRouteBuilder(route) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => route,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
