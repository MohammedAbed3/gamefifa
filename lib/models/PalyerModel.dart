import 'dart:convert';

class PlayerModel {
  List<Items>? items;
  int? totalItems;


  PlayerModel.fromJson(Map<String, dynamic> json) {
    // التأكد من أن 'items' ليس فارغًا وأنه يحتوي على قيمة من النوع المناسب
    if (json['items'] != null) {
      items = <Items>[];

      // إذا كانت 'items' نصًا يحتوي على JSON مشفّر، نقوم بتحويله أولاً إلى خريطة
      if (json['items'] is String) {
        var decodedItems = jsonDecode(json['items']);
        // تأكد من أن البيانات المستلمة هي قائمة
        if (decodedItems is List) {
          decodedItems.forEach((v) {
            items!.add(Items.fromJson(v));
          });
        } else {
          print("البيانات غير صحيحة في 'items'");
        }
      } else if (json['items'] is List) {
        // إذا كانت 'items' بالفعل قائمة
        json['items'].forEach((v) {
          items!.add(Items.fromJson(v));
        });
      } else {
        print("البيانات في 'items' ليست قائمة أو نص");
      }
    }

    // التعامل مع باقي الحقول
    totalItems = json['totalItems'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['totalItems'] = this.totalItems;
    return data;
  }
}

class Items {
  int? id;
  int? rank;
  int? overallRating;
  String? firstName;
  String? lastName;
  String? commonName;
  String? birthdate;
  int? height;
  int? skillMoves;
  int? weakFootAbility;
  int? preferredFoot;
  String? leagueName;
  int? weight;
  String? avatarUrl;
  String? shieldUrl;
  List<AlternatePositions>? alternatePositions;
  List<PlayerAbilities>? playerAbilities;
  Gender? gender;
  Nationality? nationality;
  Team? team;
  Position? position;
  Stats? stats;

  Items(
      {this.id,
      this.rank,
      this.overallRating,
      this.firstName,
      this.lastName,
      this.commonName,
      this.birthdate,
      this.height,
      this.skillMoves,
      this.weakFootAbility,
      this.preferredFoot,
      this.leagueName,
      this.weight,
      this.avatarUrl,
      this.shieldUrl,
      this.alternatePositions,
      this.playerAbilities,
      this.gender,
      this.nationality,
      this.team,
      this.position,
      this.stats});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rank = json['rank'];
    overallRating = json['overallRating'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    commonName = json['commonName'];
    birthdate = json['birthdate'];
    height = json['height'];
    skillMoves = json['skillMoves'];
    weakFootAbility = json['weakFootAbility'];
    preferredFoot = json['preferredFoot'];
    leagueName = json['leagueName'];
    weight = json['weight'];
    avatarUrl = json['avatarUrl'];
    shieldUrl = json['shieldUrl'];
    if (json['alternatePositions'] != null) {
      alternatePositions = <AlternatePositions>[];
      json['alternatePositions'].forEach((v) {
        alternatePositions!.add(new AlternatePositions.fromJson(v));
      });
    }
    if (json['playerAbilities'] != null) {
      playerAbilities = <PlayerAbilities>[];
      json['playerAbilities'].forEach((v) {
        playerAbilities!.add(new PlayerAbilities.fromJson(v));
      });
    }
    gender =
        json['gender'] != null ? new Gender.fromJson(json['gender']) : null;
    nationality = json['nationality'] != null
        ? new Nationality.fromJson(json['nationality'])
        : null;
    team = json['team'] != null ? new Team.fromJson(json['team']) : null;
    position = json['position'] != null
        ? new Position.fromJson(json['position'])
        : null;
    stats = json['stats'] != null ? new Stats.fromJson(json['stats']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rank'] = this.rank;
    data['overallRating'] = this.overallRating;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['commonName'] = this.commonName;
    data['birthdate'] = this.birthdate;
    data['height'] = this.height;
    data['skillMoves'] = this.skillMoves;
    data['weakFootAbility'] = this.weakFootAbility;
    data['preferredFoot'] = this.preferredFoot;
    data['leagueName'] = this.leagueName;
    data['weight'] = this.weight;
    data['avatarUrl'] = this.avatarUrl;
    data['shieldUrl'] = this.shieldUrl;
    if (this.alternatePositions != null) {
      data['alternatePositions'] =
          this.alternatePositions!.map((v) => v.toJson()).toList();
    }
    if (this.playerAbilities != null) {
      data['playerAbilities'] =
          this.playerAbilities!.map((v) => v.toJson()).toList();
    }
    if (this.gender != null) {
      data['gender'] = this.gender!.toJson();
    }
    if (this.nationality != null) {
      data['nationality'] = this.nationality!.toJson();
    }
    if (this.team != null) {
      data['team'] = this.team!.toJson();
    }
    if (this.position != null) {
      data['position'] = this.position!.toJson();
    }
    if (this.stats != null) {
      data['stats'] = this.stats!.toJson();
    }
    return data;
  }
}

class AlternatePositions {
  String? id;
  String? label;
  String? shortLabel;

  AlternatePositions({this.id, this.label, this.shortLabel});

  AlternatePositions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    shortLabel = json['shortLabel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    data['shortLabel'] = this.shortLabel;
    return data;
  }
}

class PlayerAbilities {
  String? id;
  String? label;
  String? description;
  String? imageUrl;
  Type? type;

  PlayerAbilities(
      {this.id, this.label, this.description, this.imageUrl, this.type});

  PlayerAbilities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    description = json['description'];
    imageUrl = json['imageUrl'];
    type = json['type'] != null ? new Type.fromJson(json['type']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    data['description'] = this.description;
    data['imageUrl'] = this.imageUrl;
    if (this.type != null) {
      data['type'] = this.type!.toJson();
    }
    return data;
  }
}

class Type {
  String? id;
  String? label;

  Type({this.id, this.label});

  Type.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    return data;
  }
}

class Gender {
  int? id;
  String? label;

  Gender({this.id, this.label});

  Gender.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    return data;
  }
}

class Nationality {
  int? id;
  String? label;
  String? imageUrl;

  Nationality({this.id, this.label, this.imageUrl});

  Nationality.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}

class Team {
  int? id;
  String? label;
  String? imageUrl;
  bool? isPopular;

  Team({this.id, this.label, this.imageUrl, this.isPopular});

  Team.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    imageUrl = json['imageUrl'];
    isPopular = json['isPopular'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    data['imageUrl'] = this.imageUrl;
    data['isPopular'] = this.isPopular;
    return data;
  }
}

class Position {
  String? id;
  String? shortLabel;
  String? label;
  PositionType? positionType;

  Position({this.id, this.shortLabel, this.label, this.positionType});

  Position.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shortLabel = json['shortLabel'];
    label = json['label'];
    positionType = json['positionType'] != null
        ? new PositionType.fromJson(json['positionType'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shortLabel'] = this.shortLabel;
    data['label'] = this.label;
    if (this.positionType != null) {
      data['positionType'] = this.positionType!.toJson();
    }
    return data;
  }
}

class PositionType {
  String? id;
  String? name;

  PositionType({this.id, this.name});

  PositionType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Stats {
  Acceleration? acceleration;
  Acceleration? agility;
  Acceleration? jumping;
  Acceleration? stamina;
  Acceleration? strength;
  Acceleration? aggression;
  Acceleration? balance;
  Acceleration? ballControl;
  Acceleration? composure;
  Acceleration? crossing;
  Acceleration? curve;
  Acceleration? def;
  Acceleration? defensiveAwareness;
  Acceleration? dri;
  Acceleration? dribbling;
  Acceleration? finishing;
  Acceleration? freeKickAccuracy;
  Acceleration? gkDiving;
  Acceleration? gkHandling;
  Acceleration? gkKicking;
  Acceleration? gkPositioning;
  Acceleration? gkReflexes;
  Acceleration? headingAccuracy;
  Acceleration? interceptions;
  Acceleration? longPassing;
  Acceleration? longShots;
  Acceleration? pac;
  Acceleration? pas;
  Acceleration? penalties;
  Acceleration? phy;
  Acceleration? positioning;
  Acceleration? reactions;
  Acceleration? sho;
  Acceleration? shortPassing;
  Acceleration? shotPower;
  Acceleration? slidingTackle;
  Acceleration? sprintSpeed;
  Acceleration? standingTackle;
  Acceleration? vision;
  Acceleration? volleys;

  Stats(
      {this.acceleration,
      this.agility,
      this.jumping,
      this.stamina,
      this.strength,
      this.aggression,
      this.balance,
      this.ballControl,
      this.composure,
      this.crossing,
      this.curve,
      this.def,
      this.defensiveAwareness,
      this.dri,
      this.dribbling,
      this.finishing,
      this.freeKickAccuracy,
      this.gkDiving,
      this.gkHandling,
      this.gkKicking,
      this.gkPositioning,
      this.gkReflexes,
      this.headingAccuracy,
      this.interceptions,
      this.longPassing,
      this.longShots,
      this.pac,
      this.pas,
      this.penalties,
      this.phy,
      this.positioning,
      this.reactions,
      this.sho,
      this.shortPassing,
      this.shotPower,
      this.slidingTackle,
      this.sprintSpeed,
      this.standingTackle,
      this.vision,
      this.volleys});

  Stats.fromJson(Map<String, dynamic> json) {
    acceleration = json['acceleration'] != null
        ? new Acceleration.fromJson(json['acceleration'])
        : null;
    agility = json['agility'] != null
        ? new Acceleration.fromJson(json['agility'])
        : null;
    jumping = json['jumping'] != null
        ? new Acceleration.fromJson(json['jumping'])
        : null;
    stamina = json['stamina'] != null
        ? new Acceleration.fromJson(json['stamina'])
        : null;
    strength = json['strength'] != null
        ? new Acceleration.fromJson(json['strength'])
        : null;
    aggression = json['aggression'] != null
        ? new Acceleration.fromJson(json['aggression'])
        : null;
    balance = json['balance'] != null
        ? new Acceleration.fromJson(json['balance'])
        : null;
    ballControl = json['ballControl'] != null
        ? new Acceleration.fromJson(json['ballControl'])
        : null;
    composure = json['composure'] != null
        ? new Acceleration.fromJson(json['composure'])
        : null;
    crossing = json['crossing'] != null
        ? new Acceleration.fromJson(json['crossing'])
        : null;
    curve =
        json['curve'] != null ? new Acceleration.fromJson(json['curve']) : null;
    def = json['def'] != null ? new Acceleration.fromJson(json['def']) : null;
    defensiveAwareness = json['defensiveAwareness'] != null
        ? new Acceleration.fromJson(json['defensiveAwareness'])
        : null;
    dri = json['dri'] != null ? new Acceleration.fromJson(json['dri']) : null;
    dribbling = json['dribbling'] != null
        ? new Acceleration.fromJson(json['dribbling'])
        : null;
    finishing = json['finishing'] != null
        ? new Acceleration.fromJson(json['finishing'])
        : null;
    freeKickAccuracy = json['freeKickAccuracy'] != null
        ? new Acceleration.fromJson(json['freeKickAccuracy'])
        : null;
    gkDiving = json['gkDiving'] != null
        ? new Acceleration.fromJson(json['gkDiving'])
        : null;
    gkHandling = json['gkHandling'] != null
        ? new Acceleration.fromJson(json['gkHandling'])
        : null;
    gkKicking = json['gkKicking'] != null
        ? new Acceleration.fromJson(json['gkKicking'])
        : null;
    gkPositioning = json['gkPositioning'] != null
        ? new Acceleration.fromJson(json['gkPositioning'])
        : null;
    gkReflexes = json['gkReflexes'] != null
        ? new Acceleration.fromJson(json['gkReflexes'])
        : null;
    headingAccuracy = json['headingAccuracy'] != null
        ? new Acceleration.fromJson(json['headingAccuracy'])
        : null;
    interceptions = json['interceptions'] != null
        ? new Acceleration.fromJson(json['interceptions'])
        : null;
    longPassing = json['longPassing'] != null
        ? new Acceleration.fromJson(json['longPassing'])
        : null;
    longShots = json['longShots'] != null
        ? new Acceleration.fromJson(json['longShots'])
        : null;
    pac = json['pac'] != null ? new Acceleration.fromJson(json['pac']) : null;
    pas = json['pas'] != null ? new Acceleration.fromJson(json['pas']) : null;
    penalties = json['penalties'] != null
        ? new Acceleration.fromJson(json['penalties'])
        : null;
    phy = json['phy'] != null ? new Acceleration.fromJson(json['phy']) : null;
    positioning = json['positioning'] != null
        ? new Acceleration.fromJson(json['positioning'])
        : null;
    reactions = json['reactions'] != null
        ? new Acceleration.fromJson(json['reactions'])
        : null;
    sho = json['sho'] != null ? new Acceleration.fromJson(json['sho']) : null;
    shortPassing = json['shortPassing'] != null
        ? new Acceleration.fromJson(json['shortPassing'])
        : null;
    shotPower = json['shotPower'] != null
        ? new Acceleration.fromJson(json['shotPower'])
        : null;
    slidingTackle = json['slidingTackle'] != null
        ? new Acceleration.fromJson(json['slidingTackle'])
        : null;
    sprintSpeed = json['sprintSpeed'] != null
        ? new Acceleration.fromJson(json['sprintSpeed'])
        : null;
    standingTackle = json['standingTackle'] != null
        ? new Acceleration.fromJson(json['standingTackle'])
        : null;
    vision = json['vision'] != null
        ? new Acceleration.fromJson(json['vision'])
        : null;
    volleys = json['volleys'] != null
        ? new Acceleration.fromJson(json['volleys'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.acceleration != null) {
      data['acceleration'] = this.acceleration!.toJson();
    }
    if (this.agility != null) {
      data['agility'] = this.agility!.toJson();
    }
    if (this.jumping != null) {
      data['jumping'] = this.jumping!.toJson();
    }
    if (this.stamina != null) {
      data['stamina'] = this.stamina!.toJson();
    }
    if (this.strength != null) {
      data['strength'] = this.strength!.toJson();
    }
    if (this.aggression != null) {
      data['aggression'] = this.aggression!.toJson();
    }
    if (this.balance != null) {
      data['balance'] = this.balance!.toJson();
    }
    if (this.ballControl != null) {
      data['ballControl'] = this.ballControl!.toJson();
    }
    if (this.composure != null) {
      data['composure'] = this.composure!.toJson();
    }
    if (this.crossing != null) {
      data['crossing'] = this.crossing!.toJson();
    }
    if (this.curve != null) {
      data['curve'] = this.curve!.toJson();
    }
    if (this.def != null) {
      data['def'] = this.def!.toJson();
    }
    if (this.defensiveAwareness != null) {
      data['defensiveAwareness'] = this.defensiveAwareness!.toJson();
    }
    if (this.dri != null) {
      data['dri'] = this.dri!.toJson();
    }
    if (this.dribbling != null) {
      data['dribbling'] = this.dribbling!.toJson();
    }
    if (this.finishing != null) {
      data['finishing'] = this.finishing!.toJson();
    }
    if (this.freeKickAccuracy != null) {
      data['freeKickAccuracy'] = this.freeKickAccuracy!.toJson();
    }
    if (this.gkDiving != null) {
      data['gkDiving'] = this.gkDiving!.toJson();
    }
    if (this.gkHandling != null) {
      data['gkHandling'] = this.gkHandling!.toJson();
    }
    if (this.gkKicking != null) {
      data['gkKicking'] = this.gkKicking!.toJson();
    }
    if (this.gkPositioning != null) {
      data['gkPositioning'] = this.gkPositioning!.toJson();
    }
    if (this.gkReflexes != null) {
      data['gkReflexes'] = this.gkReflexes!.toJson();
    }
    if (this.headingAccuracy != null) {
      data['headingAccuracy'] = this.headingAccuracy!.toJson();
    }
    if (this.interceptions != null) {
      data['interceptions'] = this.interceptions!.toJson();
    }
    if (this.longPassing != null) {
      data['longPassing'] = this.longPassing!.toJson();
    }
    if (this.longShots != null) {
      data['longShots'] = this.longShots!.toJson();
    }
    if (this.pac != null) {
      data['pac'] = this.pac!.toJson();
    }
    if (this.pas != null) {
      data['pas'] = this.pas!.toJson();
    }
    if (this.penalties != null) {
      data['penalties'] = this.penalties!.toJson();
    }
    if (this.phy != null) {
      data['phy'] = this.phy!.toJson();
    }
    if (this.positioning != null) {
      data['positioning'] = this.positioning!.toJson();
    }
    if (this.reactions != null) {
      data['reactions'] = this.reactions!.toJson();
    }
    if (this.sho != null) {
      data['sho'] = this.sho!.toJson();
    }
    if (this.shortPassing != null) {
      data['shortPassing'] = this.shortPassing!.toJson();
    }
    if (this.shotPower != null) {
      data['shotPower'] = this.shotPower!.toJson();
    }
    if (this.slidingTackle != null) {
      data['slidingTackle'] = this.slidingTackle!.toJson();
    }
    if (this.sprintSpeed != null) {
      data['sprintSpeed'] = this.sprintSpeed!.toJson();
    }
    if (this.standingTackle != null) {
      data['standingTackle'] = this.standingTackle!.toJson();
    }
    if (this.vision != null) {
      data['vision'] = this.vision!.toJson();
    }
    if (this.volleys != null) {
      data['volleys'] = this.volleys!.toJson();
    }
    return data;
  }
}

class Acceleration {
  int? value;
  int? diff;

  Acceleration({this.value, this.diff});

  Acceleration.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    diff = json['diff'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['diff'] = this.diff;
    return data;
  }
}
