import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HiveService {
  static const String boxName = 'myBox';
  static const String userDataKey = 'userData';
  static const String tokenKey = 'token';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  static saveUserData(Map<String, dynamic> data) {
    final box = Hive.box(boxName);
    final jsonStr = jsonEncode(data);
    box.put(userDataKey, jsonStr);
  }

  static void saveToken(String token) {
    final box = Hive.box(boxName);
    box.put(tokenKey, token);
  }

  static Map<String, dynamic> getUserData() {
    final box = Hive.box(boxName);
    final token = box.get(tokenKey);
    if (token == null) return {};
    return JwtDecoder.decode(token);
  }
}
