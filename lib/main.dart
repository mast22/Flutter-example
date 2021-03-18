import 'package:flutter/material.dart';
import 'file:///D:/projects/flutter/flutter_app/lib/src/gallery/gallery.dart';
import 'dart:io';
import 'src/profile/profile.dart';
import 'src/contacts.dart';
import 'src/account/signin.dart';
import 'src/account/signup.dart';
import 'src/common.dart';
import 'src/gallery/upload_photo.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MaterialApp(
    title: "Navigation example",
    home: HomeRoute(),
  ));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class HomeRoute extends StatelessWidget {
  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Главное меню')),
      body: ListView(
        children: <Widget>[
          CommonWidgets.buildTile(context, 'Галерея', Gallery()),
          CommonWidgets.buildTile(context, 'Добавить фото', UploadPhoto()),
          CommonWidgets.buildTile(context, 'Профиль', Profile()),
          CommonWidgets.buildTile(context, 'Контакты', Contacts()),
          CommonWidgets.buildTile(context, 'Войти', SignInForm()),
          CommonWidgets.buildTile(context, 'Регистрация', SignUpForm()),
          ListTile(
            title: Text('Выйти из аккаунта'),
            onTap: () async { await storage.delete(key: 'token'); },
          )
        ],
      ),
    );
  }
}
