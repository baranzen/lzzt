import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lzzt/pages/admin_orders_page.dart';
import 'package:lzzt/pages/admin_page.dart';
import 'package:lzzt/pages/admin_page_products.dart';
import 'package:lzzt/pages/admin_statistics_page.dart';

import 'package:lzzt/pages/home_page.dart';
import 'package:lzzt/pages/login_page.dart';
import 'package:lzzt/pages/restaurant_page.dart';
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
        return pageRouteBuilder(UserOrdersPage(), isAppBar: true);
      case '/userBasketPage':
        return pageRouteBuilder(const UserBasketPage(), isAppBar: true);
      case '/restaurantPage':
        Object? data = settings.arguments;
        return pageRouteBuilder(RestaurantPage(
          data: data as Map<String, dynamic>,
        ));
      case '/adminPage':
        return pageRouteBuilder(const AdminPage());
      case '/adminPageProducts':
        return pageRouteBuilder(const AdminPageProducts());
      case '/adminOrdersPage':
        return pageRouteBuilder(const AdminOrdersPage());
      case '/adminStatisticsPage':
        return pageRouteBuilder(
          const AdminStatisticsPage(),
        );
    }
    return null;
  }

  static MaterialPageRoute _buildRouteForHome() {
    return NoAnimationMaterialPageRoute(
      builder: (_) {
        // pushReplacementNamed('/userPage');
        return Consumer(
          builder: (context, ref, child) {
            final isAdmin = ref.watch(isAdminNotifierProvider);
            return isAdmin ? const AdminPage() : HomePage();
          },
        );
      },
    );
  }

//no animaton page route builder
  static MaterialPageRoute pageRouteBuilder(Widget page, {isAppBar = false}) {
    if (isAppBar) {
      //return a no animation page material page route
      return NoAnimationMaterialPageRoute(builder: (_) => page);
    } else {
      return MaterialPageRoute(builder: (_) => page, fullscreenDialog: true);
    }
  }
}

class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
            builder: builder,
            maintainState: maintainState,
            settings: settings,
            fullscreenDialog: fullscreenDialog);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
