import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class User {
  final String firstName;
  final String lastName;
  final String vk;
  final String birthDate;
  final String phone;
  final String skype;
  final String login;
  final String profileImage;

  User(
    this.firstName,
    this.lastName,
    this.vk,
    this.birthDate,
    this.phone,
    this.skype,
    this.login,
    this.profileImage,
  );

  User.fromJson(Map<String, dynamic> json)
      : firstName = json['user'],
        lastName = json['family'],
        vk = json['vk'],
        birthDate = json['bithday'],
        phone = json['phonenumber'],
        skype = json['skype'],
        login = json['login'],
        profileImage = json['img'];
}


class TableCell extends StatelessWidget {
  final String value;

  const TableCell(this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(value == null ? 'Не задано' : value),
      margin: const EdgeInsets.all(10),
    );
  }
}

class Profile extends StatelessWidget {
  final FlutterSecureStorage storage;

  Profile({Key key, @required this.storage}) : super(key: key);

  Future<String> _getToken() async {
    String value = await storage.read(key: 'token');
    return value;
  }

  Future<User> _getUser() async {
    String getUserUrl = 'http://studentapi.myknitu.ru/getuser/';
    Map<String, dynamic> payload = {
      'token': await _getToken(),
    };
    var response = await Dio().post(getUserUrl, data: payload);

    if (response.statusCode == 200) {
      return User.fromJson(response.data);
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
        appBar: AppBar(title: Text('Профиль')),
        body: FutureBuilder(
          future: _getUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: Column(
                  children: [
                    Image.network(snapshot.data.profileImage),
                    SizedBox(height: 10,),
                    Table(
                      border: TableBorder.all(),
                      children: [
                        _makeTableRow('Имя пользователя', snapshot.data.login),
                        _makeTableRow('Имя', snapshot.data.firstName),
                        _makeTableRow('Фамилия', snapshot.data.lastName),
                        _makeTableRow('ВК', snapshot.data.vk),
                        _makeTableRow('Дата рождения', snapshot.data.birthDate),
                        _makeTableRow('Номер телефона', snapshot.data.phone),
                        _makeTableRow('Скайп', snapshot.data.skype),
                      ],
                    ),
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
