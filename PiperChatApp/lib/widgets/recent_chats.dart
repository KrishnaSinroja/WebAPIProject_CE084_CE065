import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:signalr_client/hub_connection.dart';
import '../models/message_model.dart';
import '../screens/screen.dart';

import '../app_theme.dart';

class RecentChats extends StatelessWidget {
    final Map<int, List<Message>> userMessages;
    final HubConnection hubConnection;
  const RecentChats({
    Key key,
    this.userMessages,
    this.hubConnection
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 30),
          child: Row(
            children: [
              Text(
                'Recent Chats',
                style: MyTheme.heading2,
              ),
              Spacer(),
              // Icon(
              //   Icons.search,
              //   color: MyTheme.kPrimaryColor,
              // )
            ],
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: recentChats.length,
            itemBuilder: (context, int index) {
              final recentChat = recentChats[index];
              return Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage(recentChat.avatar),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) {
                            return ChatRoom(
                              sender: recentChat.sender,
                              messageList: userMessages[recentChat.sender.chatUserId],
                              hubConnection: hubConnection,
                            );
                          }));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              recentChat.sender.name,
                              style: MyTheme.heading2.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              recentChat.text,
                              style: MyTheme.bodyText1,
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // CircleAvatar(
                          //   radius: 8,
                          //   backgroundColor: MyTheme.kUnreadChatBG,
                          //   child: Text(
                          //     recentChat.unreadCount.toString(),
                          //     style: TextStyle(
                          //         color: Colors.white,
                          //         fontSize: 11,
                          //         fontWeight: FontWeight.bold),
                          //   ),
                          // ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            DateFormat.jm().format(DateTime.parse(recentChat.time)).toString(),
                            style: MyTheme.bodyTextTime,
                          )
                        ],
                      ),
                    ],
                  ));
            })
      ],
    );
  }
}
