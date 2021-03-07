import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MessageTile extends StatelessWidget {
  final Map<String, dynamic> message;

  MessageTile(this.message);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(
      title: Text(message['message']),
      subtitle: Text(message['datetime']),
    );
  }
}

class Chat extends StatelessWidget {
  final storage = new FlutterSecureStorage();
  final int chatWithId;

  Chat({Key key, @required this.chatWithId}) : super(key: key);

  Future<String> _getToken() async {
    String value = await storage.read(key: 'token');
    return value;
  }

  Future<List> _getChatMessages() async {
    var chatUrl = 'http://studentapi.myknitu.ru/getdialog/';
    var payload = {
      'token': await _getToken(),
      'userto': chatWithId,
    };

    var response = await Dio().post(chatUrl, data: payload);

    if (response.statusCode == 200) {
      return response.data['messages'];
    } else {
      throw Exception('Ошибка запроса к серверу');
    }
  }

  FutureBuilder _makeMessagesArea() {
    return FutureBuilder(
        future: _getChatMessages(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0) {
              return Center(child: Text('Нет сообщений'));
            }
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return MessageTile(snapshot.data[index]);
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Чат'),
        ),
        body: new Builder(builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                flex: 9,
                child: _makeMessagesArea(),
              ),
              Expanded(
                flex: 1,
                child: ChatInput(chatWithId: chatWithId),
              ),
            ],
          );
        }));
  }
}

class ChatInput extends StatefulWidget {
  final int chatWithId;

  ChatInput({Key key, @required this.chatWithId}) : super(key: key);

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final textField = TextEditingController();

  Future<String> _getToken() async {
    final storage = new FlutterSecureStorage();
    String value = await storage.read(key: 'token');
    return value;
  }

  Future<List> _sendMessage(String text) async {
    var chatUrl = 'http://studentapi.myknitu.ru/sendmessage/';
    var payload = {
      'token': await _getToken(),
      'userto': widget.chatWithId,
      'message': text,
    };

    var response = await Dio().post(chatUrl, data: payload);

    if (response.statusCode == 200) {
      return response.data['messages'];
    } else {
      throw Exception('Ошибка запроса к серверу');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Row(
        children: [
          Expanded(
              flex: 9,
              child: TextFormField(
                controller: textField,
              )),
          Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () async {
                  await _sendMessage(textField.text);
                },
                child: Icon(Icons.send),
              )),
        ],
      ),
    );
  }
}
