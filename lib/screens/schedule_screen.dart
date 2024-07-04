
import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../models/showtime.dart';
import '../database/firestore_service.dart';

class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<Showtime>>(
        future: FirestoreService().getShowtimes(),
        builder: (context, showtimeSnapshot) {
          if (showtimeSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (showtimeSnapshot.hasError) {
            return Center(child: Text('Error: ${showtimeSnapshot.error}'));
          } else if (!showtimeSnapshot.hasData || showtimeSnapshot.data!.isEmpty) {
            return Center(child: Text('No showtimes available.'));
          } else {
            List<Showtime> showtimes = showtimeSnapshot.data!;
            return FutureBuilder<List<Movie>>(
              future: FirestoreService().getMovies(),
              builder: (context, movieSnapshot) {
                if (movieSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (movieSnapshot.hasError) {
                  return Center(child: Text('Error: ${movieSnapshot.error}'));
                } else if (!movieSnapshot.hasData || movieSnapshot.data!.isEmpty) {
                  return Center(child: Text('No movies available.'));
                } else {
                  List<Movie> movies = movieSnapshot.data!;
                  return Padding(
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
                            itemCount: showtimes.length,
                            itemBuilder: (context, index) {
                              Showtime showtime = showtimes[index];
                              Movie? movie = movies.firstWhere((movie) => movie.id == showtime.movieId, orElse: () => Movie(id: '', title: '', genres: [], description: '', imageUrl: '', Director: ''));
                              
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: ListTile(
                                  title: Text(movie.title),
                                  subtitle: Text('Showing Time: ${showtime.startTime.hour}:${showtime.startTime.minute} - ${showtime.endTime.hour}:${showtime.endTime.minute}'),
                                  trailing: Icon(Icons.movie),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
