class Order {
  String id;
  String purchaseId;
  String title;
  String description;
  String option;

  Order({
    required this.id,
    required this.purchaseId,
    required this.title,
    required this.description,
    required this.option,
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'purchaseId': purchaseId,
      'title': title,
      'description': description,
      'option': option,
    };
  }


  static Order fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      purchaseId: map['purchaseId'],
      title: map['title'],
      description: map['description'],
      option: map['option'],
    );
  }
}
