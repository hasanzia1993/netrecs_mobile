class Comment {
  Comment({
    this.id,
    this.name,
    this.email,
    this.movieId,
    this.tvSeriesId,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.subcomments,
  });

  int? id;
  String? name;
  String? email;
  dynamic movieId;
  dynamic tvSeriesId;
  String? comment;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<SubComment>? subcomments;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    movieId: json["movie_id"],
    tvSeriesId: json["tv_series_id"],
    comment: json["comment"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    subcomments: List<SubComment>.from(json["subcomments"].map((x) => SubComment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "movie_id": movieId,
    "tv_series_id": tvSeriesId,
    "comment": comment,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "subcomments": List<dynamic>.from(subcomments!.map((x) => x.toJson())),
  };
}

class SubComment {
  SubComment({
    this.id,
    this.userId,
    this.commentId,
    this.reply,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  int? commentId;
  String? reply;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory SubComment.fromJson(Map<String, dynamic> json) => SubComment(
    id: json["id"],
    userId: json["user_id"],
    commentId: json["comment_id"],
    reply: json["reply"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "comment_id": commentId,
    "reply": reply,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}