import 'package:piperchatapp/models/message_model.dart';
import 'package:signalr_client/hub_connection.dart';

import '../widgets/widgets.dart';
import 'package:flutter/material.dart';

class AllUserPage extends StatelessWidget {
  List<Message> allUsers;
  HubConnection hubConnection;
  
  AllUserPage({
    Key key,
    this.allUsers,
    this.hubConnection
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          //RecentChats(userMessages: userMessages,hubConnection: hubConnection,),
          AllChats(allUsers),
        ],
      ),
    );
  }
}
