

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie.dart';
import '../models/showtime.dart';
import '../models/genre.dart'; // Import Genre model
import '../database/genre_data.dart'; // Import sampleGenres
import '../database/movie_data.dart'; // Import sampleMovies here
import '../database/showtime_data.dart';


class FirestoreService 
{
  final CollectionReference moviesCollection =
      FirebaseFirestore.instance.collection('movies');
  final CollectionReference genresCollection =
      FirebaseFirestore.instance.collection('genres');
        final CollectionReference showtimeCollection =
      FirebaseFirestore.instance.collection('showtime');

  Future<void> addSampleMovies() async {
    for (Movie movie in sampleMovies) {
      await moviesCollection.doc(movie.id).set({
        'title': movie.title,
        'genre': movie.genres,
        'Director': movie.Director,
        'price': movie.price,
        'description': movie.description,
        'imageUrl': movie.imageUrl,
      });
    }
    print('Sample movies added to Firestore');
  }

  Future<void> addSampleGenres() async {
    for (Genre genre in sampleGenres) {
      await genresCollection.doc(genre.id).set({
        'id': genre.id,
        'name': genre.name,
      });
    }
    print('Sample genres added to Firestore');
  }

   Future<void> addSampleShowtimes() async {
    for (Showtime showtime in sampleShowtimes) {
      await showtimeCollection.doc(showtime.stid).set(showtime.toMap());
    }
    print('Sample showtimes added to Firestore');
  }


  Future<List<Movie>> getMovies() async {
    QuerySnapshot snapshot = await moviesCollection.get();
    return snapshot.docs.map((doc) {
      List<String> genresList = List<String>.from(doc['genre']);
      
      return Movie(
        id: doc.id,
        title: doc['title'],
        genres: genresList,
        Director: doc['Director'],
        price: doc['price'],
        description: doc['description'],
        imageUrl: doc['imageUrl'],
      );
    }).toList();
  }

  Future<Movie> getMovieById(String id) async {
    DocumentSnapshot doc = await moviesCollection.doc(id).get();
    List<String> genresList = List<String>.from(doc['genre']);
    
    return Movie(
      id: doc.id,
      title: doc['title'],
      genres: genresList,
      description: doc['description'],
      price: doc['price'],
      imageUrl: doc['imageUrl'],
      Director: doc['Director'],
    );
  }

  Future<List<Genre>> getGenres() async {
    QuerySnapshot snapshot = await genresCollection.get();
    return snapshot.docs.map((doc) {
      return Genre(
        id: doc.id,
        name: doc['name'],
      );
    }).toList();
  }

   Future<List<Showtime>> getShowtimes() async {
    QuerySnapshot snapshot = await showtimeCollection.get();
    return snapshot.docs.map((doc) {
      return Showtime(
        stid: doc.id,
        movieId: doc['movieId'],
        theaterId: doc['theaterId'],
        startTime: DateTime.parse(doc['startTime']),
        endTime: DateTime.parse(doc['endTime']),
        date: DateTime.parse(doc['date']),
      );
    }).toList();
  }
  Future<Showtime> getShowtimeById(String id) async {
    DocumentSnapshot doc = await showtimeCollection.doc(id).get();
    return Showtime.fromMap(doc.data() as Map<String, dynamic>);
  }
  Future<List<Showtime>> getShowtimesByMovieId(String movieId) async {
    QuerySnapshot snapshot = await showtimeCollection.where('movieId', isEqualTo: movieId).get();
    return snapshot.docs.map((doc) {
      dynamic startTimeField = doc['startTime'];
      dynamic endTimeField = doc['endTime'];
      dynamic dateField = doc['date'];

      DateTime startTime = startTimeField is Timestamp ? startTimeField.toDate() : DateTime.parse(startTimeField);
      DateTime endTime = endTimeField is Timestamp ? endTimeField.toDate() : DateTime.parse(endTimeField);
      DateTime date = dateField is Timestamp ? dateField.toDate() : DateTime.parse(dateField);

      return Showtime(
        stid: doc.id,
        movieId: doc['movieId'],
        theaterId: doc['theaterId'],
        startTime: startTime,
        endTime: endTime,
        date: date,
      );
    }).toList();
  }
}
