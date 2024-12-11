import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/BookCard.dart';
import '../services/FirestoreService.dart';
import 'Bookshelf.dart';
import 'Profile.dart';
import 'SearchScreen.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<String> imageUrls = [
    "https://sachgiaokhoa.vn/pub/media/catalog/product/cache/3bd4b739bad1f096e12e3a82b40e551a/t/k/tk-l9-gd-076.jpg", // Hình ảnh 1
    "https://thaycuong.net/wp-content/uploads/2024/01/sgk-kntt-tap-1-toan-9-860.jpg.webp", // Hình ảnh 2
    "https://upload.wikimedia.org/wikipedia/commons/3/3f/JPEG_example_flower.jpg" ,//Hình 3
    // Thêm nhiều hình ảnh nếu cần
  ];


  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController genreController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  int _selectedIndex = 0;

  void openBookDialog({String? docID}) {
    if (docID != null) {
      firestoreService.books.doc(docID).get().then((doc) {
        final data = doc.data() as Map<String, dynamic>;
        titleController.text = data['title'] ?? '';
        authorController.text = data['author'] ?? '';
        genreController.text = data['genre'] ?? '';
        contentController.text = data['content'] ?? '';
      });
    } else {
      // Nếu không có docID thì đây là trường hợp thêm sách mới
      titleController.clear();
      authorController.clear();
      genreController.clear();
      contentController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(docID == null ? 'Thêm sách' : 'Sửa sách'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Tên sách'),
              ),
              TextField(
                controller: authorController,
                decoration: const InputDecoration(labelText: 'Tác giả'),
              ),
              TextField(
                controller: genreController,
                decoration: const InputDecoration(labelText: 'Thể loại'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Mô tả'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Nếu docID là null tức là thêm sách mới
                if (docID == null) {
                  firestoreService.addBook(
                    title: titleController.text,
                    author: authorController.text,
                    genre: genreController.text,
                    content: contentController.text,
                  );
                } else {
                  // Nếu có docID, tức là sửa sách
                  firestoreService.updateBook(
                    docID,
                    title: titleController.text,
                    author: authorController.text,
                    genre: genreController.text,
                    content: contentController.text,
                  );
                }

                // Sau khi lưu xong, xóa các giá trị đã nhập và đóng hộp thoại
                Navigator.pop(context);
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getSelectedScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 28),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 28),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book, size: 28),
            label: "Books",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_sharp, size: 28),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return _buildHome();
      case 1:
        return _buildSearchScreen();
      case 2:
        return _buildBookshelf();
      case 3:
        return _buildProfile();
      default:
        return _buildHome();
    }
  }

  Widget _buildHome() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Xử lý thông báo
            },
          ),
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getBooksStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Có lỗi xảy ra'));
          }

          var books = snapshot.data!.docs.map((doc) {
            return doc.data() as Map<String, dynamic>;
          }).toList();

          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.7,
            ),
            itemCount: books.length,
            itemBuilder: (context, index) {
              var book = books[index];
              // Gán hình ảnh từ danh sách dựa trên chỉ số của sách
              String imageUrl = imageUrls[index % imageUrls.length];

              return Card(
                margin: const EdgeInsets.all(6.0),
                elevation: 15,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: BookCard(
                  imageUrl: imageUrl, // Hình ảnh gán từ danh sách
                  title: book['title'],
                  author: book['author'],
                  genre: book['genre'],
                  content: book['content'],
                  onSetting: () {
                    openBookDialog(docID: snapshot.data!.docs[index].id);
                  },
                  onDelete: () {
                    firestoreService.deleteBook(snapshot.data!.docs[index].id);
                  },
                ),
              );
            },
          );
        },
      ),

        floatingActionButton: FloatingActionButton(
        onPressed: () => openBookDialog(), // Thêm sách mới
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm'),
        backgroundColor: Colors.blue,
      ),
      body: SearchScreen(),
    );
  }

  Widget _buildBookshelf() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kệ sách', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
      ),
      body: Bookshelf(),
    );
  }

  Widget _buildProfile() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
      ),
      body: Profile(),
    );
  }
}
