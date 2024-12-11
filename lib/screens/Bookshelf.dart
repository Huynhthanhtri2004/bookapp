import 'package:flutter/material.dart';

// Create a simple Book model class for easier data manipulation
class Book {
  String title;
  String author;
  String genre;
  String image;

  Book({
    required this.title,
    required this.author,
    required this.genre,
    required this.image,
  });
}

class Bookshelf extends StatefulWidget {
  const Bookshelf({super.key});

  @override
  State<Bookshelf> createState() => _BookshelfState();
}

class _BookshelfState extends State<Bookshelf> {
  final List<Book> bookshelf = [];

  void _removeBook(int index) {
    setState(() {
      bookshelf.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Sách đã được xóa khỏi kệ!")),
    );
  }

  void _editBook(int index) {
    final book = bookshelf[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Chỉnh sửa sách"),
          content: BookForm(
            initialBook: book,
            onSave: (editedBook) {
              setState(() {
                bookshelf[index] = editedBook;
              });
            },
          ),
        );
      },
    );
  }

  void _addNewBook() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Thêm sách mới"),
          content: BookForm(
            onSave: (newBook) {
              setState(() {
                bookshelf.add(newBook);
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   //title: const Text("Kệ sách"),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.add_circle_sharp),
      //       onPressed: _addNewBook,
      //     ),
      //   ],
      // ),
      body: bookshelf.isEmpty
          ? const Center(
        child: Text(
          "Kệ sách của bạn trống. Hãy thêm sách!",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: bookshelf.length,
        itemBuilder: (context, index) {
          final book = bookshelf[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  book.image,
                  width: 50,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                book.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("${book.author} • ${book.genre}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editBook(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeBook(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:_addNewBook,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Form widget for adding and editing books
class BookForm extends StatefulWidget {
  final Book? initialBook;
  final Function(Book) onSave;

  const BookForm({super.key, this.initialBook, required this.onSave});

  @override
  _BookFormState createState() => _BookFormState();
}

class _BookFormState extends State<BookForm> {
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _genreController;
  late TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialBook?.title ?? '');
    _authorController = TextEditingController(text: widget.initialBook?.author ?? '');
    _genreController = TextEditingController(text: widget.initialBook?.genre ?? '');
    _imageController = TextEditingController(text: widget.initialBook?.image ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _genreController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: 'Tiêu đề'),
        ),
        TextField(
          controller: _authorController,
          decoration: const InputDecoration(labelText: 'Tác giả'),
        ),
        TextField(
          controller: _genreController,
          decoration: const InputDecoration(labelText: 'Thể loại'),
        ),
        TextField(
          controller: _imageController,
          decoration: const InputDecoration(labelText: 'Ảnh (URL)'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            final newBook = Book(
              title: _titleController.text,
              author: _authorController.text,
              genre: _genreController.text,
              image: _imageController.text,
            );
            widget.onSave(newBook);
            Navigator.pop(context);
          },
          child: const Text("Lưu"),
        ),
      ],
    );
  }
}
