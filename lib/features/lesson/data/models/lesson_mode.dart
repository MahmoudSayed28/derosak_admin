import 'package:cloud_firestore/cloud_firestore.dart';

class LessonModel {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final int order;
  final bool isFree;
  final bool isPublished;
  final Timestamp createdAt;

  const LessonModel({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.order,
    required this.isFree,
    required this.isPublished,
    required this.createdAt,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json["id"] as String,
      title: json["title"] as String,
      description: json["description"] as String,
      videoUrl: json["videoUrl"] as String,
      order: json["order"] ?? 1,
      isFree: json["isFree"] ?? false,
      isPublished: json["isPublished"] ?? true,
      createdAt: json["createdAt"] as Timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "videoUrl": videoUrl,
      "order": order,
      "isFree": isFree,
      "isPublished": isPublished,
      "createdAt": createdAt,
    };
  }

  LessonModel copyWith({
    String? id,
    String? title,
    String? description,
    String? videoUrl,
    int? order,
    bool? isFree,
    bool? isPublished,
    Timestamp? createdAt,
  }) {
    return LessonModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      order: order ?? this.order,
      isFree: isFree ?? this.isFree,
      isPublished: isPublished ?? this.isPublished,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}