import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lzzt/pages/admin_page.dart';
import 'package:lzzt/pages/admin_page_products.dart';
import 'package:lzzt/pages/home_page.dart';
import 'package:lzzt/pages/login_page.dart';
import 'package:lzzt/pages/signin_page.dart';
import 'package:lzzt/pages/user_basket_page.dart';
import 'package:lzzt/pages/user_orders_page.dart';
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
      case '/userOrdersPage':
        return pageRouteBuilder(const UserOrdersPage());
      case '/userBasketPage':
        return pageRouteBuilder(const UserBasketPage());
      case '/adminPage':
        return pageRouteBuilder(const AdminPage());
      case '/adminPageProducts':
        return pageRouteBuilder(const AdminPageProducts());
    }
    return null;
  }

  static MaterialPageRoute _buildRouteForHome() {
    return MaterialPageRoute(
        builder: (_) {
          // pushReplacementNamed('/userPage');
          return Consumer(
            builder: (context, ref, child) {
              final isAdmin = ref.watch(isAdminNotifierProvider);
              return isAdmin ? const AdminPage() : HomePage();
            },
          );
        },
        fullscreenDialog: true);
  }

//no animaton page route builder
  static MaterialPageRoute pageRouteBuilder(Widget page) {
    return MaterialPageRoute(builder: (_) => page, fullscreenDialog: true);
  }
}
