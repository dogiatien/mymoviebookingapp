import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AdminMenuButton(
              text: 'Quản lý phim',
              onPressed: () {
                Navigator.pushNamed(context, '/manage_movies');
              },
            ),
            AdminMenuButton(
              text: 'Quản lý lịch chiếu',
              onPressed: () {
                Navigator.pushNamed(context, '/manage_showtimes');
              },
            ),
            AdminMenuButton(
              text: 'Quản lý người dùng',
              onPressed: () {
                Navigator.pushNamed(context, '/manage_users');
              },
            ),
            AdminMenuButton(
              text: 'Quản lý vé',
              onPressed: () {
                Navigator.pushNamed(context, '/manage_tickets');
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Widget AdminMenuButton để tạo các nút trong menu admin
class AdminMenuButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  AdminMenuButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
