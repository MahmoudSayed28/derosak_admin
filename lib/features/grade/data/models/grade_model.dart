import 'package:cloud_firestore/cloud_firestore.dart';

class GradeModel {
  final String id;
  final String name;
  final int order;
  final Timestamp createdAt;

  const GradeModel({
    required this.id,
    required this.name,
    required this.order,
    required this.createdAt,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      order: json['order'] as int,
      createdAt: json['createdAt'] as Timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'order': order,
      'createdAt': createdAt,
    };
  }

  GradeModel copyWith({
    String? id,
    String? name,
    int? order,
    Timestamp? createdAt,
  }) {
    return GradeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}