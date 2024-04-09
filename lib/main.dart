import 'package:flutter/material.dart';
import 'package:biblioteca_livros/pages/biblioteca.dart';
import 'package:biblioteca_livros/pages/meusLivros.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(),
    );
  }
}
class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gerenciamento de Livros',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.grey,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Biblioteca',
              style: TextStyle(color: Colors.black45),),
              shape: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
              ), ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Biblioteca()),
                );
              },
            ),
            ListTile(
              title: const Text('Meus Livros', style: TextStyle(color: Colors.black45),),
              shape: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 1.0
                )
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyBooks()),
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.grey[300],
      ),
      body: Container(
        color: Colors.grey[300], // Fundo cinza suavizado
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text(
                'Bem-vindo ao seu programa de gerenciamento de livros',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}