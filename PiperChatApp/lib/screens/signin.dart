import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:piperchatapp/models/user_model.dart';
import 'package:piperchatapp/screens/home_page.dart';
import 'package:piperchatapp/screens/signup.dart';
import 'package:piperchatapp/utils/RSA.dart';
import 'package:piperchatapp/utils/utils.dart';
import 'package:piperchatapp/widgets/custom_shape.dart';
import 'package:piperchatapp/widgets/customappbar.dart';
import 'package:piperchatapp/widgets/responsive_ui.dart';
import 'package:piperchatapp/widgets/textformfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/api.dart' as crypto;
import 'package:piperchatapp/app_theme.dart';
import 'package:http/http.dart' as http;

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignInScreen(),
    );
  }
}

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();
  User user;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      child: Container(
        height: _height,
        width: _width,
        padding: EdgeInsets.only(bottom: 5),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              clipShape(),
              welcomeTextRow(),
              signInTextRow(),
              form(),
              SizedBox(height: _height / 12),
              button(),
              signUpTextRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    //double height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 4
                  : (_medium ? _height / 3.75 : _height / 3.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [MyTheme.kPrimaryColor, MyTheme.kAccentColor],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 4.5
                  : (_medium ? _height / 4.25 : _height / 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [MyTheme.kPrimaryColor, MyTheme.kAccentColor],
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(
              top: _large
                  ? _height / 30
                  : (_medium ? _height / 25 : _height / 20)),
          child: Image.asset(
            'assets/images/login.png',
            height: _height / 3.5,
            width: _width / 3.5,
          ),
        ),
      ],
    );
  }

  Widget welcomeTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 20, top: _height / 100),
      child: Row(
        children: <Widget>[
          Text(
            "Welcome",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: _large ? 60 : (_medium ? 50 : 40),
                color: MyTheme.kPrimaryColor),
          ),
        ],
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(left: _width / 15.0),
      child: Row(
        children: <Widget>[
          Text(
            "Sign in to your account",
            style: TextStyle(
                fontWeight: FontWeight.w200,
                fontSize: _large ? 20 : (_medium ? 17.5 : 15),
                color: MyTheme.kAccentColor),
          ),
        ],
      ),
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 15.0),
      child: Form(
        key: _key,
        child: Column(
          children: <Widget>[
            emailTextFormField(),
            SizedBox(height: _height / 40.0),
            passwordTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      textEditingController: emailController,
      icon: Icons.email,
      hint: "Email ID",
    );
  }

  Widget passwordTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      textEditingController: passwordController,
      icon: Icons.lock,
      obscureText: true,
      hint: "Password",
         
    );
  }

  Widget forgetPassTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Forgot your password?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 14 : (_medium ? 12 : 10)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              print("Routing");
            },
            child: Text(
              "Recover",
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.orange[200]),
            ),
          )
        ],
      ),
    );
  }

  _storeUser() async {
    RSA rsa = new RSA();
    rsa.futureKeyPair = rsa.getKeyPair();
    rsa.keyPair = await rsa.futureKeyPair;
    String publicKey = RSA.publicKeyString(rsa.keyPair.publicKey);
    String privateKey = RSA.privateKeyString(rsa.keyPair.privateKey);
    user.publicKey = publicKey;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Utils.CURRENT_USER, jsonEncode(user.toJosn()));
    prefs.setString(Utils.PRIVATE_KEY, privateKey);
  }

  loginUser() async {
    User newUser = new User(
        email: emailController.text, password: passwordController.text);

    var response = await http.post(
      Utils.BASE_URL + "/api/user/login",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(newUser.toLoginJson()),
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      user = new User(
          chatUserId: json['chatUserId'],
          name: json['name'],
          email: json['name'],
          password: json['password'],
          avatar: json['avatar']);
      await _storeUser();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }else{
      print('failed');
    }
  }

  Widget button() {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(85.0)),
      onPressed: () async {
        await loginUser();
        print("Routing to your account");
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Login Successful')));
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        width: _large ? _width / 2 : (_medium ? _width / 2 : _width / 2),
        height: 55.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          gradient: LinearGradient(
            colors: <Color>[MyTheme.kAccentColor, MyTheme.kPrimaryColor],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text('SIGN IN',
            style: TextStyle(fontSize: _large ? 18 : (_medium ? 18 : 16))),
      ),
    );
  }

  Widget signUpTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Don't have an account?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 16 : (_medium ? 16 : 16)),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpScreen()),
              );
              print("Routing to Sign up screen");
            },
            child: Text(
              "Sign up",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.orange[200],
                  fontSize: _large ? 19 : (_medium ? 17 : 15)),
            ),
          )
        ],
      ),
    );
  }
}
