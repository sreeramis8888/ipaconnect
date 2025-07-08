import 'package:json_annotation/json_annotation.dart';

part 'feed_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FeedModel {
  @JsonKey(name: '_id')
  String? id;
  String? type;
  String? media;
  String? link;
  String? content;
  Author? user;
  @JsonKey(name: 'like')
  List<String>? likes;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  @JsonKey(name: 'comment')
  List<Comment>? comments;

  FeedModel({
    this.id,
    this.type,
    this.media,
    this.link,
    this.content,
    this.user,
    this.likes,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.comments,
  });

  factory FeedModel.fromJson(Map<String, dynamic> json) =>
      _$FeedModelFromJson(json);
  Map<String, dynamic> toJson() => _$FeedModelToJson(this);
}

@JsonSerializable()
class Author {
  @JsonKey(name: '_id')
  final String? id;
  final String? name;
  final String? image;
  final String? proffession;

  Author( {
    this.id,
    this.name,this.proffession,
  this.image,
  });

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);
  Map<String, dynamic> toJson() => _$AuthorToJson(this);
}

@JsonSerializable()
class FeedUser {
  @JsonKey(name: '_id')
  String? id;
  String? image;
  String? name;

  FeedUser({this.id, this.image, this.name});

  factory FeedUser.fromJson(Map<String, dynamic> json) =>
      _$FeedUserFromJson(json);
  Map<String, dynamic> toJson() => _$FeedUserToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Comment {
  FeedUser? user;
  String? comment;

  Comment({this.user, this.comment});

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
