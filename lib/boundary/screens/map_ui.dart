import 'dart:async';
import 'package:flutter/material.dart';
import 'package:foodapp/control/location_api.dart';
import 'package:foodapp/entity/directions.dart';
import 'package:foodapp/entity/restaurant.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapUI extends StatefulWidget {
  const MapUI({Key key, this.restaurant}) : super(key: key);

  final Restaurant restaurant;

  @override
  State<MapUI> createState() => _MapUIState();
}

class _MapUIState extends State<MapUI> {
  LocationData _userLocation;
  Directions _info;
  final Completer<GoogleMapController> _controller = Completer();

  final CameraPosition _kGooglePlex = const CameraPosition(
    zoom: 12,
    target: LatLng(1.3521, 103.8198),
  );

  @override
  void initState() {
    super.initState();
    LocationAPI.getLocation()
        .then((location) => setState(() => _userLocation = location));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Map"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: showPolyline,
              icon: const Icon(Icons.navigation_outlined),
            ),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            initialCameraPosition: _kGooglePlex,
            zoomControlsEnabled: true,
            myLocationEnabled: true,
            markers: _userLocation == null ? <Marker>{} : _createMarker(),
            onMapCreated: _controller.complete,
            polylines: {
              if (_info != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: Colors.red,
                  width: 5,
                  points: _info.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                ),
            },
          ),
          if (_info != null)
            Positioned(
              top: 20.0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Text(
                  '${widget.restaurant.distance.toStringAsFixed(2)} km, ${_info.totalDuration}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Set<Marker> _createMarker() {
    return {
      Marker(
        markerId: const MarkerId("origin"),
        position: LatLng(_userLocation.latitude, _userLocation.longitude),
        infoWindow: const InfoWindow(title: 'origin'),
      ),
      Marker(
        markerId: const MarkerId("destination"),
        position:
            LatLng(widget.restaurant.latitude, widget.restaurant.longitude),
      )
    };
  }

  void showPolyline() async {
    // Get directions
    final directions = await LocationAPI.getDirections(
      originLat: _userLocation.latitude,
      originLon: _userLocation.longitude,
      destLat: widget.restaurant.latitude,
      destLon: widget.restaurant.longitude,
    );
    setState(() => _info = directions);
  }
}
