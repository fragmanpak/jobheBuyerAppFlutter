import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jobheebuyer/services/location_service.dart';

class MyMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition initCameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  TextEditingController _searchController = TextEditingController();
  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polyline = Set<Polyline>();
  int _polylineCounter = 1;

  @override
  void initState() {
    super.initState();
    _setMarker(LatLng(37.42796133580664, -122.085749655962));
  }

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('Home'),
        position: point,
      ));
    });
  }

  void _setPolyline(List<PointLatLng> points) {
    final polyLineIdVal = 'polyline$_polylineCounter';
    _polylineCounter++;
    _polyline.add(Polyline(
        polylineId: PolylineId(polyLineIdVal),
        width: 2,
        color: Colors.blue,
        points: points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList()));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Google Map'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: _searchController,
                )),
                IconButton(
                    onPressed: () async {
                      var directions = await LocationService().getDirection(
                          'Lahore, Punjab, Pakistan',
                          'Faisalabad, Punjab, Pakistan');
                      _setPolyline(directions['polyline_decoded']);
                    },
                    icon: Icon(Icons.search))
              ],
            ),
            Expanded(
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: initCameraPosition,
                markers: _markers,
                polylines: _polyline,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            )
          ],
        ));
  }
}
