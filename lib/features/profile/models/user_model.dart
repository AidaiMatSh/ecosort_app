class UserModel {
  String firstName;
  String lastName;
  String email;
  DateTime? birthDate;
  String address;
  String? avatarPath;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.birthDate,
    required this.address,
    this.avatarPath,
  });

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'birthDate': birthDate?.toIso8601String(),
        'address': address,
        'avatarPath': avatarPath,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'])
          : null,
      address: json['address'],
      avatarPath: json['avatarPath'],
    );
  }
}