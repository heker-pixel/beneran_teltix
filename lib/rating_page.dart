import 'package:flutter/material.dart';
import 'db_helper.dart';

class RatingPage extends StatefulWidget {
  final int movieId;

  RatingPage({required this.movieId});

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  final DBHelper dbHelper = DBHelper();
  final TextEditingController userController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();
  List<Map<String, dynamic>> ratings = [];
  bool isUpdating = false;
  int? updatingRatingId;

  @override
  void initState() {
    super.initState();
    fetchRatings();
  }

  Future<void> fetchRatings() async {
    final data =
        await dbHelper.query('ratings', 'movieId = ?', [widget.movieId]);
    setState(() {
      ratings = data;
    });
    calculateMovieRating();
  }

  Future<void> addRating() async {
    await dbHelper.insert('ratings', {
      'movieId': widget.movieId,
      'user': userController.text,
      'rating': int.parse(ratingController.text),
    });
    fetchRatings();
    userController.clear();
    ratingController.clear();
  }

  Future<void> updateRating(int id) async {
    await dbHelper.update(
        'ratings',
        {
          'user': userController.text,
          'rating': int.parse(ratingController.text),
        },
        'id = ?',
        [id]);
    fetchRatings();
    userController.clear();
    ratingController.clear();
    setState(() {
      isUpdating = false;
      updatingRatingId = null;
    });
  }

  Future<void> deleteRating(int id) async {
    await dbHelper.delete('ratings', 'id = ?', [id]);
    fetchRatings();
  }

  void setUpdate(Rating rating) {
    userController.text = rating.user;
    ratingController.text = rating.rating.toString();
    setState(() {
      isUpdating = true;
      updatingRatingId = rating.id;
    });
  }

  Future<void> calculateMovieRating() async {
    final data =
        await dbHelper.query('ratings', 'movieId = ?', [widget.movieId]);
    double sum = 0.0;
    for (var rating in data) {
      sum += rating['rating'];
    }
    double averageRating = sum / data.length;

    await dbHelper.update(
        'movies',
        {
          'rating': averageRating,
        },
        'id = ?',
        [widget.movieId]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ratings'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: ratings.length,
              itemBuilder: (context, index) {
                final rating = Rating(
                  id: ratings[index]['id'],
                  movieId: ratings[index]['movieId'],
                  user: ratings[index]['user'],
                  rating: ratings[index]['rating'],
                );
                return ListTile(
                  title: Text('User: ${rating.user}'),
                  subtitle: Text('Rating: ${rating.rating}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          setUpdate(rating);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deleteRating(rating.id);
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
                  controller: userController,
                  decoration: InputDecoration(labelText: 'User'),
                ),
                TextField(
                  controller: ratingController,
                  decoration: InputDecoration(labelText: 'Rating'),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (isUpdating && updatingRatingId != null) {
                      updateRating(updatingRatingId!);
                    } else {
                      addRating();
                    }
                  },
                  child: Text(isUpdating ? 'Update Rating' : 'Add Rating'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Rating {
  final int id;
  final int movieId;
  final String user;
  final int rating;

  Rating(
      {required this.id,
      required this.movieId,
      required this.user,
      required this.rating});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'movieId': movieId,
      'user': user,
      'rating': rating,
    };
  }
}
