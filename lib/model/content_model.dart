import 'dart:ui';

class ContentModel {
  Image? image;
  String? text;
  bool fromUser;
  DateTime createdAt;

  ContentModel({
    this.image,
    this.text,
    required this.fromUser,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        "image": image,
        "text": text,
        "fromUser": fromUser,
        "createdAt": createdAt,
      };

  factory ContentModel.fromFirestore(Map<String, dynamic> map) {
    return ContentModel(
      image: map['image'] != null ? map['image'] as Image : null,
      text: map['text'] as String,
      fromUser: map['fromUser'] != null ? map['fromUser'] as bool : false,
      createdAt: map['createdAt'].toDate() ?? DateTime.now(),
    );
  }
}
