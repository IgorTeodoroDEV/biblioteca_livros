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
    Book(name: 'Livro 1', imageUrl: 'data:image/jpeg;base64,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'),
    Book(name: 'Livro 2', imageUrl: 'https://via.placeholder.com/150'),
    Book(name: 'Livro 3', imageUrl: 'https://via.placeholder.com/150'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Livros'),
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