import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper
{

  static late SharedPreferences prefs;

  static init() async
  {
    prefs = await SharedPreferences.getInstance();
  }

  static void saveValue({
    required String key,
    required String value
  }) async
  {
    await prefs.setString(key, value);
  }

  static Future<String?> getValue({
    required String key
  }) async
  {
    return prefs.getString(key);
  }

  static Future<bool> removeData({
    required String key
  }) async
  {
    return await prefs.remove(key);
  }

}