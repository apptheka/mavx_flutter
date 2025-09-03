 class IndustriesResponse {
  final int status;
  final String message;
  final IndustriesData data;

  IndustriesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory IndustriesResponse.fromJson(Map<String, dynamic> json) {
    return IndustriesResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: IndustriesData.fromJson(json['data'] ?? {}),
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

class IndustriesData {
  final String message;
  final int status;
  final List<Industry> data;

  IndustriesData({
    required this.message,
    required this.status,
    required this.data,
  });

  factory IndustriesData.fromJson(Map<String, dynamic> json) {
    return IndustriesData(
      message: json['message'] ?? '',
      status: json['status'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((item) => Industry.fromJson(item))
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

class Industry {
  final int id;
  final String title;

  Industry({
    required this.id,
    required this.title,
  });

  factory Industry.fromJson(Map<String, dynamic> json) {
    return Industry(
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
