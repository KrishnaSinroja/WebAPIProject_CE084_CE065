import 'dart:convert';

import './user_model.dart';

class Message {
  int messageId;
  User sender;
  User receiver;
  int senderId;
  int receiverId;
  String avatar;
  String time;
  int unreadCount;
  bool isRead;
  String text;
  String simpleText;
  Message({
    this.sender,
    this.avatar,
    this.time,
    this.unreadCount,
    this.text,
    this.isRead,
    this.senderId,
    this.receiverId,
    this.simpleText
  });


  Map<String, dynamic> toJson(){
    return {
      "SenderId":senderId,
      "ReceiverId":receiverId,
      "Message1":text,
      "MessageTime":time,
      "Avatar":avatar,
      "sender":sender.toJosn()
    };
  }

  Message.fromJson(Map<String, dynamic> json):
     senderId = json['SenderId'],
     receiverId = json['ReceiverId'],
     text = json['Message1'],
     time = json['MessageTime'],
     avatar = json['Avatar'],
     sender = User.fromJson(json['sender']);
}

List<Message> recentChats = [
  Message(
    sender: addison,
    avatar: 'assets/images/Addison.jpg',
    time: DateTime.now().toIso8601String(),
    text: "typing...",
    unreadCount: 1,
  ),
  Message(
    sender: jason,
    avatar: 'assets/images/Jason.jpg',
    time: DateTime.now().toIso8601String(),
    text: "Will I be in it?",
    unreadCount: 1,
  ),
  Message(
    sender: deanna,
    avatar: 'assets/images/Deanna.jpg',
    time: DateTime.now().toIso8601String(),
    text: "That's so cute.",
    unreadCount: 3,
  ),
  Message(
      sender: nathan,
      avatar: 'assets/images/Nathan.jpg',
      time: DateTime.now().toIso8601String(),
      text: "Let me see what I can do.",
      unreadCount: 2),
];

List<Message> allChats = [
  Message(
    sender: virgil,
    avatar: 'assets/images/Virgil.jpg',
    time: '12:59',
    text: "No! I just wanted",
    unreadCount: 0,
    isRead: true,
  ),
  Message(
    sender: stanley,
    avatar: 'assets/images/Stanley.jpg',
    time: '10:41',
    text: "You did what?",
    unreadCount: 1,
    isRead: false,
  ),
  Message(
    sender: leslie,
    avatar: 'assets/images/Leslie.jpg',
    time: '05:51',
    unreadCount: 0,
    isRead: true,
    text: "just signed up for a tutor",
  ),
  Message(
    sender: judd,
    avatar: 'assets/images/Judd.jpg',
    time: '10:16',
    text: "May I ask you something?",
    unreadCount: 2,
    isRead: false,
  ),
];

final List<Message> messages = [
  Message(
    sender: addison,
    time: '12:09 AM',
    avatar: addison.avatar,
    text: "...",
  ),
  Message(
    sender: currentUser,
    time: '12:05 AM',
    isRead: true,
    text: "I’m going home.",
  ),
  Message(
    sender: currentUser,
    time: '12:05 AM',
    isRead: true,
    text: "See, I was right, this doesn’t interest me.",
  ),
  Message(
    sender: addison,
    time: '11:58 PM',
    avatar: addison.avatar,
    text: "I sign your paychecks.",
  ),
  Message(
    sender: addison,
    time: '11:58 PM',
    avatar: addison.avatar,
    text: "You think we have nothing to talk about?",
  ),
  Message(
    sender: currentUser,
    time: '11:45 PM',
    isRead: true,
    text:
        "Well, because I had no intention of being in your office. 20 minutes ago",
  ),
  Message(
    sender: addison,
    time: '11:30 PM',
    avatar: addison.avatar,
    text: "I was expecting you in my office 20 minutes ago.",
  ),
];
