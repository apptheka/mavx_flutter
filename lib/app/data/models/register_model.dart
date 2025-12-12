import 'package:json_annotation/json_annotation.dart';

part 'register_model.g.dart';

@JsonSerializable()
class RegisterModel {
  final int? status;
  final String? message;
  final String? token;
  final RegisterData? data;

  RegisterModel({
    this.status,
    this.message,
    this.token,
    this.data,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      status: _asInt(json['status']),
      message: json['message']?.toString(),
      token: json['token']?.toString(),
      data: json['data'] is Map<String, dynamic>
          ? RegisterData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => _$RegisterModelToJson(this);
}

@JsonSerializable()
class RegisterData {
  final int? id;
  final String? fullName;
  final String? lastName;
  final String? dob;
  final String? location;
  final String? country;
  final String? continent;
  final String? phone;
  final String? email;
  final String? alternateEmail;
  final int? experience;
  final String? ctc;
  final String? linkedin;
  final String? roleType;
  final int? primaryFunction;
  final String? customPrimaryFunction;
  final int? primarySector;
  final String? customPrimarySector;
  final String? employer;
  final int? secondaryFunction;
  final int? secondarySector;
  final String? achievements;
  final String? resume;
  final String? idType;
  final String? idFile;
  final String? profile; 
  final String? createdAt;
  final String? password;
  final String? status;

  RegisterData({
    this.id,
    this.fullName,
    this.lastName,
    this.dob,
    this.location,
    this.country,
    this.continent,
    this.phone,
    this.email,
    this.alternateEmail,
    this.experience,
    this.ctc,
    this.linkedin,
    this.roleType,
    this.primaryFunction,
    this.customPrimaryFunction,
    this.primarySector,
    this.customPrimarySector,
    this.employer,
    this.secondaryFunction,
    this.secondarySector,
    this.achievements,
    this.resume,
    this.idType,
    this.idFile,
    this.profile,
    this.createdAt,
    this.password,
    this.status,
  });

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      id: _asInt(json['id']),
      fullName: json['fullName']?.toString(),
      lastName: json['lastName']?.toString(),
      dob: json['dob']?.toString(),
      location: json['location']?.toString(),
      country: json['country']?.toString(),
      continent: json['continent']?.toString(),
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      alternateEmail: json['alternateEmail']?.toString(),
      experience: _asInt(json['experience']),
      ctc: json['ctc']?.toString(),
      linkedin: json['linkedin']?.toString(),
      roleType: json['roleType']?.toString(),
      primaryFunction: _asInt(json['primaryFunction']),
      customPrimaryFunction: json['customPrimaryFunction']?.toString(),
      primarySector: _asInt(json['primarySector']),
      customPrimarySector: json['customPrimarySector']?.toString(),
      employer: json['employer']?.toString(),
      secondaryFunction: _asInt(json['secondaryFunction']),
      secondarySector: _asInt(json['secondarySector']),
      achievements: json['achievements']?.toString(),
      resume: json['resume']?.toString(),
      idType: json['idType']?.toString(),
      idFile: json['idFile']?.toString(),
      profile: json['profile']?.toString(),
      createdAt: json['createdAt']?.toString(),
      password: json['password']?.toString(),
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => _$RegisterDataToJson(this);
}

int? _asInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) {
    final s = v.trim();
    if (s.isEmpty) return null;
    final i = int.tryParse(s);
    if (i != null) return i;
    final d = double.tryParse(s);
    if (d != null) return d.toInt();
  }
  return null;
}
