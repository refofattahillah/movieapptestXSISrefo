import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/movie.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies();
  Future<Either<Failure, Movie>> getMovieDetail(int id);
  Future<Either<Failure, List<Movie>>> searchMovies(String query);
}