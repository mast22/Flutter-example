import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchAlbum() async {
  final response = await http.get('https://studentapi.myknitu.ru/');

  if (response.statusCode == 200) {
    return jsonDecode(response.body)['images'];
  } else {
    throw Exception('Проблема с доступом к серверу');
  }
}

class _GalleryState extends State<Gallery> {
  Future<List<dynamic>> futureImages;

  @override
  void initState() {
    super.initState();

    futureImages = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Галерея')),
      body: FutureBuilder<List<dynamic>>(
          future: futureImages,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                itemCount: snapshot.data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                itemBuilder: (context, index) {
                  return Image.network(
                    snapshot.data[index]['img'],
                    fit: BoxFit.cover,
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Ошибка при запросе' + snapshot.error.toString());
            }
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}
