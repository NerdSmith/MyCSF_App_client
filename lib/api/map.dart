import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mycsf_app_client/api/apiconfig.dart';
import 'package:mycsf_app_client/api/auth.dart';

class MyMap {
  int id;
  String building;
  int buildingLevel;
  String mapFile;

  MyMap({
    required this.id,
    required this.building,
    required this.buildingLevel,
    required this.mapFile
  });

  factory MyMap.fromJson(Map<String, dynamic> json) {
    return MyMap(
        id: json["id"],
        building: json["building"],
        buildingLevel: json["building_level"],
        mapFile: json["map_file"]
    );
  }
}

class MapController {
  static Future<Map<String, String>> getRuBuildings() async {
    final response = await http.get(
      Uri.parse('$apiUrl/api/map/choices/').replace(
          queryParameters: {"use_ru": "true"}
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': await Auth.getAuthStr()
      },
    );
    if (response.statusCode == 200) {
      var decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is Map<String, dynamic>) {
        var dictionary = <String, String>{};

        decoded.forEach((key, value) {
          if (value is String) {
            dictionary[key] = value;
          }
        });
        return dictionary;
      }
      throw Exception("Cant receive maps");
    }
    else {
      throw Exception("Cant receive maps");
    }
  }

  static Future<List<MyMap>> getMapsByBuilding(String buildingStr) async {
    final response = await http.get(
      Uri.parse('$apiUrl/api/map/').replace(
          queryParameters: {"building": buildingStr}
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': await Auth.getAuthStr()
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));

      List<MyMap> objects = [];

      for (var jsonObj in jsonList) {
        MyMap map = MyMap.fromJson(jsonObj);
        objects.add(map);
      }
      return objects;
    }
    else {
      throw Exception("Cant receive maps");
    }
  }
}