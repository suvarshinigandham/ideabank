class Idea {
  String title;
  String description;
  String category;
  String author;
  int likes;
  bool liked;
  bool saved;
  List<String> comments;
  DateTime createdAt;

  Idea({
    required this.title,
    required this.description,
    required this.category,
    required this.author,
    this.likes = 0,
    this.liked = false,
    this.saved = false,
    List<String>? comments,
    DateTime? createdAt,
  }) : comments = comments ?? [],
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'author': author,
      'likes': likes,
      'liked': liked,
      'saved': saved,
      'comments': comments,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Idea.fromJson(Map<String, dynamic> json) {
    return Idea(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'Other',
      author: json['author'] ?? 'Unknown',
      likes: json['likes'] ?? 0,
      liked: json['liked'] ?? false,
      saved: json['saved'] ?? false,
      comments: List<String>.from(json['comments'] ?? []),
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
