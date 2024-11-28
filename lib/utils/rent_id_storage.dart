import 'dart:html' as html;

class RentIdStorage {
  static const String _rentIdKeyPrefix = 'rent_id_';

  // Save rentId
  static Future<void> saveRentId(int roomId, int rentId) async {
    html.window.localStorage['$_rentIdKeyPrefix$roomId'] = rentId.toString();
  }

  // Load rentId
  static Future<int?> loadRentId(int roomId) async {
    final rentId = html.window.localStorage['$_rentIdKeyPrefix$roomId'];
    return rentId != null ? int.tryParse(rentId) : null;
  }

  // Clear rentId
  static Future<void> clearRentId(int roomId) async {
    html.window.localStorage.remove('$_rentIdKeyPrefix$roomId');
  }
}
