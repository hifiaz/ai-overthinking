class UserModel {
  String? id;
  String? uid;
  String email;
  String? fullName;
  int quota;
  UserModel({
    this.id,
    this.uid,
    required this.email,
    this.fullName,
    required this.quota,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as String : null,
      uid: map['uid'] != null ? map['uid'] as String : null,
      email: map['email'] as String,
      fullName: map['fullName'] != null ? map['fullName'] as String : null,
      quota: map['quota'] as int,
    );
  }
}
