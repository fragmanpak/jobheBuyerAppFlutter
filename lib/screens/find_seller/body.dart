import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jobheebuyer/constants.dart';
import 'package:location/location.dart';

class Body extends StatefulWidget {
  //const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _searchController = new TextEditingController();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  String lat,lng = '';
  @override
  void initState() {

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search NearBy Sellers'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              _searchField(),
              SizedBox(
                height: 5.0,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _sellerList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  _sellerList() {
  }

  _searchField() {
    return TextFormField(
      maxLength: 2,
      inputFormatters: [FilteringTextInputFormatter.allow(numberPattern)],
      controller: _searchController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please entered the number \n  between 1 to 55 km';
        }
        return null;
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Search Seller',
        hintText: 'search within 55 km',
        suffixIcon: IconButton(
          onPressed: () {
            fetchCurrentLocation();
            if (_formKey.currentState.validate()) {
              debugPrint("Valid");
              print('valid');
            }
            //_searchController.clear();
          },
          icon: Icon(
            Icons.search,
            color: kPrimaryColor,
          ),
        ),
      ),
    );
  }

  fetchCurrentLocation() async {
    Location location = new Location();

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return print('service is not enabled');
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return print('permission not granted');
      }
    }

    _locationData = await location.getLocation();
    lat= _locationData.latitude.toString();
    lng= _locationData.longitude.toString();
    print('lat = '+ lat + '\nlng = ' + lng);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

}
