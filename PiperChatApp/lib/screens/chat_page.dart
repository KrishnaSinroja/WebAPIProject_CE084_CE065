import 'package:piperchatapp/models/message_model.dart';
import 'package:signalr_client/hub_connection.dart';

import '../widgets/widgets.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final Map<int, List<Message>> userMessages;
  final HubConnection hubConnection;
  const ChatPage({
    Key key,
    this.userMessages,
    this.hubConnection
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          RecentChats(userMessages: userMessages,hubConnection: hubConnection,),
          //AllChats(),
        ],
      ),
    );
  }
}
