import '../../models/PalyerModel.dart';

class PlayerModelList {
  final List<PlayerModel> players;

  PlayerModelList({required this.players});

  factory PlayerModelList.fromJson(dynamic json) { // <--dynamic instead of List<dynamic>
    if (json is List) {
      return PlayerModelList(
        players: json.map((e) => PlayerModel.fromJson(e)).toList(),
      );
    } else {
      throw FormatException('Invalid JSON format. Expected a list.');
    }
  }
}