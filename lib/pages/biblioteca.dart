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

  @override
  void initState() {
    super.initState();
    _searchBooks("flutter");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorias de Livros'),
      ),
      body: ListView(
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
                _addToFavorites(context, book);
              },
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 120.0,
                      width: 120.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(book.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(book.author),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _addToFavorites(BuildContext context, Book book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar aos Favoritos'),
          content: Text('Deseja adicionar "${book.title}" aos favoritos?'),
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
                // Adicione a lógica para adicionar aos favoritos aqui
              },
              child: Text('Adicionar'),
            ),
          ],
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
  final List<String>? categories;

  Book({
    required this.title,
    required this.author,
    required this.imageUrl,
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
          : 'https://via.placeholder.com/150',
      categories: json['volumeInfo']['categories'] != null
          ? List<String>.from(json['volumeInfo']['categories'])
          : null,
    );
  }
}

class GoogleBooksAPI {
  static Future<List<Book>> searchBooks(String query) async {
    final String apiUrl = 'https://www.googleapis.com/books/v1/volumes?q=$query';

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
