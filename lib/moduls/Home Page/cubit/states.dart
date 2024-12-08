import '../../../models/PalyerModel.dart';

abstract class BlurStates {}

class BlurInitialState extends BlurStates {
  final double blurLevel;

  BlurInitialState(this.blurLevel);
}

class BlurUpdatedState extends BlurStates {
  final double blurLevel;

  BlurUpdatedState(this.blurLevel);
}
class PlayerLoadingState extends BlurStates {}

class PlayerSuccessState extends BlurStates {
  final List<PlayerModel> player ;

  PlayerSuccessState(this.player);
}

class PlayerErrorState extends BlurStates {
  final String message;

  PlayerErrorState(this.message);
}