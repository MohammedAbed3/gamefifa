import '../../models/PalyerModel.dart';
import '../../sharit/network/online.dart';

class PlayerService {
  static List<PlayerModel> players = [];  // هنا تكون القائمة التي تحتوي على اللاعبين

  // هذه الدالة ستبحث عن اللاعبين بناءً على النص الذي يدخله المستخدم
  static Future<List<PlayerModel>> find(String search) async {
    if (players.isEmpty) {
      // إذا كانت القائمة فارغة، نقوم بتحميل البيانات أولاً
      await loadPlayers();
    }

    // يتم تصفية اللاعبين بناءً على ما يكتبه المستخدم في الـ TextField
    return players.where((player) {
      return player.lastName.toLowerCase().contains(search.toLowerCase());
    }).toList();
  }

  // يمكنك تحميل بيانات اللاعبين هنا (من API أو من مصدر بيانات آخر)
  static Future<void> loadPlayers() async {
    players = await fetchPlayerData();  // جلب البيانات من API
  }
}
