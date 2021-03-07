import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/src/chat.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Contact {
  final int id;
  final String profilePicture;
  final String lastName;
  final String vk;
  final String birthDate;
  final String phoneNumber;
  final String firstName;
  final String skype;

  Contact(this.id, this.profilePicture, this.lastName, this.vk, this.birthDate,
      this.phoneNumber, this.firstName, this.skype);

  Contact.fromJson(Map<String, dynamic> json)
      : id = json['id_user'],
        profilePicture = json['img'],
        lastName = json['family'],
        firstName = json['user'],
        birthDate = json['birthday'],
        phoneNumber = json['phonenumber'],
        vk = json['vk'],
        skype = json['skype'];
}

class TableCell extends StatelessWidget {
  final String value;

  const TableCell(this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(value == null || value == "" ? 'Не задано' : value),
      margin: const EdgeInsets.all(10),
    );
  }
}

class ContactDetail extends StatelessWidget {
  final int contactId;
  final storage = new FlutterSecureStorage();

  ContactDetail(this.contactId);

  Future<String> _getToken() async {
    String value = await storage.read(key: 'token');
    return value;
  }

  Future<Contact> _getContact() async {
    String getUserUrl = 'http://studentapi.myknitu.ru/getuserwithid/';
    Map<String, dynamic> payload = {
      'token': await _getToken(),
      'userid': contactId,
    };
    var response = await Dio().post(getUserUrl, data: payload);

    if (response.statusCode == 200) {
      return Contact.fromJson(response.data);
    } else {
      throw Exception('Ошибка при запросе к сервису');
    }
  }

  TableRow _makeTableRow(String title, String value) {
    return TableRow(
      children: [
        TableCell(title),
        TableCell(value),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Контакт')),
        body: FutureBuilder(
          future: _getContact(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: Column(
                  children: [
                    Image.network(snapshot.data.profilePicture),
                    SizedBox(
                      height: 10,
                    ),
                    Table(
                      border: TableBorder.all(),
                      children: [
                        _makeTableRow('Имя', snapshot.data.firstName),
                        _makeTableRow('Фамилия', snapshot.data.lastName),
                        _makeTableRow('ВК', snapshot.data.vk),
                        _makeTableRow('Дата рождения', snapshot.data.birthDate),
                        _makeTableRow(
                            'Номер телефона', snapshot.data.phoneNumber),
                        _makeTableRow('Скайп', snapshot.data.skype),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Chat(chatWithId: snapshot.data.id)));
                        },
                        child: Text('Перейти к чату')),
                  ],
                ),
                margin: const EdgeInsets.all(10),
              );
            } else {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
          },
        ));
  }
}
