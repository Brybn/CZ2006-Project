import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


class MapSample extends StatefulWidget {

  const MapSample({Key key, double dest_lat, double dest_lon})
      : destLat = dest_lat, destLon = dest_lon, super(key: key);

  final double destLat;
  final double destLon;


  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  double destLat;
  double destLon;

  @override
  void initState() {
    destLat = widget.destLat;
    destLon = widget.destLon;
    super.initState();

  }

  Future<LocationData> getLoc() async{
    Location location = Location();
    return await location.getLocation();

  }

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(1.3530, 103.8198),
    zoom: 11.5,
  );

  GoogleMapController _googleMapController;
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPIKey = "AIzaSyDgZ_CBpZG6jIjuOUmC9fcmTAlHLM2gkjU";

  Marker _origin;
  Marker _destination;
  Map<PolylineId,Polyline> polylines = {};

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getLoc(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
        final LocationData currLoc = snapshot.data;
        if(snapshot.hasData){
          _addMarker(currLoc);
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: const Text('Google Maps'),
            ),
            body: Stack(
              alignment: Alignment.center,
              children: [
                GoogleMap(
                  initialCameraPosition: _initialCameraPosition,
                  onMapCreated: (controller) => _googleMapController = controller,
                  markers: {_origin, _destination},
                  polylines: Set<Polyline>.of(polylines.values),
            ),
            ]
          ),
        );
        }
        return const Center(child: CircularProgressIndicator());
    }

    );
  }

  void _addMarker(LocationData currLoc) async {
      _origin = Marker(
        markerId: const MarkerId('origin'),
        infoWindow: const InfoWindow(title: 'Origin', ),
        icon:
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: LatLng(currLoc.latitude,currLoc.longitude),
      );
      _destination = Marker(
        markerId: const MarkerId('destination'),
        infoWindow: const InfoWindow(title: 'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: LatLng(destLat,destLon),
      );

      List<LatLng> polylineCoordinates = [];
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        PointLatLng(currLoc.latitude, currLoc.longitude),
        PointLatLng(destLat, destLon),
        travelMode: TravelMode.driving,
      );

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      } else {
        print(result.errorMessage);
      }
      addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }
}

