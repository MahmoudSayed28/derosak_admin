import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  final String id;

  /// اسم الكورس
  final String title;

  /// وصف الكورس
  final String description;

  /// اسم المدرس
  final String teacherName;

  /// صورة الكورس
  final String image;

  /// سعر الكورس
  final double price;

  /// هل الكورس مجاني
  final bool isFree;

  /// هل الكورس ظاهر للطلاب
  final bool isPublished;

  /// ترتيب الكورس داخل السنة
  final int order;

  final Timestamp createdAt;

  const CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.teacherName,
    required this.image,
    required this.price,
    required this.isFree,
    required this.isPublished,
    required this.order,
    required this.createdAt,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      teacherName: json['teacherName'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      isFree: json['isFree'] ?? false,
      isPublished: json['isPublished'] ?? true,
      order: json['order'] ?? 1,
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'teacherName': teacherName,
      'image': image,
      'price': price,
      'isFree': isFree,
      'isPublished': isPublished,
      'order': order,
      'createdAt': createdAt,
    };
  }

  CourseModel copyWith({
    String? id,
    String? title,
    String? description,
    String? teacherName,
    String? image,
    double? price,
    bool? isFree,
    bool? isPublished,
    int? order,
    Timestamp? createdAt,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      teacherName: teacherName ?? this.teacherName,
      image: image ?? this.image,
      price: price ?? this.price,
      isFree: isFree ?? this.isFree,
      isPublished: isPublished ?? this.isPublished,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}