import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lzzt/providers/is_dark_notifier.dart';

final isDarkNotifierProvider =
    StateNotifierProvider<IsDarkNotifier, bool>((ref) => IsDarkNotifier());
