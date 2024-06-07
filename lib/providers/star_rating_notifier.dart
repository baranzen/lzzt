import 'package:flutter_riverpod/flutter_riverpod.dart';

class StarRatingNotifier extends StateNotifier<double> {
  StarRatingNotifier() : super(5.0);

  void setRating(double rating) {
    state = rating;
  }
}
