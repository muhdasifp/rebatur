
class ClassModel {
  final int? classId;
  final String? name;
  final String? section;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ClassModel({
    this.classId,
    this.name,
    this.section,
    this.createdAt,
    this.updatedAt,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) => ClassModel(
    classId: json["class_id"],
    name: json["name"],
    section: json["section"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "class_id": classId,
    "name": name,
    "section": section,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
