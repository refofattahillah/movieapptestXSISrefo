import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/movie_model.dart';

class MovieRemoteDataSource {
  final http.Client client;

  MovieRemoteDataSource({required this.client});

  Future<List<MovieModel>> getNowPlayingMovies() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.nowPlaying}')
          .replace(queryParameters: {'api_key': ApiConstants.apiKey}),
    );

    if (response.statusCode == 200) {
      return (json.decode(response.body)['results'] as List)
          .map((movie) => MovieModel.fromJson(movie))
          .toList();
    } else {
      throw ServerException();
    }
  }

  Future<MovieModel> getMovieDetail(int id) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.movieDetails}/$id')
          .replace(queryParameters: {'api_key': ApiConstants.apiKey}),
    );

    if (response.statusCode == 200) {
      return MovieModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.searchMovie}')
          .replace(queryParameters: {
        'api_key': ApiConstants.apiKey,
        'query': query,
      }),
    );

    if (response.statusCode == 200) {
      return (json.decode(response.body)['results'] as List)
          .map((movie) => MovieModel.fromJson(movie))
          .toList();
    } else {
      throw ServerException();
    }
  }

  Future<String?> getMovieTrailer(int movieId) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConstants.baseUrl}/movie/$movieId/videos')
            .replace(queryParameters: {'api_key': ApiConstants.apiKey}),
      );

      if (response.statusCode == 200) {
        final results = json.decode(response.body)['results'] as List;
        
        // First try to find an official trailer
        var trailer = results.firstWhere(
          (video) => 
            video['site'] == 'YouTube' && 
            video['type'] == 'Trailer' &&
            video['official'] == true,
          orElse: () => null,
        );

        // If no official trailer, try any trailer
        if (trailer == null) {
          trailer = results.firstWhere(
            (video) => 
              video['site'] == 'YouTube' && 
              video['type'] == 'Trailer',
            orElse: () => null,
          );
        }

        // If still no trailer, try a teaser
        if (trailer == null) {
          trailer = results.firstWhere(
            (video) => 
              video['site'] == 'YouTube' && 
              video['type'] == 'Teaser',
            orElse: () => null,
          );
        }

        if (trailer != null) {
          return '${ApiConstants.youtubeUrl}${trailer['key']}';
        }
      }
    } catch (e) {
      print('Error fetching trailer: $e');
    }
    return null;
  }

}