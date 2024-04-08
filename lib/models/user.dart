class User {
  String? userMail;
  String? userPassword;
  bool? isLogedIn;

  User({this.userMail, this.userPassword, this.isLogedIn});

  User.fromJson(Map<String, dynamic> json) {
    userMail = json['userMail'];
    userPassword = json['user_password'];
    isLogedIn = json['isLogedIn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['userMail'] = this.userMail;
    data['user_password'] = this.userPassword;
    data['isLogedIn'] = this.isLogedIn;
    return data;
  }
}

class NormalUser extends User {
  String? userName;
  String? userSurname;
  String? address;
  String? tel;
  String? isLoggedIn;

  NormalUser(
      {this.userName,
      this.userSurname,
      this.address,
      this.tel,
      this.isLoggedIn});

  NormalUser.fromJson(Map<String, dynamic> json) {
    userMail = json['user_name'];
    userSurname = json['user_surname'];
    address = json['address'];
    tel = json['tel'];
    isLoggedIn = json['isLoggedIn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['user_surname'] = this.userSurname;
    data['address'] = this.address;
    data['tel'] = this.tel;
    data['isLoggedIn'] = this.isLoggedIn;
    return data;
  }
}
