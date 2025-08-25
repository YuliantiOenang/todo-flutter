class User {
  final String? id;
  final String name;
  final String title;
  final String company;

  User({
    this.id,
    required this.name,
    required this.title,
    required this.company,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'title': title,
      'company': company,
    };
  }

  factory User.fromMap(Map<String, dynamic> map, String id) {
    return User(
      id: id,
      name: map['name'] ?? '',
      title: map['title'] ?? '',
      company: map['company'] ?? '',
    );
  }
}
