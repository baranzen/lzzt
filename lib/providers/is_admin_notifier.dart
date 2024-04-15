import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lzzt/services/hive_services.dart';

class IsAdminNotifier extends StateNotifier<bool> {
  IsAdminNotifier() : super(HiveServices.isAdmin());

  void setAdmin() {
    state = true;
    debugPrint('isAdmin: $state set in IsAdminNotifier');
  }

  void logOutAdmin() {
    state = false;
    debugPrint('isAdmin: $state set in IsAdminNotifier');
  }
}
