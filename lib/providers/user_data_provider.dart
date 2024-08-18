import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_data.dart';

final userDataProvider = StateProvider<UserData?>((ref){
  return UserData();
});