import 'dart:convert';

import 'package:piperchatapp/models/message_model.dart';
import 'package:piperchatapp/utils/RSA.dart';
import 'package:piperchatapp/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_client/hub_connection.dart';

import '../app_theme.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../widgets/widgets.dart';
import 'package:pointycastle/api.dart' as crypto;

class ChatRoom extends StatefulWidget {
  ChatRoom(
      {Key key, @required this.sender, this.messageList, this.hubConnection})
      : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
  final User sender;
  List<Message> messageList;
  HubConnection hubConnection;
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController messageController = new TextEditingController();
  User _currentUser;
  crypto.PrivateKey privateKey;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _setMethods();
    _getPrivateKey();
  }

  _getPrivateKey() async{
   
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String private = preferences.getString(Utils.PRIVATE_KEY);
    privateKey = RSA.getPrivateKey(private);
  }

  _setMethods() {
    widget.hubConnection.on("ReceiveMessage", _receiveMessage);
  }

  _receiveMessage(List<Object> args) {
    print("Received "+args[0]);
    Message message = Message.fromJson(jsonDecode(args[0]));
    message.text = RSA.decrypt(message.text, privateKey);
    message.simpleText = message.text;
    widget.messageList.add(message);
    if (mounted) {
      setState(() {});
    }
  }

  getCurrentUser() async {
    print("Receiver = "+widget.sender.name);
    print("Receiver public key = "+widget.sender.publicKey);
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var json = jsonDecode(prefs.getString(Utils.CURRENT_USER));
    _currentUser = User.fromJson(json);
    print("Sender = "+_currentUser.name);
  }

  void sendMessage() {
    crypto.PublicKey publicKey = RSA.getPublicKey(widget.sender.publicKey);
    String cipher = RSA.encrypt(messageController.text, publicKey); 
    Message message = new Message(
      sender: _currentUser,
      senderId: _currentUser.chatUserId,
      receiverId: widget.sender.chatUserId,
      time: DateTime.now().toIso8601String(),
      avatar: _currentUser.avatar,
      text: cipher,
      simpleText: messageController.text
    );

    sendToServer(message);
    setState(() {
      messageController.text = "";
      widget.messageList.add(message);
    });
  }

  sendToServer(Message message) async {
    await widget.hubConnection
        .invoke("SendMessage", args: <Object>[jsonEncode(message.toJson())]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(
                widget.sender.avatar,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.sender.name,
                  style: MyTheme.chatSenderName,
                ),
                Text(
                  'online',
                  style: MyTheme.bodyText1.copyWith(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // IconButton(
          //     icon: Icon(
          //       Icons.videocam_outlined,
          //       size: 28,
          //     ),
          //     onPressed: () {}),
          // IconButton(
          //     icon: Icon(
          //       Icons.call,
          //       size: 28,
          //     ),
          //     onPressed: () {})
        ],
        elevation: 0,
      ),
      backgroundColor: MyTheme.kPrimaryColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: Conversation(
                    user: widget.sender, messageList: widget.messageList),
              ),
            ),
          ),
          buildChatComposer(
              messageController: messageController, sendMessage: sendMessage),
        ]),
      ),
    );
  }
}
