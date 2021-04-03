class User {
  int chatUserId;
  String name;
  String avatar;
  String email;
  String password;
  String publicKey;

  User(
      {this.chatUserId,
      this.name,
      this.avatar,
      this.email,
      this.password,
      this.publicKey});

  Map<String, dynamic> toJosn() {
    return {
      "ChatUserId": chatUserId,
      "Name": name,
      "Email": email,
      "Avatar": avatar,
      "Password": password,
      "PublicKey": publicKey
    };
  }

  Map<String, dynamic> toRegisterJson() {
    return {
      "Name": name,
      "Email": email,
      "Avatar": avatar,
      "Password": password,
    };
  }

  Map<String, dynamic> toLoginJson() {
    return {
      "Email": email,
      "Password": password,
    };
  }

  User.fromJson(Map<String, dynamic> json)
      : chatUserId = json['ChatUserId'],
        email = json['Email'],
        name = json['Name'],
        avatar = json['Avatar'],
        password = json['Password'],
        publicKey = json['PublicKey'];

  User.fromUserJson(Map<String, dynamic> json)
      : chatUserId = json['chatUserId'],
        email = json['email'],
        name = json['name'],
        avatar = json['avatar'],
        password = json['password'];
}

final User currentUser =
    User(chatUserId: 0, name: 'You', avatar: 'assets/images/Addison.jpg');

final User addison =
    User(chatUserId: 1, name: 'Addison', avatar: 'assets/images/Addison.jpg');

final User angel =
    User(chatUserId: 2, name: 'Angel', avatar: 'assets/images/Angel.jpg');

final User deanna =
    User(chatUserId: 3, name: 'Deanna', avatar: 'assets/images/Deanna.jpg');

final User jason =
    User(chatUserId: 4, name: 'Json', avatar: 'assets/images/Jason.jpg');

final User judd =
    User(chatUserId: 5, name: 'Judd', avatar: 'assets/images/Judd.jpg');

final User leslie =
    User(chatUserId: 6, name: 'Leslie', avatar: 'assets/images/Leslie.jpg');

final User nathan =
    User(chatUserId: 7, name: 'Nathan', avatar: 'assets/images/Nathan.jpg');

final User stanley =
    User(chatUserId: 8, name: 'Stanley', avatar: 'assets/images/Stanley.jpg');

final User virgil =
    User(chatUserId: 9, name: 'Virgil', avatar: 'assets/images/Virgil.jpg');
