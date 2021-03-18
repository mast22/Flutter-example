import 'package:flutter/material.dart';
import 'User.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final storage = new FlutterSecureStorage();

  final TextEditingController _nameuser = TextEditingController();
  final TextEditingController _family = TextEditingController();
  final TextEditingController _birthday = TextEditingController();
  final TextEditingController _phonenumber = TextEditingController();
  final TextEditingController _vk = TextEditingController();
  final TextEditingController _skype = TextEditingController();

  Future<String> _getToken() async {
    String value = await storage.read(key: 'token');
    return value;
  }

  _updateProfile() async {
    String updateProfileUrl = 'http://studentapi.myknitu.ru/userupdate/';
    var dio = Dio();
    var payload = {
      'token': await _getToken(),
      "nameuser": _nameuser.text,
      "family": _family.text,
      "birthday": _birthday.text,
      "phonenumber": _phonenumber.text,
      "vk": _vk.text,
      "skype": _skype.text
    };
    print(payload);
    await dio.post(updateProfileUrl, data: payload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Редактировать профиль')),
        body: Form(
            key: _formKey,
            child: Container(
                padding: EdgeInsets.all(30),
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nameuser,
                      decoration: InputDecoration(labelText: 'Имя'),
                    ),
                    TextFormField(
                      controller: _family,
                      decoration: InputDecoration(labelText: 'Фамилия'),
                    ),
                    TextFormField(
                      controller: _birthday,
                      decoration: InputDecoration(labelText: 'День рождения'),
                    ),
                    TextFormField(
                      controller: _phonenumber,
                      decoration: InputDecoration(labelText: 'Номер телефона'),
                    ),
                    TextFormField(
                      controller: _vk,
                      decoration: InputDecoration(labelText: 'ВК'),
                    ),
                    TextFormField(
                      controller: _skype,
                      decoration: InputDecoration(labelText: 'Скайп'),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await _updateProfile();
                        },
                        child: Text('Сохранить'))
                  ],
                ))));
  }
}
