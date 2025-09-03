// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterModel _$RegisterModelFromJson(Map<String, dynamic> json) =>
    RegisterModel(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      token: json['token'] as String?,
      data: json['data'] == null
          ? null
          : RegisterData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RegisterModelToJson(RegisterModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'token': instance.token,
      'data': instance.data,
    };

RegisterData _$RegisterDataFromJson(Map<String, dynamic> json) => RegisterData(
  id: (json['id'] as num?)?.toInt(),
  fullName: json['fullName'] as String?,
  lastName: json['lastName'] as String?,
  dob: json['dob'] as String?,
  location: json['location'] as String?,
  country: json['country'] as String?,
  continent: json['continent'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  alternateEmail: json['alternateEmail'] as String?,
  experience: (json['experience'] as num?)?.toInt(),
  ctc: json['ctc'] as String?,
  linkedin: json['linkedin'] as String?,
  roleType: json['roleType'] as String?,
  primaryFunction: (json['primaryFunction'] as num?)?.toInt(),
  customPrimaryFunction: json['customPrimaryFunction'] as String?,
  primarySector: (json['primarySector'] as num?)?.toInt(),
  customPrimarySector: json['customPrimarySector'] as String?,
  employer: json['employer'] as String?,
  secondaryFunction: (json['secondaryFunction'] as num?)?.toInt(),
  secondarySector: (json['secondarySector'] as num?)?.toInt(),
  achievements: json['achievements'] as String?,
  resume: json['resume'] as String?,
  idType: json['idType'] as String?,
  idFile: json['idFile'] as String?,
  profile: json['profile'] as String?,
  createdAt: json['created_at'] as String?,
  password: json['password'] as String?,
  status: json['status'] as String?,
);

Map<String, dynamic> _$RegisterDataToJson(RegisterData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'lastName': instance.lastName,
      'dob': instance.dob,
      'location': instance.location,
      'country': instance.country,
      'continent': instance.continent,
      'phone': instance.phone,
      'email': instance.email,
      'alternateEmail': instance.alternateEmail,
      'experience': instance.experience,
      'ctc': instance.ctc,
      'linkedin': instance.linkedin,
      'roleType': instance.roleType,
      'primaryFunction': instance.primaryFunction,
      'customPrimaryFunction': instance.customPrimaryFunction,
      'primarySector': instance.primarySector,
      'customPrimarySector': instance.customPrimarySector,
      'employer': instance.employer,
      'secondaryFunction': instance.secondaryFunction,
      'secondarySector': instance.secondarySector,
      'achievements': instance.achievements,
      'resume': instance.resume,
      'idType': instance.idType,
      'idFile': instance.idFile,
      'profile': instance.profile,
      'created_at': instance.createdAt,
      'password': instance.password,
      'status': instance.status,
    };
