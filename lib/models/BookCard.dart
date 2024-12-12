import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  // các thuộc tính của bookcard
  final String imageUrl; // URL hình ảnh thủ công
  final String title;    // Tựa sách
  final String author;   // Tác giả
  final String genre;    // Thể loại
  final String content;  // Nội dung/Mô tả
  final VoidCallback onSetting; // Hành động khi bấm vào nút "Setting"
  final VoidCallback onDelete; // Hành động khi xóa

  const BookCard({
    super.key,
    required this.imageUrl,  // URL hình ảnh truyền vào khi khởi tạo
    required this.title,
    required this.author,
    required this.genre,
    required this.content,
    required this.onDelete,
    required this.onSetting,  // Thêm đối số cho nút "Setting"
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(
          imageUrl.isNotEmpty
              ? imageUrl  // Sử dụng URL hình ảnh được truyền vào
              : 'https://via.placeholder.com/100x140', // URL mặc định nếu không có hình ảnh
          fit: BoxFit.cover,
          width: 150,
          height: 185,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          "Tác giả: $author",
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete, // Xóa sách
            ),
            IconButton(
              icon: const Icon(Icons.settings_rounded),
              onPressed: onSetting, // Mở hộp thoại sửa sách
            ),
          ],
        ),
      ],
    );
  }
}
