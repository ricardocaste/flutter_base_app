import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_app/domain/entities/user.dart';

class Utils {
  static User? getUser() {
    User? user;
    try {
      user =
          Get.find<User>(tag: 'user'); 
    } catch (e) {
      if (kDebugMode) {
        print('User not found');
      }
    }
    return user;
  }

  static void setUser(User user) {
    try {
      Get.put<User>(user, tag: 'user');
    } catch (e) {
      if (kDebugMode) {
        print('Error al establecer el usuario: $e');
      }
    }
  }

  static bool isUserLoged() {
    return Utils.getUser() != null;
  }
}