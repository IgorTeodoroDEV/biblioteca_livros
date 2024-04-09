import 'package:biblioteca_livros/models/favorites.dart';
import 'package:biblioteca_livros/service/sqlite_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyBooks());
}

class Book {
  final String name;
  final String imageUrl;

  Book({required this.name, required this.imageUrl});
}

class MyBooks extends StatefulWidget {
  @override
  _MyBooks createState() => _MyBooks();
}

class _MyBooks extends State<MyBooks> {
  late SqliteService _sqliteService;

  late List<Favorite> _favorites;

  @override
  void initState() {
    super.initState();
    _sqliteService = SqliteService();
    _sqliteService.initializeDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Livros', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey,
      ),
      body: FutureBuilder(
        future: _sqliteService.getItems(),
        builder: (context, snapshot) => ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            final book = snapshot.data?[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(book?.img ?? ""),
              ),
              title: Text(book?.name ?? ""),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Remover o livro da lista
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Remover Livro'),
                        content: Text(
                            'Tem certeza que deseja remover ${book?.name ?? ""}?'),
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
                              final id = book?.id ?? 0;
                              _sqliteService.deleteItem(id.toString());

                              Navigator.of(context).pop();
                              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyBooks()),
                );
                              // Atualizar a interface
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    '${book?.name ?? ""} removido da lista.'),
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
      ),
    );
  }
}
