import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../src/contact.dart';

class ContactTile extends StatelessWidget {
  final Map<String, dynamic> contact;

  ContactTile(this.contact);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${contact['id']} ${contact['user']}'),
      leading: ConstrainedBox(
        constraints: BoxConstraints(
            minHeight: 44, minWidth: 44, maxWidth: 44, maxHeight: 44),
        child: Image.network(contact['img']),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ContactDetail(contact['id'])));
      },
    );
  }
}

class Contacts extends StatelessWidget {
  final storage = new FlutterSecureStorage();

  Future<String> _getToken() async {
    String value = await storage.read(key: 'token');
    return value;
  }

  Future<Map<String, dynamic>> _getContacts() async {
    String getContactsUrl = 'http://studentapi.myknitu.ru/listusers/';
    Map<String, dynamic> payload = {
      'token': await _getToken(),
    };
    var response = await Dio().post(getContactsUrl, data: payload);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Ошибка при запросе к сервису');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Список контактов')),
      body: FutureBuilder(
        future: _getContacts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List contacts = snapshot.data['users'];
            return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  return ContactTile(contacts[index]);
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
