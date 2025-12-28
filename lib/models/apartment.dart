import 'package:flutter/material.dart';
import 'package:oga/models/rent_period.dart';

import '../helper/helper.dart';

class Apartment {
  final String id;
  final String name;
  Color backgroundColor;
  String description;
  String? occupantId;
  List<Rent> rents = [];

  Apartment(
      {this.occupantId,
      required this.name,
      required this.id,
      required this.description,
      required this.backgroundColor});

  Apartment.fromMap(Map<String, dynamic> mapData)
      : id = mapData['id'],
        description = mapData['desc'],
        name = mapData['name'],
        backgroundColor = colorMap[mapData['colorKey']] ?? Colors.white,
        rents = List<Rent>.from(mapData['rents']!.map((e) => Rent.fromMap(e)))
            .toList(),
        occupantId = mapData['occupantId'];



  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "occupantId": occupantId,
      "rents": rents.map((rent) => rent.toMap()).toList(),
      "colorKey":
          colorMap.keys.firstWhere((k) => colorMap[k] == backgroundColor),
      "desc": description
    };
  }

  /// This method to retrieve the actual rent.
  Rent rent(int year, int month) {
    var date = DateTime(year, month);
    for (Rent rent in rents) {
      if (rent.endDate == null) {
        if (date.isAfter(rent.startDate)) {
          return rent;
        }
      }
      if (date.isAfter(rent.startDate) && date.isBefore(rent.endDate!)) {
        return rent;
      }
    }

    return rents.first;
  }

  void modifyRent(Rent rent) {
    if (rents.isEmpty) {
      rents.add(rent);
      return;
    }
    for (Rent r in rents) {
      if (r.endDate == null) {
        r.endDate = rent.startDate;
        rents.add(rent);
        return;
      }
    }
  }

  Rent getActualRent() {
    Rent rent = rents.first;
    for (Rent r in rents) {
      if (r.endDate == null) {
        rent = r;
      }
    }
    return rent;
  }

  @override
  String toString() {
    return 'Lodging{id: $id, description: $description, occupantId: $occupantId}';
  }
}
