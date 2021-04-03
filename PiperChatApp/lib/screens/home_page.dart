import 'dart:convert';

import 'package:piperchatapp/models/message_model.dart';
import 'package:piperchatapp/models/user_model.dart';
import 'package:piperchatapp/screens/all_chat_page.dart';
import 'package:piperchatapp/utils/utils.dart';
import 'package:signalr_client/hub_connection.dart';
import 'package:signalr_client/hub_connection_builder.dart';

import '../app_theme.dart';
import 'package:flutter/material.dart';
import '../widgets/widgets.dart';
import '../screens/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  TabController tabController;
  int currentTabIndex = 0;
  //final serverUrl = "http://10.0.2.2:5000/chatHub";
  final serverUrl = "http://192.168.43.99:5000/chatHub";
  HubConnection hubConnection;
  User _currentUser;
  Map<int, List<Message>> userMessages = new Map<int, List<Message>>();

  void onTabChange() {
    setState(() {
      currentTabIndex = tabController.index;
      print(currentTabIndex);
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    tabController = TabController(length: 2, vsync: this);

    tabController.addListener(() {
      onTabChange();
    });
    super.initState();
    initSignalR();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      await hubConnection.invoke(
        "UserDisconnected",
        args: <Object>[
          jsonEncode(_currentUser.toJosn()),
        ],
      );
      return;
    }
    if (state == AppLifecycleState.resumed) {
      await _userOnline();
      return;
    }
  }

  getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var json = jsonDecode(prefs.getString(Utils.CURRENT_USER));
    _currentUser = User.fromJson(json);
  }

  void initSignalR() async {
    hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();
    _setClientMethods();
    await hubConnection.start();
    await getCurrentUser();
    await _userOnline();
  }

  _userOnline() async {
    await hubConnection.invoke(
      "UserConnected",
      args: <Object>[
        jsonEncode(_currentUser.toJosn()),
      ],
    );
  }

  _setClientMethods() {
    hubConnection.onclose((error) => print("Connection closed"));
    hubConnection.on("ReceiveMessage", _messageReceived);
    hubConnection.on("NewUserConnected", _newUserConnected);
    hubConnection.on("NotifyToOthers", _notifyToOthers);
    hubConnection.on("NotifyToOthersDisconnect", _notifyToOthersDisconnect);
  }

  _notifyToOthersDisconnect(List<Object> args) {
    User newUser = User.fromJson(jsonDecode(args[0]));
    recentChats.removeWhere(
        (message) => message.sender.chatUserId == newUser.chatUserId);
    userMessages.remove(newUser.chatUserId);
    setState(() {});
  }

  _notifyToOthers(List<Object> args) {
    User newUser = User.fromJson(jsonDecode(args[0]));
    recentChats.firstWhere(
        (message) => message.sender.chatUserId == newUser.chatUserId,
        orElse: () {
      return;
    });

    userMessages[newUser.chatUserId] = [];
    Message message = new Message(
      sender: newUser,
      avatar: newUser.avatar,
      text: "Online",
      isRead: true,
      time: DateTime.now().toString(),
      unreadCount: 0,
    );
    setState(() {
      recentChats.add(message);
    });
  }

  _newUserConnected(List<Object> args) {
    Map<String, dynamic> onlineUsers = jsonDecode(args[0]);
    List<Message> messageList = [];
    for (Map<String, dynamic> user in onlineUsers.values) {
      User newUser = User.fromJson(jsonDecode(jsonEncode(user)));
      Message message = new Message(
        sender: newUser,
        avatar: newUser.avatar,
        text: "Online",
        isRead: true,
        time: DateTime.now().toString(),
        unreadCount: 0,
      );
      userMessages[newUser.chatUserId] = [];
      messageList.add(message);
    }
    setState(() {
      //recentChats.addAll(messageList);
      recentChats = messageList;
    });
  }

  _messageReceived(List<Object> args) {
    print(args[0]);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    tabController.addListener(() {
      onTabChange();
    });

    tabController.dispose();

    super.dispose();
  }

  Future<List<Message>> _getAllUsers() async {
    List<Message> allUsers = [];
    allUsers.addAll(allChats);

    var response = await http.get(Utils.BASE_URL+"/api/user");
    if(response.statusCode == 200){
      var json = jsonDecode(response.body);
      for(var row in json){
        User tempUser = User.fromUserJson(row);
        Message message = new Message(sender: tempUser, avatar: tempUser.avatar);
        allUsers.add(message);
      }
    }
    return allUsers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading: IconButton(
          //   onPressed: () {},
          //   icon: Icon(Icons.menu),
          // ),
          automaticallyImplyLeading: false,
          title: Align(
            alignment: Alignment.center,
            child: Text(
              'Piper Chat',
              style: MyTheme.kAppTitle,
            ),
          ),
          actions: [
            // IconButton(
            //   icon: Icon(Icons.camera_alt),
            //   onPressed: () {},
            // )
          ],
          elevation: 0,
        ),
        backgroundColor: MyTheme.kPrimaryColor,
        body: Column(
          children: [
            MyTabBar(tabController: tabController),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )),
                child: TabBarView(
                  controller: tabController,
                  children: [
                    ChatPage(
                      userMessages: userMessages,
                      hubConnection: hubConnection,
                    ),
                    FutureBuilder(
                        future: _getAllUsers(),
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? AllUserPage(
                                  allUsers: snapshot.data as List<Message>,
                                  hubConnection: hubConnection,
                                )
                              : CircularProgressIndicator();
                        }),
                    //Center(child: Text('Call')),
                  ],
                ),
              ),
            )
          ],
        )

        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     // await hubConnection.start();
        //     if (hubConnection.state == HubConnectionState.Connected) {
        //       await hubConnection
        //           .invoke("SendMessageToServer", args: <Object>["hello"]);
        //     }
        //   },
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(15),
        //   ),
        //   child: Icon(
        //     currentTabIndex == 0
        //         ? Icons.message_outlined
        //         : currentTabIndex == 1
        //             ? Icons.camera_alt
        //             : Icons.call,
        //     color: Colors.white,
        //   ),
        // ),
        );
  }
}
