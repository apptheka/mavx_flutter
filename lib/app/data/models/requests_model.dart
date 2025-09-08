class RequestResponse {
  final String? message;
  final int? status;
  final int? count;
  final List<RequestData>? data;

  RequestResponse({
    this.message,
    this.status,
    this.count,
    this.data,
  });

  factory RequestResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return RequestResponse();
    
    List<RequestData>? requestList;
    final dataField = json['data'];
    
    if (dataField is Map<String, dynamic>) {
      // Check if it's a nested structure with data inside data
      if (dataField.containsKey('data') && dataField['data'] is List) {
        requestList = (dataField['data'] as List)
            .map((item) => RequestData.fromJson(item as Map<String, dynamic>?))
            .toList();
      } else {
        // Single object wrapped in data
        requestList = [RequestData.fromJson(dataField)];
      }
    } else if (dataField is List) {
      // Direct list
      requestList = dataField
          .map((item) => RequestData.fromJson(item as Map<String, dynamic>?))
          .toList();
    }
    
    return RequestResponse(
      message: json['message']?.toString(),
      status: int.tryParse(json['status']?.toString() ?? ''),
      count: int.tryParse(json['count']?.toString() ?? ''),
      data: requestList,
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

class RequestData {
  final int? id;
  final int? projectId;
  final int? expertId;
  final String? status;
  final String? message;
  final String? note;
  final DateTime? createdAt;
  final DateTime? respondedAt;
  final String? projectTitle;
  final String? description;
  final int? budget;
  final String? projectType;

  RequestData({
    this.id,
    this.projectId,
    this.expertId,
    this.status,
    this.message,
    this.note,
    this.createdAt,
    this.respondedAt,
    this.projectTitle,
    this.description,
    this.budget,
    this.projectType,
  });

  factory RequestData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return RequestData();
    return RequestData(
      id: int.tryParse(json['id']?.toString() ?? ''),
      projectId: int.tryParse(json['project_id']?.toString() ?? ''),
      expertId: int.tryParse(json['expert_id']?.toString() ?? ''),
      status: json['status']?.toString(),
      message: json['message']?.toString(),
      note: json['note']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      respondedAt: json['responded_at'] != null
          ? DateTime.tryParse(json['responded_at'].toString())
          : null,
      projectTitle: json['project_title']?.toString(),
      description: json['description']?.toString(),
      budget: int.tryParse(json['budget']?.toString() ?? ''),
      projectType: json['project_type']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'expert_id': expertId,
      'status': status,
      'message': message,
      'note': note,
      'created_at': createdAt?.toIso8601String(),
      'responded_at': respondedAt?.toIso8601String(),
      'project_title': projectTitle,
      'description': description,
      'budget': budget,
      'project_type': projectType,
    };
  }
}
