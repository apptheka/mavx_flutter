import 'dart:convert';

class ProjectResponse {
  final int? status;
  final String? message;
  final ProjectDataWrapper? data;

  ProjectResponse({this.status, this.message, this.data});

  factory ProjectResponse.fromJson(Map<String, dynamic> json) {
    return ProjectResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? ProjectDataWrapper.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'data': data?.toJson()};
  }
}

class ProjectDataWrapper {
  final String? message;
  final int? status;
  final int? count;
  final List<ProjectModel>? data;

  ProjectDataWrapper({this.message, this.status, this.count, this.data});

  factory ProjectDataWrapper.fromJson(Map<String, dynamic> json) {
    return ProjectDataWrapper(
      message: json['message'],
      status: json['status'],
      count: json['count'],
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ProjectModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'count': count,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class ProjectModel {
  final int? id;
  final int? projectId;
  final int? expertId;
  final String? status;
  final String? actor;
  final String? note;
  final DateTime? createdAt;
  final String? projectTitle;
  final String? projectVisibility;
  final String? projectType;
  final String? industry;
  final int? requiredExperts;
  final String? requiredManager;
  final int? duration;
  final String? durationType;
  final DateTime? estStartDate;
  final String? description;
  final String? attachment1Title;
  final String? projectFile;
  final String? attachment2Title;
  final String? projectFile2;
  final int? clientId;
  final String? projectCordinator;
  final String? cordinatorEmail;
  final String? cordinatorMobile;
  final int? projectCost;
  final int? budget;
  final String? projectStatus;
  final List<String>? skillsJson;
  final String? ndaUrl;
  final DateTime? startDate;
  final DateTime? completionDate;
  final int? creationBy;
  final DateTime? creationDate;

  ProjectModel({
    this.id,
    this.projectId,
    this.expertId,
    this.status,
    this.actor,
    this.note,
    this.createdAt,
    this.projectTitle,
    this.projectVisibility,
    this.projectType,
    this.industry,
    this.requiredExperts,
    this.requiredManager,
    this.duration,
    this.durationType,
    this.estStartDate,
    this.description,
    this.attachment1Title,
    this.projectFile,
    this.attachment2Title,
    this.projectFile2,
    this.clientId,
    this.projectCordinator,
    this.cordinatorEmail,
    this.cordinatorMobile,
    this.projectCost,
    this.budget,
    this.projectStatus,
    this.skillsJson,
    this.ndaUrl,
    this.startDate,
    this.completionDate,
    this.creationBy,
    this.creationDate,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      projectId: json['project_id'],
      expertId: json['expert_id'],
      status: json['status'],
      actor: json['actor'],
      note: json['note'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      projectTitle: json['project_title'],
      projectVisibility: json['project_visibility'],
      projectType: json['project_type'],
      industry: json['industry']?.toString(),
      requiredExperts: json['required_experts'],
      requiredManager: json['required_manager'],
      duration: json['duration'],
      durationType: json['duration_type'],
      estStartDate: json['est_start_date'] != null
          ? DateTime.tryParse(json['est_start_date'])
          : null,
      description: json['description'],
      attachment1Title: json['attachment1_title'],
      projectFile: json['project_file'],
      attachment2Title: json['attachment2_title'],
      projectFile2: json['project_file2'],
      clientId: json['client_id'],
      projectCordinator: json['project_cordinator'],
      cordinatorEmail: json['cordinator_email'],
      cordinatorMobile: json['cordinator_mobile'],
      projectCost: json['project_cost'],
      budget: json['budget'],
      projectStatus: json['project_status'],
      skillsJson: _parseSkills(json['skills_json']),
      ndaUrl: json['nda_url'],
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'])
          : null,
      completionDate: json['completion_date'] != null
          ? DateTime.tryParse(json['completion_date'])
          : null,
      creationBy: json['creation_by'],
      creationDate: json['creation_date'] != null
          ? DateTime.tryParse(json['creation_date'])
          : null,
    );
  }

  static List<String>? _parseSkills(dynamic value) {
    if (value == null) return null;
    try {
      if (value is List) {
        return value.map((e) => e.toString()).toList();
      }
      if (value is String) {
        final s = value.trim();
        if (s.isEmpty) return null;
        // Try to decode if it's a JSON array string
        try {
          final decoded = jsonDecode(s);
          if (decoded is List) {
            return decoded.map((e) => e.toString()).toList();
          }
        } catch (_) {
          // Not a JSON array string; fall through to return single-item list
        }
        return <String>[s];
      }
    } catch (_) {
      // Swallow parsing issues and return null to avoid breaking UI
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'expert_id': expertId,
      'status': status,
      'actor': actor,
      'note': note,
      'created_at': createdAt?.toIso8601String(),
      'project_title': projectTitle,
      'project_visibility': projectVisibility,
      'project_type': projectType,
      'industry': industry,
      'required_experts': requiredExperts,
      'required_manager': requiredManager,
      'duration': duration,
      'duration_type': durationType,
      'est_start_date': estStartDate?.toIso8601String(),
      'description': description,
      'attachment1_title': attachment1Title,
      'project_file': projectFile,
      'attachment2_title': attachment2Title,
      'project_file2': projectFile2,
      'client_id': clientId,
      'project_cordinator': projectCordinator,
      'cordinator_email': cordinatorEmail,
      'cordinator_mobile': cordinatorMobile,
      'project_cost': projectCost,
      'budget': budget,
      'project_status': projectStatus,
      'skills_json': skillsJson != null ? jsonEncode(skillsJson) : null,
      'nda_url': ndaUrl,
      'start_date': startDate?.toIso8601String(),
      'completion_date': completionDate?.toIso8601String(),
      'creation_by': creationBy,
      'creation_date': creationDate?.toIso8601String(),
    };
  }
}
