
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/movie.dart';
// import '../database/movie_data.dart'; // Import sampleMovies here

// class FirestoreService {
//   final CollectionReference moviesCollection =
//       FirebaseFirestore.instance.collection('movies');
//   final CollectionReference genresCollection =
//       FirebaseFirestore.instance.collection('genres');

//   Future<void> addSampleMovies() async {
//     for (Movie movie in sampleMovies) {
//       await moviesCollection.doc(movie.id).set({
//         'title': movie.title,
//         'genre': movie.genres,
//         'Director': movie.Director,
//         'price': movie.price,
//         'description': movie.description,
//         'imageUrl': movie.imageUrl,
//       });
//     }
//     print('Sample movies added to Firestore');
//   }
  

//   Future<List<Movie>> getMovies() async {
//     QuerySnapshot snapshot = await moviesCollection.get();
//     return snapshot.docs.map((doc) {
//       // Cast 'genre' field to List<String>
//       List<String> genresList = List<String>.from(doc['genre']);
      
//       return Movie(
//         id: doc.id,
//         title: doc['title'],
//         genres: genresList,
//         Director: doc['Director'],
//         price: doc['price'],
//         description: doc['description'],
//         imageUrl: doc['imageUrl'],
//       );
//     }).toList();
//   }

//   Future<Movie> getMovieById(String id) async {
//     DocumentSnapshot doc = await moviesCollection.doc(id).get();
//     // Cast 'genre' field to List<String>
//     List<String> genresList = List<String>.from(doc['genre']);
    
//     return Movie(
//       id: doc.id,
//       title: doc['title'],
//       genres: genresList,
//       description: doc['description'],
//       price: doc['price'],
//       imageUrl: doc['imageUrl'],
//       Director: doc['Director'],
//     );
//   }

//   ///////////////////////////////////////////////////
  
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie.dart';
import '../models/genre.dart'; // Import Genre model
import '../database/genre_data.dart'; // Import sampleGenres
import '../database/movie_data.dart'; // Import sampleMovies here

class FirestoreService {
  final CollectionReference moviesCollection =
      FirebaseFirestore.instance.collection('movies');
  final CollectionReference genresCollection =
      FirebaseFirestore.instance.collection('genres');

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
}
