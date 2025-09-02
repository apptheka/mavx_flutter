import 'package:json_annotation/json_annotation.dart';

//flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs
part 'response.g.dart';

@JsonSerializable(
    genericArgumentFactories: true,
    fieldRename: FieldRename.snake,
    nullable: true)
class BaseResponse<T> {
  @JsonKey(name: "status")
  final int status;
  @JsonKey(name: "data")
  final T? data;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "token")
  final String? token;
  BaseResponse(this.status, this.data, this.message, this.token);
  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$BaseResponseFromJson(json, fromJsonT);
  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$BaseResponseToJson(this, toJsonT);
}

class CommonResponse {
  CommonResponse({
    required this.status,
    required this.message,
     this.data,
  });
  late final int status;
  late final String message;
  late final Data? data;
  
  CommonResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data?.toJson();
    return _data;
  }
}

class Data {
  Data();
  
  Data.fromJson(Map json);

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    return _data;
  }
}


