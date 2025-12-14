import 'package:cloud_firestore/cloud_firestore.dart';



DateTime _parseDateTime(dynamic value) {
  if (value == null) {
    throw ArgumentError('DateTime value (createdAt) cannot be null');
  }
  if (value is Timestamp) {
    return value.toDate();
  }
  if (value is String) {
    return DateTime.parse(value);
  }
  return value as DateTime;
}

DateTime? _parseOptionalDateTime(dynamic value) {
  if (value == null) return null;
  if (value is Timestamp) {
    return value.toDate();
  }
  if (value is String) {
    return DateTime.tryParse(value);
  }
  return value as DateTime?;
}




class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String? bio;
  final String? address;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.bio,
    this.address,
    required this.createdAt,
    this.lastLoginAt,
  });


  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'bio': bio,
      'address': address,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt': lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
    };
  }


  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      email: map['email'] as String,
      displayName: map['displayName'] as String? ?? '',
      firstName: map['firstName'] as String? ?? '',
      lastName: map['lastName'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String? ?? '',
      bio: map['bio'] as String?,
      address: map['address'] as String?,

      createdAt: _parseDateTime(map['createdAt']),
      lastLoginAt: _parseOptionalDateTime(map['lastLoginAt']),
    );
  }


  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? bio,
    String? address,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bio: bio ?? this.bio,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }


  String get fullName => '$firstName $lastName';
}