import 'package:flutter/material.dart';
import 'package:lzzt/constans/app_helper.dart';
import 'package:lzzt/constans/theme_data.dart';
import 'package:lzzt/services/route_generator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppHelper.appName,
      theme: appThemeData(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.routeGenerator,
    );
  }
}
