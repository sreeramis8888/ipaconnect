// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {
  String? get name;
  String? get uid;
  @JsonKey(name: 'member_id')
  String? get memberId;
  String? get email;
  String? get image;
  String? get phone;
  String? get fcm;
  String? get otp;
  @JsonKey(name: 'proffession')
  String? get profession;
  String? get location;
  String? get password;
  String? get status;
  @JsonKey(name: 'is_ipa_member')
  bool? get isIpaMember;
  @JsonKey(name: 'is_admin')
  bool? get isAdmin;
  String? get hierarchy; // ObjectId
  String? get role; // ObjectId
  @JsonKey(name: 'last_seen')
  DateTime? get lastSeen;
  bool? get online;
  @JsonKey(name: 'reject_reason')
  String? get rejectReason;
  String? get bio;
  @JsonKey(name: 'social_media')
  List<SocialMedia>? get socialMedia;
  @JsonKey(name: 'createdAt')
  DateTime? get createdAt;
  @JsonKey(name: 'updatedAt')
  DateTime? get updatedAt;
  @JsonKey(name: '_id')
  String? get id;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<UserModel> get copyWith =>
      _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserModel &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.fcm, fcm) || other.fcm == fcm) &&
            (identical(other.otp, otp) || other.otp == otp) &&
            (identical(other.profession, profession) ||
                other.profession == profession) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isIpaMember, isIpaMember) ||
                other.isIpaMember == isIpaMember) &&
            (identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin) &&
            (identical(other.hierarchy, hierarchy) ||
                other.hierarchy == hierarchy) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.lastSeen, lastSeen) ||
                other.lastSeen == lastSeen) &&
            (identical(other.online, online) || other.online == online) &&
            (identical(other.rejectReason, rejectReason) ||
                other.rejectReason == rejectReason) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            const DeepCollectionEquality()
                .equals(other.socialMedia, socialMedia) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        name,
        uid,
        memberId,
        email,
        image,
        phone,
        fcm,
        otp,
        profession,
        location,
        password,
        status,
        isIpaMember,
        isAdmin,
        hierarchy,
        role,
        lastSeen,
        online,
        rejectReason,
        bio,
        const DeepCollectionEquality().hash(socialMedia),
        createdAt,
        updatedAt,
        id
      ]);

  @override
  String toString() {
    return 'UserModel(name: $name, uid: $uid, memberId: $memberId, email: $email, image: $image, phone: $phone, fcm: $fcm, otp: $otp, profession: $profession, location: $location, password: $password, status: $status, isIpaMember: $isIpaMember, isAdmin: $isAdmin, hierarchy: $hierarchy, role: $role, lastSeen: $lastSeen, online: $online, rejectReason: $rejectReason, bio: $bio, socialMedia: $socialMedia, createdAt: $createdAt, updatedAt: $updatedAt, id: $id)';
  }
}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) =
      _$UserModelCopyWithImpl;
  @useResult
  $Res call(
      {String? name,
      String? uid,
      @JsonKey(name: 'member_id') String? memberId,
      String? email,
      String? image,
      String? phone,
      String? fcm,
      String? otp,
      @JsonKey(name: 'proffession') String? profession,
      String? location,
      String? password,
      String? status,
      @JsonKey(name: 'is_ipa_member') bool? isIpaMember,
      @JsonKey(name: 'is_admin') bool? isAdmin,
      String? hierarchy,
      String? role,
      @JsonKey(name: 'last_seen') DateTime? lastSeen,
      bool? online,
      @JsonKey(name: 'reject_reason') String? rejectReason,
      String? bio,
      @JsonKey(name: 'social_media') List<SocialMedia>? socialMedia,
      @JsonKey(name: 'createdAt') DateTime? createdAt,
      @JsonKey(name: 'updatedAt') DateTime? updatedAt,
      @JsonKey(name: '_id') String? id});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res> implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? uid = freezed,
    Object? memberId = freezed,
    Object? email = freezed,
    Object? image = freezed,
    Object? phone = freezed,
    Object? fcm = freezed,
    Object? otp = freezed,
    Object? profession = freezed,
    Object? location = freezed,
    Object? password = freezed,
    Object? status = freezed,
    Object? isIpaMember = freezed,
    Object? isAdmin = freezed,
    Object? hierarchy = freezed,
    Object? role = freezed,
    Object? lastSeen = freezed,
    Object? online = freezed,
    Object? rejectReason = freezed,
    Object? bio = freezed,
    Object? socialMedia = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? id = freezed,
  }) {
    return _then(_self.copyWith(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      uid: freezed == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      memberId: freezed == memberId
          ? _self.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _self.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      fcm: freezed == fcm
          ? _self.fcm
          : fcm // ignore: cast_nullable_to_non_nullable
              as String?,
      otp: freezed == otp
          ? _self.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String?,
      profession: freezed == profession
          ? _self.profession
          : profession // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      isIpaMember: freezed == isIpaMember
          ? _self.isIpaMember
          : isIpaMember // ignore: cast_nullable_to_non_nullable
              as bool?,
      isAdmin: freezed == isAdmin
          ? _self.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool?,
      hierarchy: freezed == hierarchy
          ? _self.hierarchy
          : hierarchy // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      lastSeen: freezed == lastSeen
          ? _self.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      online: freezed == online
          ? _self.online
          : online // ignore: cast_nullable_to_non_nullable
              as bool?,
      rejectReason: freezed == rejectReason
          ? _self.rejectReason
          : rejectReason // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _self.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      socialMedia: freezed == socialMedia
          ? _self.socialMedia
          : socialMedia // ignore: cast_nullable_to_non_nullable
              as List<SocialMedia>?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _UserModel implements UserModel {
  _UserModel(
      {this.name,
      this.uid,
      @JsonKey(name: 'member_id') this.memberId,
      this.email,
      this.image,
      this.phone,
      this.fcm,
      this.otp,
      @JsonKey(name: 'proffession') this.profession,
      this.location,
      this.password,
      this.status,
      @JsonKey(name: 'is_ipa_member') this.isIpaMember,
      @JsonKey(name: 'is_admin') this.isAdmin,
      this.hierarchy,
      this.role,
      @JsonKey(name: 'last_seen') this.lastSeen,
      this.online,
      @JsonKey(name: 'reject_reason') this.rejectReason,
      this.bio,
      @JsonKey(name: 'social_media') final List<SocialMedia>? socialMedia,
      @JsonKey(name: 'createdAt') this.createdAt,
      @JsonKey(name: 'updatedAt') this.updatedAt,
      @JsonKey(name: '_id') this.id})
      : _socialMedia = socialMedia;
  factory _UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @override
  final String? name;
  @override
  final String? uid;
  @override
  @JsonKey(name: 'member_id')
  final String? memberId;
  @override
  final String? email;
  @override
  final String? image;
  @override
  final String? phone;
  @override
  final String? fcm;
  @override
  final String? otp;
  @override
  @JsonKey(name: 'proffession')
  final String? profession;
  @override
  final String? location;
  @override
  final String? password;
  @override
  final String? status;
  @override
  @JsonKey(name: 'is_ipa_member')
  final bool? isIpaMember;
  @override
  @JsonKey(name: 'is_admin')
  final bool? isAdmin;
  @override
  final String? hierarchy;
// ObjectId
  @override
  final String? role;
// ObjectId
  @override
  @JsonKey(name: 'last_seen')
  final DateTime? lastSeen;
  @override
  final bool? online;
  @override
  @JsonKey(name: 'reject_reason')
  final String? rejectReason;
  @override
  final String? bio;
  final List<SocialMedia>? _socialMedia;
  @override
  @JsonKey(name: 'social_media')
  List<SocialMedia>? get socialMedia {
    final value = _socialMedia;
    if (value == null) return null;
    if (_socialMedia is EqualUnmodifiableListView) return _socialMedia;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: '_id')
  final String? id;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserModelCopyWith<_UserModel> get copyWith =>
      __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserModel &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.fcm, fcm) || other.fcm == fcm) &&
            (identical(other.otp, otp) || other.otp == otp) &&
            (identical(other.profession, profession) ||
                other.profession == profession) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isIpaMember, isIpaMember) ||
                other.isIpaMember == isIpaMember) &&
            (identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin) &&
            (identical(other.hierarchy, hierarchy) ||
                other.hierarchy == hierarchy) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.lastSeen, lastSeen) ||
                other.lastSeen == lastSeen) &&
            (identical(other.online, online) || other.online == online) &&
            (identical(other.rejectReason, rejectReason) ||
                other.rejectReason == rejectReason) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            const DeepCollectionEquality()
                .equals(other._socialMedia, _socialMedia) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        name,
        uid,
        memberId,
        email,
        image,
        phone,
        fcm,
        otp,
        profession,
        location,
        password,
        status,
        isIpaMember,
        isAdmin,
        hierarchy,
        role,
        lastSeen,
        online,
        rejectReason,
        bio,
        const DeepCollectionEquality().hash(_socialMedia),
        createdAt,
        updatedAt,
        id
      ]);

  @override
  String toString() {
    return 'UserModel(name: $name, uid: $uid, memberId: $memberId, email: $email, image: $image, phone: $phone, fcm: $fcm, otp: $otp, profession: $profession, location: $location, password: $password, status: $status, isIpaMember: $isIpaMember, isAdmin: $isAdmin, hierarchy: $hierarchy, role: $role, lastSeen: $lastSeen, online: $online, rejectReason: $rejectReason, bio: $bio, socialMedia: $socialMedia, createdAt: $createdAt, updatedAt: $updatedAt, id: $id)';
  }
}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(
          _UserModel value, $Res Function(_UserModel) _then) =
      __$UserModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? name,
      String? uid,
      @JsonKey(name: 'member_id') String? memberId,
      String? email,
      String? image,
      String? phone,
      String? fcm,
      String? otp,
      @JsonKey(name: 'proffession') String? profession,
      String? location,
      String? password,
      String? status,
      @JsonKey(name: 'is_ipa_member') bool? isIpaMember,
      @JsonKey(name: 'is_admin') bool? isAdmin,
      String? hierarchy,
      String? role,
      @JsonKey(name: 'last_seen') DateTime? lastSeen,
      bool? online,
      @JsonKey(name: 'reject_reason') String? rejectReason,
      String? bio,
      @JsonKey(name: 'social_media') List<SocialMedia>? socialMedia,
      @JsonKey(name: 'createdAt') DateTime? createdAt,
      @JsonKey(name: 'updatedAt') DateTime? updatedAt,
      @JsonKey(name: '_id') String? id});
}

/// @nodoc
class __$UserModelCopyWithImpl<$Res> implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = freezed,
    Object? uid = freezed,
    Object? memberId = freezed,
    Object? email = freezed,
    Object? image = freezed,
    Object? phone = freezed,
    Object? fcm = freezed,
    Object? otp = freezed,
    Object? profession = freezed,
    Object? location = freezed,
    Object? password = freezed,
    Object? status = freezed,
    Object? isIpaMember = freezed,
    Object? isAdmin = freezed,
    Object? hierarchy = freezed,
    Object? role = freezed,
    Object? lastSeen = freezed,
    Object? online = freezed,
    Object? rejectReason = freezed,
    Object? bio = freezed,
    Object? socialMedia = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? id = freezed,
  }) {
    return _then(_UserModel(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      uid: freezed == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      memberId: freezed == memberId
          ? _self.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _self.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      fcm: freezed == fcm
          ? _self.fcm
          : fcm // ignore: cast_nullable_to_non_nullable
              as String?,
      otp: freezed == otp
          ? _self.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String?,
      profession: freezed == profession
          ? _self.profession
          : profession // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      isIpaMember: freezed == isIpaMember
          ? _self.isIpaMember
          : isIpaMember // ignore: cast_nullable_to_non_nullable
              as bool?,
      isAdmin: freezed == isAdmin
          ? _self.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool?,
      hierarchy: freezed == hierarchy
          ? _self.hierarchy
          : hierarchy // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      lastSeen: freezed == lastSeen
          ? _self.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      online: freezed == online
          ? _self.online
          : online // ignore: cast_nullable_to_non_nullable
              as bool?,
      rejectReason: freezed == rejectReason
          ? _self.rejectReason
          : rejectReason // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _self.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      socialMedia: freezed == socialMedia
          ? _self._socialMedia
          : socialMedia // ignore: cast_nullable_to_non_nullable
              as List<SocialMedia>?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$SocialMedia {
  String? get name;
  String? get url;

  /// Create a copy of SocialMedia
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SocialMediaCopyWith<SocialMedia> get copyWith =>
      _$SocialMediaCopyWithImpl<SocialMedia>(this as SocialMedia, _$identity);

  /// Serializes this SocialMedia to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SocialMedia &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, url);

  @override
  String toString() {
    return 'SocialMedia(name: $name, url: $url)';
  }
}

/// @nodoc
abstract mixin class $SocialMediaCopyWith<$Res> {
  factory $SocialMediaCopyWith(
          SocialMedia value, $Res Function(SocialMedia) _then) =
      _$SocialMediaCopyWithImpl;
  @useResult
  $Res call({String? name, String? url});
}

/// @nodoc
class _$SocialMediaCopyWithImpl<$Res> implements $SocialMediaCopyWith<$Res> {
  _$SocialMediaCopyWithImpl(this._self, this._then);

  final SocialMedia _self;
  final $Res Function(SocialMedia) _then;

  /// Create a copy of SocialMedia
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? url = freezed,
  }) {
    return _then(_self.copyWith(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _SocialMedia implements SocialMedia {
  _SocialMedia({this.name, this.url});
  factory _SocialMedia.fromJson(Map<String, dynamic> json) =>
      _$SocialMediaFromJson(json);

  @override
  final String? name;
  @override
  final String? url;

  /// Create a copy of SocialMedia
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SocialMediaCopyWith<_SocialMedia> get copyWith =>
      __$SocialMediaCopyWithImpl<_SocialMedia>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SocialMediaToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SocialMedia &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, url);

  @override
  String toString() {
    return 'SocialMedia(name: $name, url: $url)';
  }
}

/// @nodoc
abstract mixin class _$SocialMediaCopyWith<$Res>
    implements $SocialMediaCopyWith<$Res> {
  factory _$SocialMediaCopyWith(
          _SocialMedia value, $Res Function(_SocialMedia) _then) =
      __$SocialMediaCopyWithImpl;
  @override
  @useResult
  $Res call({String? name, String? url});
}

/// @nodoc
class __$SocialMediaCopyWithImpl<$Res> implements _$SocialMediaCopyWith<$Res> {
  __$SocialMediaCopyWithImpl(this._self, this._then);

  final _SocialMedia _self;
  final $Res Function(_SocialMedia) _then;

  /// Create a copy of SocialMedia
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = freezed,
    Object? url = freezed,
  }) {
    return _then(_SocialMedia(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
