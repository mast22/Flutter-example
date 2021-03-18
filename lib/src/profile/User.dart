class User {
  final String firstName;
  final String lastName;
  final String vk;
  final String birthDate;
  final String phone;
  final String skype;
  final String login;
  final String profileImage;

  User(
    this.firstName,
    this.lastName,
    this.vk,
    this.birthDate,
    this.phone,
    this.skype,
    this.login,
    this.profileImage,
  );

  User.fromJson(Map<String, dynamic> json)
      : firstName = json['user'],
        lastName = json['family'],
        vk = json['vk'],
        birthDate = json['bithday'],
        phone = json['phonenumber'],
        skype = json['skype'],
        login = json['login'],
        profileImage = json['img'];
}
