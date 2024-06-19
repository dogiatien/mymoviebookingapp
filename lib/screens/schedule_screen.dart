import 'package:flutter/material.dart';
import '../models/movie.dart';

class ScheduleScreen extends StatelessWidget {
  final List<Movie> movies;

  ScheduleScreen({required this.movies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lịch chiếu phim',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text(movies[index].title),
                      subtitle: Text('Showing Time: ${index + 1}:00 PM'),
                      trailing: Icon(Icons.movie),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
