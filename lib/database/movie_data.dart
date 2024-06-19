import '../models/movie.dart';

final List<Movie> sampleMovies = [
  Movie(
    id: '1',
    title: 'Movie 1',
    genres: ['Cartoon'],
    Director: 'Đạo diễn 1',
    price: '56.000 vnd',
    description: 'Mô tả chi tiết cho movie 1',
    imageUrl: 'https://via.placeholder.com/150',
  ),
  Movie(
    id: '2',
    title: 'Movie 2',
    genres: ['Comedy'],
    price: '89.000 vnd',
    Director: 'Đạo diễn 2',
    description: 'Mô tả chi tiết cho movie 2',
    imageUrl: 'https://via.placeholder.com/150',
  ),
  Movie(
    id: '3',
    title: 'Movie 3',
    genres: ['Horror','Comedy'],
    price: '96.000 vnd',
    Director: 'Đạo diễn 3',
    description: 'Mô tả chi tiết cho movie 3',
    imageUrl: 'https://via.placeholder.com/150',
  ),
];
