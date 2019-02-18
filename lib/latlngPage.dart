import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LatLongPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LatLongPageState();
}

class LatLongPageState extends State<LatLongPage> {
  Map<String, double> currentLocation = new Map<String, double>();
  Map<String, dynamic> address = new Map();
  StreamSubscription<Map<String, double>> locationSubscription;
  String error;
  Location location = new Location();

  void initPlatformState() async {
    Map<String, double> myLocation;
    try {
      myLocation = await location.getLocation();
      error = '';
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED')
        error = "Permission denied";
      else if (e.code == "PERMISSION_DENIED_NEVER_ASK")
        error = "Permission denied, ask user to enable it";
      myLocation = null;
    }
    if (mounted)
      setState(() {
        currentLocation = myLocation;
      });
  }

  @override
  void initState() {
    currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;
    super.initState();
  }

  Future<String> getData() async {
    //PUT YOUR API_KEY HERE
    String key = '';
    var response = await http.get(
        Uri.encodeFull(
            "https://maps.googleapis.com/maps/api/geocode/json?key=$key&latlng=${currentLocation['latitude']},${currentLocation['longitude']}"),
        headers: {'Accept': 'application/json'});

    if (response.statusCode == 404) {
      if (mounted)
        this.setState(() {
          address = {};
        });
      return 'Error';
    } else {
      if (mounted)
        this.setState(() {
          address = json.decode(response.body);
        });

      return 'Success';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'Busca por Localização',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: RaisedButton(
                  elevation: 5,
                  child: Text(
                    'Meu endereço atual',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.red,
                  disabledColor: Colors.grey,
                  onPressed: () {
                    initPlatformState();
                    locationSubscription = location
                        .onLocationChanged()
                        .listen((Map<String, double> result) {
                      if (mounted)
                        setState(() {
                          currentLocation = result;
                        });
                      getData();
                    });
                  }),
            ),
            SizedBox(
              height: 100,
            ),
            currentLocation['latitude'] == 0.0 || address.isEmpty
                ? SizedBox()
                : Card(
                    child: ListTile(
                      title: Text(address['results'][0]['address_components'][1]
                                  ['long_name']
                              .toString() +
                          ', ' +
                          address['results'][0]['address_components'][0]
                                  ['long_name']
                              .toString() +
                          ' - ' +
                          address['results'][0]['address_components'][2]
                                  ['long_name']
                              .toString()),
                      subtitle: Text(address['results'][0]['address_components']
                                  [3]['long_name']
                              .toString() +
                          ', ' +
                          address['results'][0]['address_components'][4]
                                  ['short_name']
                              .toString()),
                    ),
                  )
          ],
        ));
  }
}
