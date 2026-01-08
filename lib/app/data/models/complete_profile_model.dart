// user_profile_model.dart

class UserProfile {
  final Preferences? preferences;
  final AboutMe? aboutMe;
  final List<Experience>? experience;
  final List<Education>? education;
  final List<Language>? languages;
  final List<OnlineProfile>? onlineProfiles;
  final BasicDetails? basicDetails;
  final List<Skill>? skills;
  final BankDetails? bankDetails;

  UserProfile({
    this.preferences,
    this.aboutMe,
    this.experience,
    this.education,
    this.languages,
    this.onlineProfiles,
    this.basicDetails,
    this.skills,
    this.bankDetails,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    // Unwrap common envelopes: { data: { data: {...} } } or { data: {...} }
    dynamic root = json['data'] ?? json;
    if (root is Map && root['data'] != null) {
      root = root['data'];
    }
    final Map<String, dynamic> data = root is Map<String, dynamic>
        ? root
        : <String, dynamic>{};

    return UserProfile(
      preferences: (data['preferences'] ?? data['preference']) != null
          ? Preferences.fromJson(
              Map<String, dynamic>.from(
                (data['preferences'] ?? data['preference']) as Map,
              ),
            )
          : null,
      aboutMe: (data['aboutMe'] ?? data['about_me']) != null
          ? AboutMe.fromJson(
              Map<String, dynamic>.from(
                (data['aboutMe'] ?? data['about_me']) as Map,
              ),
            )
          : null,
      experience: (data['experience'] ?? data['experiences']) != null
          ? List<Experience>.from(
              ((data['experience'] ?? data['experiences']) as List)
                  .whereType<Map>()
                  .map(
                    (x) => Experience.fromJson(Map<String, dynamic>.from(x)),
                  ),
            )
          : [],
      education: (data['education'] ?? data['educations']) != null
          ? List<Education>.from(
              ((data['education'] ?? data['educations']) as List)
                  .whereType<Map>()
                  .map((x) => Education.fromJson(Map<String, dynamic>.from(x))),
            )
          : [],
      languages: (data['languages'] ?? data['language']) != null
          ? List<Language>.from(
              ((data['languages'] ?? data['language']) as List)
                  .whereType<Map>()
                  .map((x) => Language.fromJson(Map<String, dynamic>.from(x))),
            )
          : [],
      onlineProfiles:
          (data['onlineProfiles'] ?? data['online_profiles']) != null
          ? List<OnlineProfile>.from(
              ((data['onlineProfiles'] ?? data['online_profiles']) as List)
                  .whereType<Map>()
                  .map(
                    (x) => OnlineProfile.fromJson(Map<String, dynamic>.from(x)),
                  ),
            )
          : [],
      basicDetails: (data['basicDetails'] ?? data['basic_details']) != null
          ? BasicDetails.fromJson(
              Map<String, dynamic>.from(
                (data['basicDetails'] ?? data['basic_details']) as Map,
              ),
            )
          : null,
      skills: (data['skills'] ?? data['skill']) != null
          ? List<Skill>.from(
              ((data['skills'] ?? data['skill']) as List).whereType<Map>().map(
                (x) => Skill.fromJson(Map<String, dynamic>.from(x)),
              ),
            )
          : [],
      bankDetails: data['bankDetails'] != null
          ? BankDetails.fromJson(Map<String, dynamic>.from(data['bankDetails']))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'preferences': preferences?.toJson(),
      'aboutMe': aboutMe?.toJson(),
      'experience': experience?.map((x) => x.toJson()).toList(),
      'education': education?.map((x) => x.toJson()).toList(),
      'languages': languages?.map((x) => x.toJson()).toList(),
      'onlineProfiles': onlineProfiles?.map((x) => x.toJson()).toList(),
      'basicDetails': basicDetails?.toJson(),
      'skills': skills?.map((x) => x.toJson()).toList(),
      'bankDetails': bankDetails?.toJson(),
    };
  }
}

class Preferences {
  final int? id;
  final int? userId;
  final String? lookingFor;
  final String? preferredBudget;
  final String? budgetCurrency;
  final String? budgetPeriod;
  final int? availabilityHoursPerWeek;
  final String? availabilityType;
  final int? preferredDurationMin;
  final int? preferredDurationMax;
  final String? preferredDurationType;
  final String? workType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Preferences({
    this.id,
    this.userId,
    this.lookingFor,
    this.preferredBudget,
    this.budgetCurrency,
    this.budgetPeriod,
    this.availabilityHoursPerWeek,
    this.availabilityType,
    this.preferredDurationMin,
    this.preferredDurationMax,
    this.preferredDurationType,
    this.workType,
    this.createdAt,
    this.updatedAt,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      id: json['id'],
      userId: json['user_id'],
      lookingFor: json['looking_for'],
      preferredBudget: json['preferred_budget'],
      budgetCurrency: json['budget_currency'],
      budgetPeriod: json['budget_period'],
      availabilityHoursPerWeek: json['availability_hours_per_week'],
      availabilityType: json['availability_type'],
      preferredDurationMin: json['preferred_duration_min'],
      preferredDurationMax: json['preferred_duration_max'],
      preferredDurationType: json['preferred_duration_type'],
      workType: json['work_type'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'looking_for': lookingFor,
      'preferred_budget': preferredBudget,
      'budget_currency': budgetCurrency,
      'budget_period': budgetPeriod,
      'availability_hours_per_week': availabilityHoursPerWeek,
      'availability_type': availabilityType,
      'preferred_duration_min': preferredDurationMin,
      'preferred_duration_max': preferredDurationMax,
      'preferred_duration_type': preferredDurationType,
      'work_type': workType,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class AboutMe {
  final int? id;
  final int? userId;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AboutMe({
    this.id,
    this.userId,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory AboutMe.fromJson(Map<String, dynamic> json) {
    return AboutMe(
      id: json['id'],
      userId: json['user_id'],
      description: json['description'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class Experience {
  final int? id;
  final int? userId;
  final String? companyName;
  final String? role;
  final String? employmentType;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? isCurrent;
  final int? isRemote;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Experience({
    this.id,
    this.userId,
    this.companyName,
    this.role,
    this.employmentType,
    this.startDate,
    this.endDate,
    this.isCurrent,
    this.isRemote,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'],
      userId: json['user_id'],
      companyName: json['company_name'],
      role: json['role'],
      employmentType: json['employment_type'],
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'])
          : null,
      endDate: json['end_date'] != null
          ? DateTime.tryParse(json['end_date'])
          : null,
      isCurrent: json['is_current'],
      isRemote: json['is_remote'],
      description: json['description'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'company_name': companyName,
      'role': role,
      'employment_type': employmentType,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_current': isCurrent,
      'is_remote': isRemote,
      'description': description,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class Education {
  final int? id;
  final int? userId;
  final String? institutionName;
  final String? degree;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? isCurrent;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Education({
    this.id,
    this.userId,
    this.institutionName,
    this.degree,
    this.startDate,
    this.endDate,
    this.isCurrent,
    this.createdAt,
    this.updatedAt,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'],
      userId: json['user_id'],
      institutionName: json['institution_name'],
      degree: json['degree'],
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'])
          : null,
      endDate: json['end_date'] != null
          ? DateTime.tryParse(json['end_date'])
          : null,
      isCurrent: json['is_current'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'institution_name': institutionName,
      'degree': degree,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_current': isCurrent,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class Language {
  final int? id;
  final int? userId;
  final String? languageName;
  final String? proficiencyLevel;
  final int? canRead;
  final int? canWrite;
  final int? canSpeak;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Language({
    this.id,
    this.userId,
    this.languageName,
    this.proficiencyLevel,
    this.canRead,
    this.canWrite,
    this.canSpeak,
    this.createdAt,
    this.updatedAt,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'],
      userId: json['user_id'],
      languageName: json['language_name'],
      proficiencyLevel: json['proficiency_level'],
      canRead: json['can_read'],
      canWrite: json['can_write'],
      canSpeak: json['can_speak'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'language_name': languageName,
      'proficiency_level': proficiencyLevel,
      'can_read': canRead,
      'can_write': canWrite,
      'can_speak': canSpeak,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class OnlineProfile {
  final int? id;
  final int? userId;
  final String? platformType;
  final String? profileUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OnlineProfile({
    this.id,
    this.userId,
    this.platformType,
    this.profileUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory OnlineProfile.fromJson(Map<String, dynamic> json) {
    return OnlineProfile(
      id: json['id'],
      userId: json['user_id'],
      platformType: json['platform_type'],
      profileUrl: json['profile_url'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'platform_type': platformType,
      'profile_url': profileUrl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class BasicDetails {
  final int? id;
  final int? userId;
  final String? email;
  final String? phone;
  final String? gender;
  final DateTime? dateOfBirth;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BasicDetails({
    this.id,
    this.userId,
    this.email,
    this.phone,
    this.gender,
    this.dateOfBirth,
    this.createdAt,
    this.updatedAt,
  });

  factory BasicDetails.fromJson(Map<String, dynamic> json) {
    final dobRaw =
        json['date_of_birth'] ?? json['dob'] ?? json['dateOfBirth'];
    return BasicDetails(
      id: json['id'],
      userId: json['user_id'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'],
      dateOfBirth:
          dobRaw != null ? DateTime.tryParse(dobRaw.toString()) : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'email': email,
      'phone': phone,
      'gender': gender,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class Skill {
  final int? id;
  final int? userId;
  final String? skillName;
  final String? skillCategory;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Skill({
    this.id,
    this.userId,
    this.skillName,
    this.skillCategory,
    this.createdAt,
    this.updatedAt,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'],
      userId: json['user_id'],
      skillName: json['skill_name'],
      skillCategory: json['skill_category'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'skill_name': skillName,
      'skill_category': skillCategory,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class BankDetails {
  final int? id;
  final int? userId;
  final String? accountHolderName;
  final String? bankName;
  final String? accountNumber;
  final String? ifsc;
  final String? branch;
  final String? bankAddress;
  final String? country;
  final String? currency;
  final String? swift;
  final String? iban;
  final String? routingNumber;
  final String? intermediaryBank;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BankDetails({
    this.id,
    this.userId,
    this.accountHolderName,
    this.bankName,
    this.accountNumber,
    this.ifsc,
    this.branch,
    this.bankAddress,
    this.country,
    this.currency,
    this.swift,
    this.iban,
    this.routingNumber,
    this.intermediaryBank,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory BankDetails.fromJson(Map<String, dynamic> json) {
    return BankDetails(
      id: json['id'],
      userId: json['user_id'],
      accountHolderName: json['account_holder_name'],
      bankName: json['bank_name'],
      accountNumber: json['account_number'],
      ifsc: json['ifsc'],
      branch: json['branch'],
      bankAddress: json['bank_address'],
      country: json['country'],
      currency: json['currency'],
      swift: json['swift'],
      iban: json['iban'],
      routingNumber: json['routing_number'],
      intermediaryBank: json['intermediary_bank'],
      notes: json['notes'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'account_holder_name': accountHolderName,
      'bank_name': bankName,
      'account_number': accountNumber,
      'ifsc': ifsc,
      'branch': branch,
      'bank_address': bankAddress,
      'country': country,
      'currency': currency,
      'swift': swift,
      'iban': iban,
      'routing_number': routingNumber,
      'intermediary_bank': intermediaryBank,
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
