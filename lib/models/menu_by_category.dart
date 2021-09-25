
import 'datum.dart';

class MenuByCategory {
  MenuByCategory({
    this.auth,
    this.data,
  });

  Auth? auth;
  List<List<Datum>>? data;

  factory MenuByCategory.fromJson(Map<String, dynamic> json) => MenuByCategory(
    auth: Auth.fromJson(json["auth"]),
    data: json["data"] == null ? null : List<List<Datum>>.from(json["data"].map((x) => List<Datum>.from(x.map((x) => Datum.fromJson(x))))),
  );

  Map<String, dynamic> toJson() => {
    "auth": auth!.toJson(),
    "data": data== null ? null: List<dynamic>.from(data!.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
  };
}

class Auth {
  Auth({
    this.id,
    this.name,
    this.image,
    this.email,
    this.verifyToken,
    this.status,
    this.googleId,
    this.facebookId,
    this.gitlabId,
    this.dob,
    this.age,
    this.mobile,
    this.braintreeId,
    this.code,
    this.stripeId,
    this.cardBrand,
    this.cardLastFour,
    this.trialEndsAt,
    this.isAdmin,
    this.isAssistant,
    this.isBlocked,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  dynamic image;
  String? email;
  dynamic verifyToken;
  dynamic status;
  dynamic googleId;
  dynamic facebookId;
  dynamic gitlabId;
  dynamic dob;
  dynamic age;
  dynamic mobile;
  dynamic braintreeId;
  dynamic code;
  dynamic stripeId;
  dynamic cardBrand;
  dynamic cardLastFour;
  dynamic trialEndsAt;
  dynamic isAdmin;
  dynamic isAssistant;
  dynamic isBlocked;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Auth.fromJson(Map<String, dynamic> json) => Auth(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    email: json["email"],
    verifyToken: json["verifyToken"],
    status: json["status"],
    googleId: json["google_id"],
    facebookId: json["facebook_id"],
    gitlabId: json["gitlab_id"],
    dob: json["dob"],
    age: json["age"],
    mobile: json["mobile"],
    braintreeId: json["braintree_id"],
    code: json["code"],
    stripeId: json["stripe_id"],
    cardBrand: json["card_brand"],
    cardLastFour: json["card_last_four"],
    trialEndsAt: json["trial_ends_at"],
    isAdmin: json["is_admin"],
    isAssistant: json["is_assistant"],
    isBlocked: json["is_blocked"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "email": email,
    "verifyToken": verifyToken,
    "status": status,
    "google_id": googleId,
    "facebook_id": facebookId,
    "gitlab_id": gitlabId,
    "dob": dob,
    "age": age,
    "mobile": mobile,
    "braintree_id": braintreeId,
    "code": code,
    "stripe_id": stripeId,
    "card_brand": cardBrand,
    "card_last_four": cardLastFour,
    "trial_ends_at": trialEndsAt,
    "is_admin": isAdmin,
    "is_assistant": isAssistant,
    "is_blocked": isBlocked,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}




