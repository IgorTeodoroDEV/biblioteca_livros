import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Book {
  final String name;
  final String imageUrl;

  Book({required this.name, required this.imageUrl});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: meusLivros(),
    );
  }
}

class meusLivros extends StatelessWidget {
  final List<Book> books = [
    Book(name: 'Livro 1', imageUrl: ''),
    Book(name: 'Livro 2', imageUrl: 'https://via.placeholder.com/150'),
    Book(name: 'Livro 3', imageUrl: 'https://via.placeholder.com/150'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Livros', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey,
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(book.imageUrl),
            ),
            title: Text(book.name),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Remover o livro da lista
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Remover Livro'),
                      content: Text('Tem certeza que deseja remover ${book.name}?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            // Remover o livro da lista
                            books.removeAt(index);
                            // Atualizar a interface
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('${book.name} removido da lista.'),
                              duration: Duration(seconds: 2),
                            ));
                          },
                          child: Text('Remover'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}