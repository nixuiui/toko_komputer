import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  
  static const IS_AUTHENTICATED = "isAuthenticated";
  static const ACCOUNT = "account";
  static const CART = "cart";
  static const API_TOKEN = "apiToken";

  static setAuthenticated(bool data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(IS_AUTHENTICATED, data);
  }
  
  static Future<bool> isAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(IS_AUTHENTICATED) ?? false;
  }
  
  static setApiToken(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(API_TOKEN, data);
  }
  
  static Future<String> getApiToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(API_TOKEN);
  }
  
  static clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
  
  // static setAccount(String data) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString(ACCOUNT, data);
  // }
  
  // static Future<String> getAccount() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(ACCOUNT);
  // }

  // static setCart(String data) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString(CART, data);
  // }
  
}