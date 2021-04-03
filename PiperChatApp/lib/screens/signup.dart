import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:piperchatapp/models/user_model.dart';
import 'package:piperchatapp/screens/signin.dart';
import 'package:piperchatapp/utils/utils.dart';
//import 'package:login_signup/constants/constants.dart';
import 'package:piperchatapp/widgets/custom_shape.dart';
import 'package:piperchatapp/widgets/customappbar.dart';
import 'package:piperchatapp/widgets/responsive_ui.dart';
import 'package:piperchatapp/widgets/textformfield.dart';
import 'package:piperchatapp/app_theme.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  String avatar = "assets/images/user_avatar.png";

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Material(
      child: Scaffold(
        body: Container(
          height: _height,
          width: _width,
          margin: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Opacity(opacity: 0.88, child: CustomAppBar()),
                clipShape(),
                welcomeTextRow(),
                form(),
                SizedBox(
                  height: _height / 35,
                ),
                button(),
                signInTextRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 8
                  : (_medium ? _height / 7 : _height / 6.5),
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
                  ? _height / 12
                  : (_medium ? _height / 11 : _height / 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [MyTheme.kPrimaryColor, MyTheme.kAccentColor],
                ),
              ),
            ),
          ),
        ),
        Container(
          height: _height / 5.5,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  spreadRadius: 0.0,
                  color: Colors.black26,
                  offset: Offset(1.0, 10.0),
                  blurRadius: 20.0),
            ],
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          /*GestureDetector(
              onTap: (){
                print('Adding photo');
              },

              child: Icon(Icons.add_a_photo, size: _large? 40: (_medium? 33: 31),color: Colors.orange[200],)),*/
          /*child:ClipOval(
                child: Image.asset(
                  'assets/images/user_avatar.png '), 
              )*/

          child: Image.asset('assets/images/user_avatar.png'),
        ),
        Positioned(
          top: _height / 8,
          left: _width / 1.75,
          child: Container(
            alignment: Alignment.center,
            height: _height / 23,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange[100],
            ),
            child: GestureDetector(
                onTap: () {
                  print('Adding photo');
                },
                child: Icon(
                  Icons.add_a_photo,
                  size: _large ? 22 : (_medium ? 15 : 13),
                )),
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
            "Register",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: _large ? 60 : (_medium ? 50 : 40),
                color: MyTheme.kPrimaryColor),
          ),
        ],
      ),
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 20.0),
      child: Form(
        child: Column(
          children: <Widget>[
            nameTextFormField(),
            SizedBox(height: _height / 60.0),
            emailTextFormField(),
            SizedBox(height: _height / 60.0),
            passwordTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget nameTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      icon: Icons.person,
      hint: "Name",
      textEditingController: nameController,
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      icon: Icons.email,
      hint: "Email ID",
      textEditingController: emailController,
    );
  }

  Widget passwordTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      obscureText: true,
      icon: Icons.lock,
      hint: "Password",
      textEditingController: passwordController,
    );
  }

  void registerUser() async {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    User user =
        new User(name: name, email: email, password: password, avatar: avatar);
    // Response response;
    // var dio = Dio();
    // response = await dio.post(
    //   Utils.BASE_URL + "/api/user",
    //   data: jsonEncode(user.toJosn()),
    //   options: Options(headers: {
    //     HttpHeaders.contentTypeHeader: "application/json",
    //   }),
    // );
    var response = await http.post(
      Utils.BASE_URL + "/api/user",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toRegisterJson()),
    );
  }

  Widget button() {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70.0)),
      onPressed: () {
        registerUser();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignInPage()));
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
//        height: _height / 20,
        width: _large ? _width / 2 : (_medium ? _width / 2 : _width / 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          gradient: LinearGradient(
            colors: <Color>[MyTheme.kPrimaryColor, MyTheme.kAccentColor],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'SIGN UP',
          style: TextStyle(fontSize: _large ? 18 : (_medium ? 18 : 16)),
        ),
      ),
    );
  }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Already have an account?",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
              );
              print("Routing to Sign up screen");
            },
            child: Text(
              "Sign in",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.orange[200],
                  fontSize: 17),
            ),
          )
        ],
      ),
    );
  }
}
