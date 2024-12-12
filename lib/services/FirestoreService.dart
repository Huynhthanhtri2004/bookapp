import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/Bookshelf.dart';

class FirestoreService {
  final CollectionReference books = FirebaseFirestore.instance.collection('books');

  Future<List<Book>> fetchBooksFromFirestore() async {
    try {
      final snapshot = await books.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Book(
          title: data['title'] ?? '',
          author: data['author'] ?? '',
          genre: data['genre'] ?? '',
          image: data['image'] ?? '',
        );
      }).toList();
    } catch (e) {
      throw Exception("Lỗi khi tải sách từ Firestore: $e");
    }
  }
  // Hàm tìm kiếm theo từ khóa (có thể tìm theo title hoặc author)
  Stream<QuerySnapshot> searchBooks(String query) {
    return books
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: query + '\uf8ff')
        .snapshots();
  }

  // CREATE: Thêm sách
  Future<void> addBook({
    required String title,
    required String author,
    required String genre,
    required String content,
  }) async {
    try {
      await books.add({
        'title': title,
        'author': author,
        'genre': genre,
        'content': content,
        'timestamp': FieldValue.serverTimestamp(), // Thêm timestamp
      });
    } catch (e) {
      print("Error adding book: $e");
    }
  }

  // READ: Lấy danh sách sách
  Stream<QuerySnapshot> getBooksStream() {
    return books.orderBy('timestamp', descending: false).snapshots(); // Sắp xếp theo timestamp tăng dần
  }

  // UPDATE: Cập nhật sách
  Future<void> updateBook(String docID, {
    required String title,
    required String author,
    required String genre,
    required String content,
  }) {
    return books.doc(docID).update({
      'title': title,
      'author': author,
      'genre': genre,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(), // Cập nhật timestamp mỗi khi sửa
    });
  }

  // DELETE: Xóa sách
  Future<void> deleteBook(String docID) {
    return books.doc(docID).delete();
  }
}
