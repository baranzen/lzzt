import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lzzt/services/hive_services.dart';

class IsAdminNotifier extends StateNotifier<bool> {
  IsAdminNotifier() : super(HiveServices.isAdmin());

  void setAdmin() {
    state = true;
    debugPrint('isAdmin: $state set in IsAdminNotifier');
  }

  Future<void> logOutAdmin() async {
    // widget agacindaki tum widgetlari
    state = false;
    await HiveServices.setAdmin(false);
    debugPrint('isAdmin: $state set in IsAdminNotifier');
  }
}
