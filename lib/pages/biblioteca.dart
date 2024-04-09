import 'package:biblioteca_livros/models/favorites.dart';
import 'package:biblioteca_livros/service/sqlite_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Biblioteca(),
    );
  }
}

class Biblioteca extends StatefulWidget {
  @override
  _BibliotecaState createState() => _BibliotecaState();
}

class _BibliotecaState extends State<Biblioteca> {
  Map<String, List<Book>> categorizedBooks = {};
  TextEditingController searchController = TextEditingController();

  late SqliteService _sqliteService;

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
        title: Text(
          'Categorias de Livros',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Pesquisar Livros...',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _searchBooks(searchController.text);
                  },
                  child: Text(
                    'Pesquisar',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: categorizedBooks.keys.map((categoryName) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCategory(categoryName),
                    _buildSlideshow(categorizedBooks[categoryName]!),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(String categoryName) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        categoryName,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSlideshow(List<Book> books) {
    return Container(
      height: 200.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                _addToFavorites(context, book, index);
              },
              child: Card(
                child: Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 120.0,
                        width: 150.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(book.imageUrl),
                              alignment: Alignment.center),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(7.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(book.author),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _addToFavorites(BuildContext context, Book book, index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text('${book.title}'),
            content: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image(image: NetworkImage(book.imageUrl)),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Sinopse',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                Text('${book.synopsis}'),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Deseja adicionar este livro aos favoritos?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                      fontSize: 17,
                      color: const Color.fromARGB(255, 250, 77, 64)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _sqliteService.createItem(Favorite(
                      id: index,
                      name: book.title,
                      sinopse: book.synopsis,
                      img: book.imageUrl));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        '${book?.title ?? ""} foi adicionado aos favoritos.'),
                    duration: Duration(seconds: 2),
                  ));
                },
                child: Text(
                  'Adicionar',
                  style: TextStyle(fontSize: 17, color: Colors.green),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _searchBooks(String query) async {
    try {
      final fetchedBooks = await GoogleBooksAPI.searchBooks(query);
      final Map<String, List<Book>> categorized = {};

      fetchedBooks.forEach((book) {
        final categories = book.categories ?? ['Outros'];
        categories.forEach((category) {
          if (categorized.containsKey(category)) {
            categorized[category]!.add(book);
          } else {
            categorized[category] = [book];
          }
        });
      });

      setState(() {
        categorizedBooks = categorized;
      });
    } catch (e) {
      print('Erro ao carregar os livros: $e');
    }
  }
}

class Book {
  final String title;
  final String author;
  final String imageUrl;
  final String synopsis; // Adicionando campo para a sinopse
  final List<String>? categories;

  Book({
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.synopsis,
    this.categories,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['volumeInfo']['title'],
      author: json['volumeInfo']['authors'] != null
          ? json['volumeInfo']['authors'].join(', ')
          : 'Autor Desconhecido',
      imageUrl: json['volumeInfo']['imageLinks'] != null
          ? json['volumeInfo']['imageLinks']['thumbnail']
          : 'https://png.pngtree.com/png-vector/20230912/ourmid/pngtree-closed-and-open-books-background-png-image_9567348.png',
      synopsis: json['volumeInfo']['description'] != null
          ? json['volumeInfo']['description']
          : 'Sinopse não disponível',
      categories: json['volumeInfo']['categories'] != null
          ? List<String>.from(json['volumeInfo']['categories'])
          : null,
    );
  }
}

class GoogleBooksAPI {
  static Future<List<Book>> searchBooks(String query) async {
    final String apiUrl =
        'https://www.googleapis.com/books/v1/volumes?q=$query';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<Book> fetchedBooks = [];

      for (var item in data['items']) {
        final book = Book.fromJson(item);
        fetchedBooks.add(book);
      }

      return fetchedBooks;
    } else {
      throw Exception('Erro ao carregar os livros');
    }
  }
}
