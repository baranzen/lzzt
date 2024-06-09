import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:lzzt/constans/app_helper.dart';
import 'package:lzzt/constans/theme_data.dart';
import 'package:lzzt/models/products_model.dart';
import 'package:lzzt/models/times_adapter.dart';
import 'package:lzzt/providers/app_provider.dart';
import 'package:lzzt/services/route_generator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TimestampAdapter());
  Hive.registerAdapter(ProductsAdapter());
  await Hive.openBox<List<Products>>('userOrders');
  await Hive.openBox<Products>('basket');
  await Hive.openBox('lzzt');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('tr', '');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return MaterialApp(
      themeMode: ref.watch<bool>(isDarkNotifierProvider)
          ? ThemeMode.dark
          : ThemeMode.light,
      title: AppHelper.appName,
      theme: appThemeDataLight(),
      darkTheme: appThemeDataDark(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.routeGenerator,
      themeAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInCubic,
      ),
    );
  }
}
