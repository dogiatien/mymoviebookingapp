// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:moviebookingapp/widgets/bottom_appbar.dart';
// import '../models/movie.dart';
// import '../widgets/movies_list.dart';
// import '../app_colors.dart';
// import '../database/firestore_service.dart';
// import '../models/genre.dart';
// import '../screens/login_screen.dart';
// import '../models/user.dart' as AppUser;
// import '../screens/profile_screen.dart';
// import '../screens/schedule_screen.dart';
// import '../screens/search_screen.dart';

// class HomeScreen extends StatefulWidget {
//   final String userId;

//   HomeScreen({required this.userId});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   late Future<AppUser.User?> _userFuture;
//   int _currentIndex = 0;
//   bool _isLoggedIn = false; // Track login status

//   @override
//   void initState() {
//     super.initState();
//     _userFuture = FirestoreService().getUserById(widget.userId);
//     _checkLoginStatus(); // Check initial login status
//   }

//   // Function to check login status
//   void _checkLoginStatus() {
//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       setState(() {
//         if( user != null)
//         {
//           _isLoggedIn = true;
//         }; // Update login status
//       });
//     });
//   }

//   void _onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Screen'),
//         actions: [
//           FutureBuilder<AppUser.User?>(
//             future: _userFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasData && snapshot.data != null) {
//                 final user = snapshot.data!;
//                 return TextButton(
//                   onPressed: () {
//                     // Handle user profile or logout
//                   },
//                   child: Text(
//                     user.name.toString(), // Display user name
//                     style: TextStyle(color: Colors.black),
//                   ),
//                 );
//               } else {
//                 return TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => LoginScreen()),
//                     );
//                   },
//                   child: Text(
//                     'Đăng nhập',
//                     style: TextStyle(color: Colors.black),
//                   ),
//                 );
//               }
//             },
//           ),
//         ],
//       ),
//       body: IndexedStack(
//         index: _currentIndex,
//         children: [
//           _buildHomeScreen(context),
//           ScheduleScreen(),
//           SearchScreen(),
//           ProfileScreen(userId: widget.userId),
//         ],
//       ),
//       backgroundColor: AppColors.background,

//   // Hide bottom navigation if not logged in
//     );
//   }

//   Widget _buildHomeScreen(BuildContext context) {
//     return FutureBuilder<List<Movie>>(
//       future: FirestoreService().getMovies(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Center(child: Text('No movies available.'));
//         } else {
//           List<Movie> movies = snapshot.data!;
//           return FutureBuilder<List<Genre>>(
//             future: FirestoreService().getGenres(),
//             builder: (context, genreSnapshot) {
//               if (genreSnapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               } else if (genreSnapshot.hasError) {
//                 return Center(child: Text('Error: ${genreSnapshot.error}'));
//               } else if (!genreSnapshot.hasData || genreSnapshot.data!.isEmpty) {
//                 return Center(child: Text('No genres available.'));
//               } else {
//                 List<Genre> genres = genreSnapshot.data!;
//                 return SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       CarouselSlider(
//                         items: [
//                           'lib/images/h1.jpg',
//                           'lib/images/h2.jpg',
//                         ].map((imagePath) {
//                           return Container(
//                             margin: EdgeInsets.all(6.0),
//                             child: Image.asset(
//                               imagePath,
//                               fit: BoxFit.cover,
//                             ),
//                           );
//                         }).toList(),
//                         options: CarouselOptions(
//                           autoPlay: true,
//                           aspectRatio: 16 / 9,
//                           enlargeCenterPage: true,
//                           viewportFraction: 0.8,
//                         ),
//                       ),
//                       _buildMovieSections(movies, genres),
//                     ],
//                   ),
//                 );
//               }
//             },
//           );
//         }
//       },
//     );
//   }

//   Widget _buildMovieSections(List<Movie> movies, List<Genre> genres) {
//     Map<String, List<Movie>> moviesByGenre = {};

//     // Initialize movie lists for each genre
//     genres.forEach((genre) {
//       moviesByGenre[genre.name] = [];
//     });

//     // Categorize movies into respective genre lists
//     movies.forEach((movie) {
//       movie.genres.forEach((genreName) {
//         if (moviesByGenre.containsKey(genreName)) {
//           moviesByGenre[genreName]!.add(movie);
//         }
//       });
//     });

//     // Build MovieList sections for each genre
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: moviesByGenre.entries.map((entry) {
//         return _buildMovieSection(entry.key, entry.value);
//       }).toList(),
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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moviebookingapp/widgets/bottom_appbar.dart';
import '../models/movie.dart';
import '../widgets/movies_list.dart';
import '../app_colors.dart';
import '../database/firestore_service.dart';
import '../models/genre.dart';
import '../screens/login_screen.dart';
import '../models/user.dart' as AppUser;
import '../screens/profile_screen.dart';
import '../screens/schedule_screen.dart';
import '../screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userId;

  HomeScreen({required this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<AppUser.User?> _userFuture;
  int _currentIndex = 0;
  bool _isLoggedIn = false; // Track login status

  @override
  void initState() {
    super.initState();
    _userFuture = FirestoreService().getUserById(widget.userId);
    _checkLoginStatus(); // Check initial login status
  }

  // Function to check login status
  void _checkLoginStatus() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _isLoggedIn = user != null; // Update login status
      });
    });
  }

  // Function to handle logout
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      _isLoggedIn = false;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          FutureBuilder<AppUser.User?>(
            future: _userFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData && snapshot.data != null) {
                final user = snapshot.data!;
                return Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        // Handle user profile
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(userId: widget.userId),
                          ),
                        );
                      },
                      child: Text(
                        user.name.toString(), // Display user name
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.exit_to_app),
                      onPressed: _logout,
                    ),
                  ],
                );
              } else {
                return TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text(
                    'Đăng nhập',
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeScreen(context),
          ScheduleScreen(),
          SearchScreen(),
          ProfileScreen(userId: widget.userId),
        ],
      ),
      backgroundColor: AppColors.background,
    );
  }

  Widget _buildHomeScreen(BuildContext context) {
    return FutureBuilder<List<Movie>>(
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
              } else if (!genreSnapshot.hasData ||
                  genreSnapshot.data!.isEmpty) {
                return Center(child: Text('No genres available.'));
              } else {
                List<Genre> genres = genreSnapshot.data!;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CarouselSlider(
                        items: [
                          'lib/images/h3.jpg',
                          'lib/images/h4.jpg',
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
                          aspectRatio: 2.5,
                          enlargeCenterPage: true,
                          viewportFraction: 0.9,
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
