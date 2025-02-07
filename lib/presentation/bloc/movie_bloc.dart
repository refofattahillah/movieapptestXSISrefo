import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_movies.dart';
import '../../domain/usecases/get_movie_detail.dart';
import '../../domain/usecases/search_movies.dart';

// Events
abstract class MovieEvent extends Equatable {
  const MovieEvent();
  @override
  List<Object> get props => [];
}

class GetNowPlayingMoviesEvent extends MovieEvent {}
class GetMovieDetailEvent extends MovieEvent {
  final int movieId;
  const GetMovieDetailEvent(this.movieId);
  @override
  List<Object> get props => [movieId];
}
class SearchMoviesEvent extends MovieEvent {
  final String query;
  const SearchMoviesEvent(this.query);
  @override
  List<Object> get props => [query];
}

// States
abstract class MovieState extends Equatable {
  const MovieState();
  @override
  List<Object> get props => [];
}

class MovieInitial extends MovieState {}
class MovieLoading extends MovieState {}
class MovieError extends MovieState {
  final String message;
  const MovieError(this.message);
  @override
  List<Object> get props => [message];
}
class MoviesLoaded extends MovieState {
  final List<Movie> movies;
  const MoviesLoaded(this.movies);
  @override
  List<Object> get props => [movies];
}
class MovieDetailLoaded extends MovieState {
  final Movie movie;
  const MovieDetailLoaded(this.movie);
  @override
  List<Object> get props => [movie];
}

// BLoC
class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetMovieDetail getMovieDetail;
  final SearchMovies searchMovies;

  MovieBloc({
    required this.getNowPlayingMovies,
    required this.getMovieDetail,
    required this.searchMovies,
  }) : super(MovieInitial()) {
    on<GetNowPlayingMoviesEvent>((event, emit) async {
      emit(MovieLoading());
      final result = await getNowPlayingMovies();
      result.fold(
        (failure) => emit(const MovieError('Failed to fetch movies')),
        (movies) => emit(MoviesLoaded(movies)),
      );
    });

    on<GetMovieDetailEvent>((event, emit) async {
      emit(MovieLoading());
      final result = await getMovieDetail(event.movieId);
      result.fold(
        (failure) => emit(const MovieError('Failed to fetch movie detail')),
        (movie) => emit(MovieDetailLoaded(movie)),
      );
    });

    on<SearchMoviesEvent>((event, emit) async {
      emit(MovieLoading());
      final result = await searchMovies(event.query);
      result.fold(
        (failure) => emit(const MovieError('Failed to search movies')),
        (movies) => emit(MoviesLoaded(movies)),
      );
    });
  }
}