import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/movie_bloc.dart';
import '../widgets/movie_grid.dart';

class MovieSearchDelegate extends SearchDelegate {
  final MovieBloc bloc;

  MovieSearchDelegate({required this.bloc});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
            // When query is cleared, fetch all movies
            bloc.add(GetNowPlayingMoviesEvent());
          }
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      // If search is empty, show all movies
      bloc.add(GetNowPlayingMoviesEvent());
    } else {
      // If there's a search query, perform search
      bloc.add(SearchMoviesEvent(query));
    }

    return BlocBuilder<MovieBloc, MovieState>(
      bloc: bloc,
      builder: (context, state) {
        if (state is MovieLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MoviesLoaded) {
          return MovieGrid(movies: state.movies);
        } else if (state is MovieError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show results immediately as user types
    return buildResults(context);
  }
}