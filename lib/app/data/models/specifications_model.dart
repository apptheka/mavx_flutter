 
class JobRolesResponse {
  final int status;
  final String message;
  final JobRolesData data;

  JobRolesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory JobRolesResponse.fromJson(Map<String, dynamic> json) {
    return JobRolesResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: JobRolesData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class JobRolesData {
  final String message;
  final int status;
  final List<JobRole> data;

  JobRolesData({
    required this.message,
    required this.status,
    required this.data,
  });

  factory JobRolesData.fromJson(Map<String, dynamic> json) {
    return JobRolesData(
      message: json['message'] ?? '',
      status: json['status'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((item) => JobRole.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class JobRole {
  final int id;
  final String title;

  JobRole({
    required this.id,
    required this.title,
  });

  factory JobRole.fromJson(Map<String, dynamic> json) {
    return JobRole(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}
