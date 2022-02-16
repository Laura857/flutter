import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class afficherCarte extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return afficherCarteState();
  }
}

class afficherCarteState extends State<afficherCarte> {
  Completer<GoogleMapController> controller = Completer();
  Position? maPosition;

  Future<Position> determinatePosition() async {
    bool service = await Geolocator.isLocationServiceEnabled();
    if (!service) {
      return Future.error("Nous n'avons pas accès à votre localisation");
    }
    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        return Future.error("Nous n'avons pas accès à votre localisation");
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    determinatePosition().then((value) {
      setState(() {
        maPosition = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
        initialCameraPosition: (maPosition == null)
            ? CameraPosition(target: LatLng(48.858370, 2.294481), zoom: 14.0)
            : CameraPosition(
                target: LatLng(maPosition!.latitude, maPosition!.longitude),
                zoom: 14.0),
        onMapCreated: (GoogleMapController mapController) async {
          String style = await DefaultAssetBundle.of(context)
              .loadString("lib/json/mapsStyle.json");
          mapController.setMapStyle(style);
          controller.complete(mapController);
        },
        myLocationEnabled: true);
  }
}
