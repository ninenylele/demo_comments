class CommentsItem {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  CommentsItem({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  factory CommentsItem.fromJson(Map<String, dynamic> json) {
    return CommentsItem(
      postId: json['postId'],
      id: json['id'],
      name: json['name'],
      email: json['email'],
      body: json['body'],
    );
  }
}
