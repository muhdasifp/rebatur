
import 'dart:convert';

class StudentResponseModel {
  final bool? success;
  final String? message;
  final List<StudentModel>? data;
  final Meta? meta;

  StudentResponseModel({
    this.success,
    this.message,
    this.data,
    this.meta,
  });

  factory StudentResponseModel.fromJson(Map<String, dynamic> json) => StudentResponseModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<StudentModel>.from(json["data"]!.map((x) => StudentModel.fromJson(x))),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

}

class StudentModel {
  final int? id;
  final String? name;
  final String? phone;
  final String? datumClass;
  final List<String>? subjects;
  final String? photo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  StudentModel({
    this.id,
    this.name,
    this.phone,
    this.datumClass,
    this.subjects,
    this.photo,
    this.createdAt,
    this.updatedAt,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedSubjects = [];

    if (json["subjects"] != null) {
      if (json["subjects"] is String) {
        // Decode the string into a List
        parsedSubjects = List<String>.from(jsonDecode(json["subjects"]));
      } else if (json["subjects"] is List) {
        parsedSubjects = List<String>.from(json["subjects"]);
      }
    }

    return StudentModel(
      id: json["id"],
      name: json["name"],
      phone: json["phone"],
      datumClass: json["class"],
      subjects: parsedSubjects,
      photo: json["photo"],
      createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );
  }
}


class Meta {
  final int? currentPage;
  final int? perPage;
  final int? total;
  final int? lastPage;
  final dynamic nextPageUrl;
  final dynamic prevPageUrl;

  Meta({
    this.currentPage,
    this.perPage,
    this.total,
    this.lastPage,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    perPage: json["per_page"],
    total: json["total"],
    lastPage: json["last_page"],
    nextPageUrl: json["next_page_url"],
    prevPageUrl: json["prev_page_url"],
  );

}
