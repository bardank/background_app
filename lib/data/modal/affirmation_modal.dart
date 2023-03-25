import 'package:hive/hive.dart';

part 'affirmation_modal.g.dart';

class AffirmationData {
  AffirmationData({
    required this.fetchAffirmations,
  });

  List<Affirmation> fetchAffirmations;

  factory AffirmationData.fromJson(Map<String, dynamic> json) =>
      AffirmationData(
        fetchAffirmations: List<Affirmation>.from(
            json["fetchAffirmations"].map((x) => Affirmation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "fetchAffirmations":
            List<dynamic>.from(fetchAffirmations.map((x) => x.toJson())),
      };
}

@HiveType(typeId: 13)
class LikedAffirmation {
  LikedAffirmation({
    this.id,
    this.createdAt,
    this.affirmation,
    this.updatedAt,
  });

  @HiveField(0)
  String? id;
  @HiveField(1)
  DateTime? createdAt;
  @HiveField(2)
  Affirmation? affirmation;
  @HiveField(3)
  DateTime? updatedAt;

  factory LikedAffirmation.fromJson(Map<String, dynamic> json) =>
      LikedAffirmation(
        id: json["_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        affirmation: Affirmation.fromJson(json["affirmation"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "createdAt": createdAt?.toIso8601String(),
        "affirmation": affirmation!.toJson(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class CreateClientAffirmation {
  CreateClientAffirmation({
    required this.createClientAffirmationResponse,
  });

  CreateClientAffirmationResponse createClientAffirmationResponse;

  factory CreateClientAffirmation.fromJson(Map<String, dynamic> json) =>
      CreateClientAffirmation(
        createClientAffirmationResponse:
            CreateClientAffirmationResponse.fromJson(
                json["createClientAffirmation"]),
      );

  Map<String, dynamic> toJson() => {
        "createClientAffirmation": createClientAffirmationResponse.toJson(),
      };
}

class FetchMyAffirmations {
  FetchMyAffirmations({
    required this.affirmations,
  });

  List<Affirmation> affirmations;

  factory FetchMyAffirmations.fromJson(Map<String, dynamic> json) =>
      FetchMyAffirmations(
        affirmations: List<Affirmation>.from(
            json["getMyAffirmations"].map((x) => Affirmation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "getMyAffirmations":
            List<dynamic>.from(affirmations.map((x) => x.toJson())),
      };
}

class CreateClientAffirmationResponse {
  CreateClientAffirmationResponse({
    this.affirmation,
    required this.message,
    required this.success,
  });

  Affirmation? affirmation;
  String message;
  bool success;

  factory CreateClientAffirmationResponse.fromJson(Map<String, dynamic> json) =>
      CreateClientAffirmationResponse(
        affirmation: json["affirmation"] != null
            ? Affirmation.fromJson(json["affirmation"])
            : null,
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "affirmation": affirmation != null ? affirmation!.toJson() : null,
        "message": message,
        "success": success,
      };
}

@HiveType(typeId: 10)
class Affirmation {
  Affirmation({
    required this.id,
    required this.caption,
    required this.createdAt,
    this.subTitle,
    required this.type,
    this.youtubeAudio,
    this.youtubeVideo,
  });

  @HiveField(0)
  String id;
  @HiveField(1)
  String caption;
  @HiveField(2)
  DateTime createdAt;
  @HiveField(3)
  String? subTitle;
  @HiveField(4)
  String type;
  @HiveField(5)
  String? youtubeAudio;
  @HiveField(6)
  String? youtubeVideo;

  factory Affirmation.fromJson(Map<String, dynamic> json) => Affirmation(
        id: json["_id"],
        caption: json["caption"],
        createdAt: DateTime.parse(json["createdAt"]),
        subTitle: json["subTitle"],
        type: json["type"],
        youtubeAudio: json["youtubeAudio"],
        youtubeVideo: json["youtubeVideo"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "caption": caption,
        "createdAt": createdAt.toIso8601String(),
        "subTitle": subTitle,
        "type": type,
        "youtubeAudio": youtubeAudio,
        "youtubeVideo": youtubeVideo,
      };
}
