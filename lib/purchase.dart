class Purchase {
  String id;
  String title;
  String description;
  String userId;

  Purchase({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'userId': userId,
    };
  }

  static Purchase fromMap(Map<String, dynamic> map) {
    return Purchase(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      userId: map['userId'],
    );
  }
}

