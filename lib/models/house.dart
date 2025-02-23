import 'package:flutter/material.dart';
import 'package:oga/helper/helper.dart';
import 'apartment.dart';

class House {
  final String id;
  final String name;
  final String desc;
  final String address;
  final Color backgroundColor;
  final int constructionYear;
  final List<Apartment> apartments;
  final String imageName;

  House(
      {required this.id,
      required this.desc,
      required this.address,
      required this.name,
      required this.backgroundColor,
      required this.constructionYear,
      required this.apartments,
      required this.imageName});

  House.fromMap(Map<String, dynamic> mapData, String docId)
      : id = docId,
        name = mapData['name'] ?? '',
        desc = mapData['desc'] ?? '',
        address = mapData['address'] ?? '',
        imageName = mapData['imageUrl'] ?? '',
        backgroundColor = colorMap[mapData['colorKey']] ?? Colors.white,
        constructionYear = mapData['constructionYear'],
        apartments = List<Apartment>.from(
            mapData['apartments']!.map((e) => Apartment.fromMap(e))).toList();

  var usdKey = colorMap.keys
      .firstWhere((k) => colorMap[k] == Colors.white, orElse: () => "");

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "colorKey":
          colorMap.keys.firstWhere((k) => colorMap[k] == backgroundColor),
      "apartments": apartments.map((apartment) => apartment.toMap()).toList(),
      "desc": desc,
      "imageName": imageName,
      "constructionYear": constructionYear,
    };
  }
}
