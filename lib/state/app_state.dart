import 'package:final_year_project_kiki/models/currency.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currencies = StateProvider<List<Country>>((ref) => []);
