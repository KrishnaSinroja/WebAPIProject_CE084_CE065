import 'package:intl/intl.dart';

import '../models/message_model.dart';
import '../models/user_model.dart';
import '../app_theme.dart';
import 'package:flutter/material.dart';

class Conversation extends StatelessWidget {
  const Conversation({
    Key key,
    @required this.user,
    this.messageList
  }) : super(key: key);

  final User user;
  final List<Message> messageList;
  @override
  Widget build(BuildContext context) {
    messageList.sort((a, b){
      DateTime ad = DateTime.parse(a.time);
      DateTime bd = DateTime.parse(b.time);
      return bd.compareTo(ad);
    });
    return ListView.builder(
        reverse: true,
        itemCount: messageList.length,
        itemBuilder: (context, int index) {
          final message = messageList[index];
          bool isMe = message.sender.chatUserId != user.chatUserId;
          return Container(
            margin: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment:
                      isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (!isMe)
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: AssetImage(message.sender.avatar),
                      ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.6),
                      decoration: BoxDecoration(
                          color: isMe ? MyTheme.kAccentColor : Colors.grey[200],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                            bottomLeft: Radius.circular(isMe ? 12 : 0),
                            bottomRight: Radius.circular(isMe ? 0 : 12),
                          )),
                      child: Text(
                        messageList[index].simpleText,
                        style: MyTheme.bodyTextMessage.copyWith(
                            color: isMe ? Colors.white : Colors.grey[800]),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment:
                        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      if (!isMe)
                        SizedBox(
                          width: 40,
                        ),
                      Icon(
                        Icons.done_all,
                        size: 20,
                        color: MyTheme.bodyTextTime.color,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        DateFormat.jm().format(DateTime.parse(message.time)),
                        style: MyTheme.bodyTextTime,
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
