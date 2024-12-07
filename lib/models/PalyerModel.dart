class PlayerModel {
  final int id;
  final int rank;
  final int overallRating;
  final String firstName;
  final String lastName;
  final String? commonName;
  final String birthdate;
  final int height;
  final int skillMoves;
  final int weakFootAbility;
  final int preferredFoot;
  final String leagueName;
  final int weight;
  final String avatarUrl;
  final String shieldUrl;
  final List<AlternatePosition> alternatePositions;
  final List<PlayerAbility> playerAbilities;
  final String gender;
  final Nationality nationality;
  final Team team;
  final Position position;
  final Stats stats;

  PlayerModel({
    required this.id,
    required this.rank,
    required this.overallRating,
    required this.firstName,
    required this.lastName,
    this.commonName,
    required this.birthdate,
    required this.height,
    required this.skillMoves,
    required this.weakFootAbility,
    required this.preferredFoot,
    required this.leagueName,
    required this.weight,
    required this.avatarUrl,
    required this.shieldUrl,
    required this.alternatePositions,
    required this.playerAbilities,
    required this.gender,
    required this.nationality,
    required this.team,
    required this.position,
    required this.stats,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id'],
      rank: json['rank'],
      overallRating: json['overallRating'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      commonName: json['commonName'],
      birthdate: json['birthdate'],
      height: json['height'],
      skillMoves: json['skillMoves'],
      weakFootAbility: json['weakFootAbility'],
      preferredFoot: json['preferredFoot'],
      leagueName: json['leagueName'],
      weight: json['weight'],
      avatarUrl: json['avatarUrl'],
      shieldUrl: json['shieldUrl'],
      alternatePositions: (json['alternatePositions'] as List<dynamic>?)
          ?.map((pos) => AlternatePosition.fromJson(pos))
          .toList() ??
          [],
      playerAbilities: (json['playerAbilities'] as List<dynamic>?)
          ?.map((ability) => PlayerAbility.fromJson(ability))
          .toList() ??
          [],
      gender: json['gender']['label'],
      nationality: Nationality.fromJson(json['nationality']),
      team: Team.fromJson(json['team']),
      position: Position.fromJson(json['position']),
      stats: Stats.fromJson(json['stats']),
    );
  }
}

class AlternatePosition {
  final String id;
  final String label;
  final String shortLabel;

  AlternatePosition({
    required this.id,
    required this.label,
    required this.shortLabel,
  });

  factory AlternatePosition.fromJson(Map<String, dynamic> json) {
    return AlternatePosition(
      id: json['id'],
      label: json['label'],
      shortLabel: json['shortLabel'],
    );
  }
}

class PlayerAbility {
  final String id;
  final String label;
  final String description;
  final String imageUrl;
  final String type;

  PlayerAbility({
    required this.id,
    required this.label,
    required this.description,
    required this.imageUrl,
    required this.type,
  });

  factory PlayerAbility.fromJson(Map<String, dynamic> json) {
    return PlayerAbility(
      id: json['id'],
      label: json['label'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      type: json['type']['label'],
    );
  }
}

class Nationality {
  final String label;
  final String imageUrl;

  Nationality({required this.label, required this.imageUrl});

  factory Nationality.fromJson(Map<String, dynamic> json) {
    return Nationality(
      label: json['label'],
      imageUrl: json['imageUrl'],
    );
  }
}

class Team {
  final String label;
  final String imageUrl;

  Team({required this.label, required this.imageUrl});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      label: json['label'],
      imageUrl: json['imageUrl'],
    );
  }
}

class Position {
  final String label;

  Position({required this.label});

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(label: json['label']);
  }
}

class Stats {
  final int acceleration;
  final int agility;
  final int jumping;
  final int stamina;
  final int strength;
  final int aggression;
  final int balance;
  final int ballControl;
  final int composure;
  final int crossing;
  final int curve;
  final int def;
  final int defensiveAwareness;
  final int dri;
  final int dribbling;
  final int finishing;
  final int freeKickAccuracy;
  final int gkDiving;
  final int gkHandling;
  final int gkKicking;
  final int gkPositioning;
  final int gkReflexes;
  final int headingAccuracy;
  final int interceptions;
  final int longPassing;
  final int longShots;
  final int pac;
  final int pas;
  final int penalties;
  final int phy;
  final int positioning;
  final int reactions;
  final int sho;
  final int shortPassing;
  final int shotPower;
  final int slidingTackle;
  final int sprintSpeed;
  final int standingTackle;
  final int vision;
  final int volleys;

  Stats({
    required this.acceleration,
    required this.agility,
    required this.jumping,
    required this.stamina,
    required this.strength,
    required this.aggression,
    required this.balance,
    required this.ballControl,
    required this.composure,
    required this.crossing,
    required this.curve,
    required this.def,
    required this.defensiveAwareness,
    required this.dri,
    required this.dribbling,
    required this.finishing,
    required this.freeKickAccuracy,
    required this.gkDiving,
    required this.gkHandling,
    required this.gkKicking,
    required this.gkPositioning,
    required this.gkReflexes,
    required this.headingAccuracy,
    required this.interceptions,
    required this.longPassing,
    required this.longShots,
    required this.pac,
    required this.pas,
    required this.penalties,
    required this.phy,
    required this.positioning,
    required this.reactions,
    required this.sho,
    required this.shortPassing,
    required this.shotPower,
    required this.slidingTackle,
    required this.sprintSpeed,
    required this.standingTackle,
    required this.vision,
    required this.volleys,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      acceleration: json['acceleration']['value'],
      agility: json['agility']['value'],
      jumping: json['jumping']['value'],
      stamina: json['stamina']['value'],
      strength: json['strength']['value'],
      aggression: json['aggression']['value'],
      balance: json['balance']['value'],
      ballControl: json['ballControl']['value'],
      composure: json['composure']['value'],
      crossing: json['crossing']['value'],
      curve: json['curve']['value'],
      def: json['def']['value'],
      defensiveAwareness: json['defensiveAwareness']['value'],
      dri: json['dri']['value'],
      dribbling: json['dribbling']['value'],
      finishing: json['finishing']['value'],
      freeKickAccuracy: json['freeKickAccuracy']['value'],
      gkDiving: json['gkDiving']['value'],
      gkHandling: json['gkHandling']['value'],
      gkKicking: json['gkKicking']['value'],
      gkPositioning: json['gkPositioning']['value'],
      gkReflexes: json['gkReflexes']['value'],
      headingAccuracy: json['headingAccuracy']['value'],
      interceptions: json['interceptions']['value'],
      longPassing: json['longPassing']['value'],
      longShots: json['longShots']['value'],
      pac: json['pac']['value'],
      pas: json['pas']['value'],
      penalties: json['penalties']['value'],
      phy: json['phy']['value'],
      positioning: json['positioning']['value'],
      reactions: json['reactions']['value'],
      sho: json['sho']['value'],
      shortPassing: json['shortPassing']['value'],
      shotPower: json['shotPower']['value'],
      slidingTackle: json['slidingTackle']['value'],
      sprintSpeed: json['sprintSpeed']['value'],
      standingTackle: json['standingTackle']['value'],
      vision: json['vision']['value'],
      volleys: json['volleys']['value'],
    );
  }
}
