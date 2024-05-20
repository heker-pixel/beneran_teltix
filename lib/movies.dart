class Movie {
  final int id;
  final String name;
  final double rating;

  Movie({required this.id, required this.name, required this.rating});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'rating': rating,
    };
  }
}
