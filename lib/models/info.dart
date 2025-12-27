class Info {
  late final String id;
  late final String ownerName;
  String title;
  String content;
  late final DateTime date;

  Info({
    required this.id,
    required this.ownerName,
    required this.title,
    required this.content,
    required this.date,
  });

  Info.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      ownerName = map['ownerName'],
      title = map['title'],
      content = map['content'],
      date = DateTime.parse(map['date']);


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerName': ownerName,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
    };
  }
}
