import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'rating_page.dart';

class MoviePage extends StatefulWidget {
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final DBHelper dbHelper = DBHelper();
  final TextEditingController nameController = TextEditingController();
  List<Map<String, dynamic>> movies = [];
  bool isUpdating = false;
  int? updatingMovieId;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final data = await dbHelper.queryAll('movies');
    setState(() {
      movies = data;
    });
  }

  Future<void> addMovie() async {
    await dbHelper.insert('movies', {
      'name': nameController.text,
      'rating': 0.0,
    });
    fetchMovies();
    nameController.clear();
  }

  Future<void> updateMovie(int id) async {
    await dbHelper.update(
        'movies',
        {
          'name': nameController.text,
        },
        'id = ?',
        [id]);
    fetchMovies();
    nameController.clear();
    setState(() {
      isUpdating = false;
      updatingMovieId = null;
    });
  }

  Future<void> deleteMovie(int id) async {
    await dbHelper.delete('movies', 'id = ?', [id]);
    fetchMovies();
  }

  void setUpdate(Movie movie) {
    nameController.text = movie.name;
    setState(() {
      isUpdating = true;
      updatingMovieId = movie.id;
    });
  }

  void navigateToRatingPage(int movieId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RatingPage(movieId: movieId)),
    ).then((_) {
      // Refresh movie list after rating
      fetchMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = Movie(
                  id: movies[index]['id'],
                  name: movies[index]['name'],
                  rating: movies[index]['rating'],
                );
                return ListTile(
                  title: Text(movie.name),
                  subtitle: Text('Rating: ${movie.rating}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          setUpdate(movie);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deleteMovie(movie.id);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.star),
                        onPressed: () {
                          navigateToRatingPage(movie.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Movie Name'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (isUpdating && updatingMovieId != null) {
                      updateMovie(updatingMovieId!);
                    } else {
                      addMovie();
                    }
                  },
                  child: Text(isUpdating ? 'Update Movie' : 'Add Movie'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Movie {
  final int id;
  final String name;
  final double? rating;

  Movie({required this.id, required this.name, double? rating})
      : rating = rating ?? 0.0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'rating': rating,
    };
  }
}
