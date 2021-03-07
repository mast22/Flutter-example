import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

class SignUpForm extends StatefulWidget {
  final storage = new FlutterSecureStorage();

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final formLogin = TextEditingController();
  final formPassword = TextEditingController();

  void setToken(String token) async {
    await widget.storage.write(key: 'token', value: token);
  }

  signUp(BuildContext context, String login, String password) async {
    var dio = Dio();

    Map payload = {
      "login": login.trim(),
      "password": password.trim(),
    };

    Response response = await dio.post('http://studentapi.myknitu.ru/register/', data: payload);
    if (response.data == 'error') {
      Navigator.pop(context);
    } else {
      String token = response.data['token'];
      setToken(token);
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    formLogin.dispose();
    formPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Регистрация')),
        body: Form(
            child: Padding(
                padding: const EdgeInsets.all(50),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Логин'),
                      controller: formLogin,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Пароль'),
                      obscureText: true,
                      controller: formPassword,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await signUp(context, formLogin.text, formPassword.text);
                        Navigator.pop(context);
                      },
                      child: Text('Регистрация'),
                    ),
                  ],
                ))));
  }
}
