import 'package:cloud_firestore/cloud_firestore.dart';

class ResourceModel {
  final String id;

  final String title;

  final String url;

  final String type;

  final int order;

  final bool isFree;

  final Timestamp createdAt;

  const ResourceModel({
    required this.id,
    required this.title,
    required this.url,
    required this.type,
    required this.order,
    required this.isFree,
    required this.createdAt,
  });

  factory ResourceModel.fromJson(Map<String, dynamic> json) {
    return ResourceModel(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      type: json['type'],
      order: json['order'] ?? 1,
      isFree: json['isFree'] ?? false,
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'type': type,
      'order': order,
      'isFree': isFree,
      'createdAt': createdAt,
    };
  }

  ResourceModel copyWith({
    String? id,
    String? title,
    String? url,
    String? type,
    int? order,
    bool? isFree,
    Timestamp? createdAt,
  }) {
    return ResourceModel(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      type: type ?? this.type,
      order: order ?? this.order,
      isFree: isFree ?? this.isFree,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
