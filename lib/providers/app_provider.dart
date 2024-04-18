import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lzzt/providers/basket_notifier.dart';
import 'package:lzzt/providers/is_admin_notifier.dart';
import 'package:lzzt/providers/is_dark_notifier.dart';

final isDarkNotifierProvider =
    StateNotifierProvider<IsDarkNotifier, bool>((ref) => IsDarkNotifier());

final isAdminNotifierProvider =
    StateNotifierProvider<IsAdminNotifier, bool>((ref) => IsAdminNotifier());

final basketNotifierProvider =
    StateNotifierProvider<BasketNotifier, int>((ref) => BasketNotifier());
