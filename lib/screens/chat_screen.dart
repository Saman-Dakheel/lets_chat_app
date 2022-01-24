import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_chat/screens/welcome_screen.dart';

final _firestore = FirebaseFirestore.instance;
late User _user;

class ChatScreen extends StatefulWidget {
  static const String routes = 'chat_screen';
  const ChatScreen({Key? key}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String? messageText;
  @override
  void initState() {
    getCurrentUser();

    super.initState();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        _user = user;
        print(_user);
      }
    } catch (e) {
      print(e);
    }
  }

  // void getmessage() async {
  //   final messages = await _firestore.collection('messages').get();
  //   for (var message in messages.docs) {
  //     print(message.data());
  //   }
  // }

  void messageStream() async {
    await for (var snapshot in _firestore.collection('message').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow[800]!,
          title: Row(children: [
            Image.asset(
              'image/logo.png',
              height: 25.0,
            ),
            const SizedBox(
              width: 8,
            ),
            const Text(
              "Let's Chat",
            ),
          ]),
          actions: [
            IconButton(
              onPressed: () {
                _auth.signOut();
                Navigator.of(context).pushNamed(WelcomeScreen.routes);
              },
              icon: const Icon(Icons.close),
            )
          ],
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const BuildMessage(),
              Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.orange,
                        width: 2.0,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageTextController,
                          onChanged: (newValue) {
                            messageText = newValue;
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 20.0,
                            ),
                            hintText: 'Write a message here....',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      TextButton(
                        child: Text(
                          'Send',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                        onPressed: () {
                          messageTextController.clear();
                          _firestore.collection('messages').add({
                            'text': messageText,
                            'email': _user.email,
                            'time': FieldValue.serverTimestamp(),
                          });
                        },
                      )
                    ],
                  )),
            ],
          ),
        ));
  }
}

class Message extends StatelessWidget {
  final String? messageText;
  final String? messageSender;
  final bool isMe;
  const Message(
      {Key? key, required this.isMe, this.messageText, this.messageSender})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$messageSender',
            style: TextStyle(
              color: Colors.yellow[900],
            ),
          ),
          Material(
            elevation: 10,
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
            color: isMe ? Colors.orange[900] : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Text(
                '$messageText',
                style: TextStyle(
                  fontSize: 16,
                  color: isMe ? Colors.white : Colors.orange[900],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BuildMessage extends StatelessWidget {
  const BuildMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('time').snapshots(),
      builder: (context, snapshot) {
        List<Message> messageWidgets = [];

        if (!snapshot.hasData) {
          return const Center(
            child: Text(
              'No message yet',
            ),
          );
        }
        final messages = snapshot.data!.docs.reversed;
        for (var message in messages) {
          final messageText = message.get('text');
          final messageSender = message.get('email');
          final currentUser = _user.email;

          final messageWidget = Message(
            isMe: currentUser == messageSender,
            messageText: messageText,
            messageSender: messageSender,
          );
          messageWidgets.add(messageWidget);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20.0),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}
