import 'package:dartz/dartz.dart';
import 'package:movieapprefo/core/errors/failures.dart';
import 'package:movieapprefo/domain/entities/movie.dart';
import 'package:movieapprefo/domain/repositories/movie_repository.dart';

class SearchMovies {
  final MovieRepository repository;
  SearchMovies(this.repository);

  Future<Either<Failure, List<Movie>>> call(String query) async {
    return await repository.searchMovies(query);
  }
}