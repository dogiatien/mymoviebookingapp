// import 'package:flutter/material.dart';
// import '../models/movie.dart';
// import '../widgets/movies_list.dart';
// import '../app_colors.dart';
// import 'package:carousel_slider/carousel_slider.dart';

// class HomeScreen extends StatelessWidget {
//   final List<Movie> movies;

//   HomeScreen({required this.movies});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(30.0),
//         child: AppBar(),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             CarouselSlider(
//               items: [
//                 'lib/images/h1.jpg',
//                 'lib/images/h2.jpg',
//               ].map((imagePath) {
//                 return Container(
//                   margin: EdgeInsets.all(6.0),
//                   child: Image.asset(
//                     imagePath,
//                     fit: BoxFit.cover,
//                   ),
//                 );
//               }).toList(),
//               options: CarouselOptions(
//                 autoPlay: true,
//                 aspectRatio: 16 / 9,
//                 enlargeCenterPage: true,
//                 viewportFraction: 0.8,
//               ),
//             ),
//             _buildMovieSection('Action Movies', movies),
//             _buildMovieSection('Comedy Movies', movies),
//             _buildMovieSection('Drama Movies', movies),
//           ],
//         ),
//       ),
//       backgroundColor: AppColors.background,
//     );
//   }

//   Widget _buildMovieSection(String title, List<Movie> movies) {
//     return Container(
//       color: const Color.fromARGB(255, 254, 254, 255),
//       padding: EdgeInsets.all(8.0),
//       margin: EdgeInsets.symmetric(vertical: 10.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 8.0, top: 8.0),
//             child: Text(
//               title,
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.Title,
//               ),
//             ),
//           ),
//           SizedBox(height: 10),
//           Container(
//             height: 210,
//             child: MovieList(movies),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/movie.dart';
import '../widgets/movies_list.dart';
import '../app_colors.dart';
import '../database/firestore_service.dart';
import '../models/genre.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<Movie>>(
        future: FirestoreService().getMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No movies available.'));
          } else {
            List<Movie> movies = snapshot.data!;
            return FutureBuilder<List<Genre>>(
              future: FirestoreService().getGenres(),
              builder: (context, genreSnapshot) {
                if (genreSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (genreSnapshot.hasError) {
                  return Center(child: Text('Error: ${genreSnapshot.error}'));
                } else if (!genreSnapshot.hasData || genreSnapshot.data!.isEmpty) {
                  return Center(child: Text('No genres available.'));
                } else {
                  List<Genre> genres = genreSnapshot.data!;
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CarouselSlider(
                          items: [
                            'lib/images/h1.jpg',
                            'lib/images/h2.jpg',
                          ].map((imagePath) {
                            return Container(
                              margin: EdgeInsets.all(6.0),
                              child: Image.asset(
                                imagePath,
                                fit: BoxFit.cover,
                              ),
                            );
                          }).toList(),
                          options: CarouselOptions(
                            autoPlay: true,
                            aspectRatio: 16 / 9,
                            enlargeCenterPage: true,
                            viewportFraction: 0.8,
                          ),
                        ),
                        _buildMovieSections(movies, genres),
                      ],
                    ),
                  );
                }
              },
            );
          }
        },
      ),
      backgroundColor: AppColors.background,
    );
  }

  Widget _buildMovieSections(List<Movie> movies, List<Genre> genres) {
    Map<String, List<Movie>> moviesByGenre = {};

    // Initialize movie lists for each genre
    genres.forEach((genre) {
      moviesByGenre[genre.name] = [];
    });

    // Categorize movies into respective genre lists
    movies.forEach((movie) {
      movie.genres.forEach((genreName) {
        if (moviesByGenre.containsKey(genreName)) {
          moviesByGenre[genreName]!.add(movie);
        }
      });
    });

    // Build MovieList sections for each genre
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: moviesByGenre.entries.map((entry) {
        return _buildMovieSection(entry.key, entry.value);
      }).toList(),
    );
  }

  Widget _buildMovieSection(String title, List<Movie> movies) {
    return Container(
      color: const Color.fromARGB(255, 254, 254, 255),
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.Title,
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 210,
            child: MovieList(movies),
          ),
        ],
      ),
    );
  }
}
