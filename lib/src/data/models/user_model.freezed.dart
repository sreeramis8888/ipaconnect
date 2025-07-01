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
  @JsonKey(name: '_id')
  String? get id;
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
  String? get hierarchy;
  @JsonKey(unknownEnumValue: UserStatus.active)
  UserStatus get status;
  @JsonKey(name: 'is_ipa_member')
  bool get isIpaMember;
  @JsonKey(name: 'is_admin')
  bool get isAdmin;
  String? get role;
  DateTime? get createdAt;
  DateTime? get updatedAt;

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
            (identical(other.id, id) || other.id == id) &&
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
            (identical(other.hierarchy, hierarchy) ||
                other.hierarchy == hierarchy) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isIpaMember, isIpaMember) ||
                other.isIpaMember == isIpaMember) &&
            (identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
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
        hierarchy,
        status,
        isIpaMember,
        isAdmin,
        role,
        createdAt,
        updatedAt
      ]);

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, uid: $uid, memberId: $memberId, email: $email, image: $image, phone: $phone, fcm: $fcm, otp: $otp, profession: $profession, location: $location, password: $password, hierarchy: $hierarchy, status: $status, isIpaMember: $isIpaMember, isAdmin: $isAdmin, role: $role, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) =
      _$UserModelCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String? id,
      String? name,
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
      String? hierarchy,
      @JsonKey(unknownEnumValue: UserStatus.active) UserStatus status,
      @JsonKey(name: 'is_ipa_member') bool isIpaMember,
      @JsonKey(name: 'is_admin') bool isAdmin,
      String? role,
      DateTime? createdAt,
      DateTime? updatedAt});
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
    Object? id = freezed,
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
    Object? hierarchy = freezed,
    Object? status = null,
    Object? isIpaMember = null,
    Object? isAdmin = null,
    Object? role = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
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
      hierarchy: freezed == hierarchy
          ? _self.hierarchy
          : hierarchy // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as UserStatus,
      isIpaMember: null == isIpaMember
          ? _self.isIpaMember
          : isIpaMember // ignore: cast_nullable_to_non_nullable
              as bool,
      isAdmin: null == isAdmin
          ? _self.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
      role: freezed == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _UserModel implements UserModel {
  const _UserModel(
      {@JsonKey(name: '_id') this.id,
      this.name,
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
      this.hierarchy,
      @JsonKey(unknownEnumValue: UserStatus.active)
      this.status = UserStatus.active,
      @JsonKey(name: 'is_ipa_member') this.isIpaMember = false,
      @JsonKey(name: 'is_admin') this.isAdmin = false,
      this.role,
      this.createdAt,
      this.updatedAt});
  factory _UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
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
  final String? hierarchy;
  @override
  @JsonKey(unknownEnumValue: UserStatus.active)
  final UserStatus status;
  @override
  @JsonKey(name: 'is_ipa_member')
  final bool isIpaMember;
  @override
  @JsonKey(name: 'is_admin')
  final bool isAdmin;
  @override
  final String? role;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

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
            (identical(other.id, id) || other.id == id) &&
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
            (identical(other.hierarchy, hierarchy) ||
                other.hierarchy == hierarchy) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isIpaMember, isIpaMember) ||
                other.isIpaMember == isIpaMember) &&
            (identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
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
        hierarchy,
        status,
        isIpaMember,
        isAdmin,
        role,
        createdAt,
        updatedAt
      ]);

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, uid: $uid, memberId: $memberId, email: $email, image: $image, phone: $phone, fcm: $fcm, otp: $otp, profession: $profession, location: $location, password: $password, hierarchy: $hierarchy, status: $status, isIpaMember: $isIpaMember, isAdmin: $isAdmin, role: $role, createdAt: $createdAt, updatedAt: $updatedAt)';
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
      {@JsonKey(name: '_id') String? id,
      String? name,
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
      String? hierarchy,
      @JsonKey(unknownEnumValue: UserStatus.active) UserStatus status,
      @JsonKey(name: 'is_ipa_member') bool isIpaMember,
      @JsonKey(name: 'is_admin') bool isAdmin,
      String? role,
      DateTime? createdAt,
      DateTime? updatedAt});
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
    Object? id = freezed,
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
    Object? hierarchy = freezed,
    Object? status = null,
    Object? isIpaMember = null,
    Object? isAdmin = null,
    Object? role = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_UserModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
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
      hierarchy: freezed == hierarchy
          ? _self.hierarchy
          : hierarchy // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as UserStatus,
      isIpaMember: null == isIpaMember
          ? _self.isIpaMember
          : isIpaMember // ignore: cast_nullable_to_non_nullable
              as bool,
      isAdmin: null == isAdmin
          ? _self.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool,
      role: freezed == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
