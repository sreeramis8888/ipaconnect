import 'package:json_annotation/json_annotation.dart';

part 'chat_model.g.dart';

@JsonSerializable()
class Attachment {
  final String? url;
  final String? type;

  Attachment({this.url, this.type});

  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(json);

  Map<String, dynamic> toJson() => _$AttachmentToJson(this);
}

@JsonSerializable()
class MessageModel {
  @JsonKey(name: '_id')
  final String? id;

  final String? conversation;
  final String? sender;
  final String? message;
  final List<Attachment>? attachments;
  final String? status;

  @JsonKey(name: 'seen_by')
  final List<String>? seenBy;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  MessageModel({
    this.id,
    this.conversation,
    this.sender,
    this.message,
    this.attachments,
    this.status,
    this.seenBy,
    this.createdAt,
    this.updatedAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}

extension MessageModelCopyWith on MessageModel {
  MessageModel copyWith({
    String? id,
    String? conversation,
    String? sender,
    String? message,
    List<Attachment>? attachments,
    String? status,
    List<String>? seenBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MessageModel(
      id: id ?? this.id,
      conversation: conversation ?? this.conversation,
      sender: sender ?? this.sender,
      message: message ?? this.message,
      attachments: attachments ?? this.attachments,
      status: status ?? this.status,
      seenBy: seenBy ?? this.seenBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable()
class ConversationModel {
  @JsonKey(name: '_id')
  final String? id;

  final String? name;

  @JsonKey(name: 'is_group')
  final bool? isGroup;

  final List<String>? members;
  final List<String>? admins;

  @JsonKey(name: 'last_message')
  final String? lastMessage;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  ConversationModel({
    this.id,
    this.name,
    this.isGroup,
    this.members,
    this.admins,
    this.lastMessage,
    this.createdAt,
    this.updatedAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConversationModelToJson(this);
}
