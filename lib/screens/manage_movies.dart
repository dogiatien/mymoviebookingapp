import 'dart:math';

import 'package:flutter/material.dart';
import 'package:moviebookingapp/app_colors.dart';
import 'package:moviebookingapp/database/firestore_service.dart';

import '../models/movie.dart';

class ManageMoviesPage extends StatefulWidget {
  const ManageMoviesPage({super.key});

  @override
  State<ManageMoviesPage> createState() => _ManageMoviesPageState();
}

class _ManageMoviesPageState extends State<ManageMoviesPage> {
  List<Movie> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    data.clear();
    List<Movie> movies = await FirestoreService().getMovies();
    setState(() {
      // Update state with the fetched data
      data.addAll(movies);
    });
    print('data size: ${movies.length}');
  }

  void _addMovie({Movie? movie}) async {
    TextEditingController idMovieController = TextEditingController();
    TextEditingController titleController = TextEditingController();
    TextEditingController genresController = TextEditingController();
    TextEditingController directorController = TextEditingController();
    TextEditingController desController = TextEditingController();
    TextEditingController imgController = TextEditingController();
    TextEditingController urlMovieController = TextEditingController();

    bool isEdit = false;
    if (movie != null) {
      isEdit = true;

      idMovieController.text = movie.id;
      titleController.text = movie.title;
      genresController.text = movie.genres.join(', ');
      directorController.text = movie.Director;
      desController.text = movie.description;
      imgController.text = movie.imageUrl;
      urlMovieController.text = movie.videoUrl;
    }

    showBottomSheet(
        context: context,
        builder: (c) {
          return Container(
            color: AppColors.admin_color1,
            padding: EdgeInsets.symmetric(horizontal: 20),
            // height: MediaQuery.of(context).size.height / 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      isEdit ? 'Sửa dữ liệu' : 'Thêm dữ liệu',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  isEdit
                      ? Text('IdMovie: ${idMovieController.text}')
                      : TextField(
                          textAlign: TextAlign.start,
                          controller: idMovieController,
                          decoration: const InputDecoration(
                            // border: B,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            alignLabelWithHint: true,
                            label: Text(
                              'Movie ID',
                            ),
                          ),
                        ),
                  TextField(
                    textAlign: TextAlign.start,
                    controller: titleController,
                    decoration: const InputDecoration(
                      // border: B,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      alignLabelWithHint: true,
                      label: Text(
                        'Title',
                      ),
                    ),
                  ),
                  TextField(
                    textAlign: TextAlign.start,
                    controller: genresController,
                    decoration: const InputDecoration(
                      // border: B,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      alignLabelWithHint: true,
                      label: Text(
                        'genres',
                      ),
                    ),
                  ),
                  TextField(
                    textAlign: TextAlign.start,
                    controller: directorController,
                    decoration: const InputDecoration(
                      // border: B,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      alignLabelWithHint: true,
                      label: Text(
                        'director',
                      ),
                    ),
                  ),
                  TextField(
                    textAlign: TextAlign.start,
                    controller: desController,
                    decoration: const InputDecoration(
                      // border: B,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      alignLabelWithHint: true,
                      label: Text(
                        'des',
                      ),
                    ),
                  ),
                  TextField(
                    textAlign: TextAlign.start,
                    controller: imgController,
                    decoration: const InputDecoration(
                      // border: B,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      alignLabelWithHint: true,
                      label: Text(
                        'Img',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    textAlign: TextAlign.start,
                    controller: urlMovieController,
                    decoration: const InputDecoration(
                      // border: B,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      alignLabelWithHint: true,
                      label: Text(
                        'Url movie',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      if (titleController.text == '' ||
                          desController.text == '' ||
                          imgController.text == '' ||
                          urlMovieController.text == '' ||
                          genresController.text == '' ||
                          directorController.text == '') {
                        return;
                      }
                      Movie newMovie = Movie(
                          id: idMovieController.text,
                          title: titleController.text,
                          genres: genresController.text.split(', '),
                          description: desController.text,
                          imageUrl: imgController.text,
                          Director: directorController.text,
                          videoUrl: urlMovieController.text);

                      isEdit
                          ? _readyEditMovie(newMovie)
                          : _readyAddMovie(newMovie);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.admin_color,
                        borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Center(child: Text('Đồng ý')),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        });
    // await FirestoreService().addMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: (data.length == 0)
                ? Center(
                    child: Text('Không có dữ liệu'),
                  )
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      Movie movie = data[index];
                      return _itemMovieWidget(movie);
                    }),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,

            ),
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
                onPressed: () {
                  _addMovie();
                },
                child: Text('Thêm dữ liệu')),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Widget _itemMovieWidget(Movie movie) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  movie.imageUrl,
                  width: 100,
                  height: 140,
                  fit: BoxFit.fill,
                  errorBuilder: (context, exception, stackTrace) {
                    return Container(
                      width: 80,
                      height: 100,
                      child: Center(child: Text('Can\'t load image')),
                    );
                  },
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${movie.title}',
                      maxLines: 2,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.black, fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('${movie.genres.toString()}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black)),
                    Text('${movie.Director}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black)),

                    SizedBox(height: 5,),
                    Text('description: ${movie.description}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.black),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              SizedBox(
                width: 35,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            _addMovie(movie: movie);
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.black,
                          )),
                      IconButton(
                          onPressed: () {
                            _readyRemoveMovie(movie);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.orangeAccent,
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _readyAddMovie(Movie movie) async {
    await FirestoreService().addMovies(movie);
    Navigator.pop(context);
    fetchData();
  }

  void _readyEditMovie(Movie newMovie) async {
    await FirestoreService().updateMovie(newMovie);
    Navigator.pop(context);
    fetchData();
  }

  void _readyRemoveMovie(Movie newMovie) async {
    await FirestoreService().deleteMovie(newMovie.id);
    fetchData();
  }
}
