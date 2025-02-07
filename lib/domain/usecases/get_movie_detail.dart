import 'package:dartz/dartz.dart';
import 'package:movieapprefo/core/errors/failures.dart';
import 'package:movieapprefo/domain/entities/movie.dart';
import 'package:movieapprefo/domain/repositories/movie_repository.dart';

class GetMovieDetail {
  final MovieRepository repository;
  GetMovieDetail(this.repository);

  Future<Either<Failure, Movie>> call(int id) async {
    return await repository.getMovieDetail(id);
  }
}