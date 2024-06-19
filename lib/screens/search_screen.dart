import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late FocusNode _focusNode;
  String _selectedValue =
      'Action'; // Biến để lưu giá trị được chọn trong dropdown

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus(); // Tắt bàn phím nếu đang mở
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap, // Bắt sự kiện khi chạm vào bất kỳ đâu trên màn hình
      child: Scaffold(
        appBar: AppBar(
          title: Text('Search'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                focusNode: _focusNode, // Đặt focus node cho text field
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // Xử lý khi người dùng thay đổi nội dung trong ô tìm kiếm
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: DropdownButton<String>(
                value: _selectedValue,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedValue = newValue!;
                  });
                },
                items: <String>['Action', 'Comedy', 'Horror']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                isExpanded: true, // Để dropdown chiếm toàn bộ chiều rộng có thể
              ),
            ),
            Expanded(
              child: Center(
                child: Text('Search Screen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
