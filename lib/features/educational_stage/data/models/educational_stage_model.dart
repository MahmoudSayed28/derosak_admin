import 'package:cloud_firestore/cloud_firestore.dart';

class EducationalStageModel {
  final String id;
  final String name;
  final String image;
  final Timestamp createdAt;

  const EducationalStageModel({
    required this.id,
    required this.name,
    required this.image,
    required this.createdAt,
  });

  factory EducationalStageModel.fromJson(Map<String, dynamic> json) {
    return EducationalStageModel(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      createdAt: json['createdAt'] as Timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'createdAt': createdAt,
    };
  }

  EducationalStageModel copyWith({
    String? id,
    String? name,
    String? image,
    Timestamp? createdAt,
  }) {
    return EducationalStageModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}