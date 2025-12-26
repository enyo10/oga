class Rent {
  int? id;
  final DateTime startDate;
  DateTime? endDate;
  final double value;

  Rent({this.id, required this.startDate, this.endDate, required this.value});

  Rent.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        value = double.parse(map['rent'].toString()),
        startDate = DateTime.parse(map['startDate']),
        endDate =
            map['endDate'] != null ? DateTime.parse(map['endDate']) : null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rent': value,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String()
    };
  }
}
