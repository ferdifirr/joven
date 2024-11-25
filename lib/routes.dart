import 'package:flutter/material.dart';
import 'package:joven/screen/home_screen.dart';
import 'package:joven/screen/login_screen.dart';
import 'package:joven/screen/register_screen.dart';
import 'package:joven/screen/register_vendor_screen.dart';
import 'package:joven/screen/splash_screen.dart';
import 'package:joven/screen/store_screen.dart';

class Routes {
  static const String initial = '/';
  static const String home = '/home';
  static const String login = '/auth';
  static const String register = '/auth/register';
  static const String registerVendor = '/auth/register/vendor';
  static const String store = '/store';


  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    home: (context) => const HomeScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    registerVendor: (context) => const RegisterVendorScreen(),
    store: (context) => const StoreScreen(),
  };
}