import 'dart:convert' as convert;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'package:jobheebuyer/constants.dart';

class LocationService {
  Future<Map<String, dynamic>> getDirection(
      String origin, String destination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&sensor=false&mode=driving&key=$apiKey';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    print(json);
    var result = {
      'start_location': json['routes'][0]['legs'][0]['start_location'],
      'end_location': json['routes'][0]['legs'][0]['end_location'],
      'polyline': json['routes'][0]['overview_polyline']['points'],
      'polyline_decoded': PolylinePoints()
          .decodePolyline(json['routes'][0]['overview_polyline']['points']),
    };
    print(result);
    return result;
  }
}
