import 'package:shared_preferences/shared_preferences.dart';

class RentIdStorage {
  static const String _rentIdKeyPrefix = 'rent_id_';

  static Future<void> saveRentId(int roomId, int rentId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_rentIdKeyPrefix$roomId', rentId);
  }

  static Future<int?> loadRentId(int roomId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_rentIdKeyPrefix$roomId');
  }

  static Future<void> clearRentId(int roomId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_rentIdKeyPrefix$roomId');
  }
}
