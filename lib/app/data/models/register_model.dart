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

  factory RegisterModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterModelFromJson(json);

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

  factory RegisterData.fromJson(Map<String, dynamic> json) =>
      _$RegisterDataFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterDataToJson(this);
}
