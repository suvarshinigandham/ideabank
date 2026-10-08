class Idea {
  String title;
  String description;
  String category;
  String author;
  int likes;
  bool liked;
  bool saved;
  List<String> comments;

  Idea({
    required this.title,
    required this.description,
    required this.category,
    required this.author,
    this.likes = 0,
    this.liked = false,
    this.saved = false,
    List<String>? comments,
  }) : comments = comments ?? [];
}