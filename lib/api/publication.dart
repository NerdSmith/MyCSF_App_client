import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'apiconfig.dart';
import 'package:http/http.dart' as http;

import 'auth.dart';

class Publication {
  String? title;
  String? bodyText;
  String? publicationDatetime;
  int? event;
  String? image;

  Publication({this.title, this.bodyText, this.publicationDatetime, this.event,
      this.image});

  DateTime getDatetime() {
    return DateTime.parse(publicationDatetime!);
  }

  String getDatetimeRepr() {
    return DateFormat('d MMM y HH:mm', 'ru').format(getDatetime());
  }
}

class PublicationController {
  static Future<List<Publication>> fetchPubs({int limit = 10, int offset = 0}) async {
    var url = Uri.parse('$apiUrl/api/publication?limit=$limit&offset=$offset');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      List<Publication> res = [];
      for (var result in jsonData['results']) {
        var newPub = Publication(
          title: result['title'],
          bodyText: result['body_text'],
          publicationDatetime: result['publication_datetime'],
          event: result['event'],
          image: result['image']
        );
        res.add(newPub);
      }
      return res;
    } else {
      throw Exception('Failed to fetch news');
    }
  }
}

class PublicationBloc extends Cubit<List<Publication>> {
  PublicationBloc() : super([]);
  int offset = 0;
  int limit = 10;

  Future<void> fetchPubs() async {
    try {
      final pubs = await PublicationController.fetchPubs(limit: limit, offset: offset);
      emit([...state, ...pubs]);
      offset += limit;
    }
    catch (e) {
      print("Pubs get err: $e");
    }
  }
}