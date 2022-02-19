

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
typedef void MyCallback(LatLng latLng);

class MapWidget extends StatelessWidget {
  const MapWidget({
    required this.center,
    required this.mapController,
    required this.onMapCreated,
    required this.markers,
    required this.onTap,
    Key? key,
  })  : assert(center != null),
        assert(onMapCreated != null),
        super(key: key);

  final LatLng center;
  final GoogleMapController? mapController;
  final ArgumentCallback<GoogleMapController> onMapCreated;
  final MyCallback  onTap;
  final Set<Marker> markers;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      elevation: 4.0,
      child: SizedBox(
        height: 220.0,
        child: GoogleMap(
          onTap:onTap ,
          onMapCreated: onMapCreated,
          initialCameraPosition: CameraPosition(
            target: center,
            zoom: 16.0,
          ),
          markers: markers,
          zoomGesturesEnabled: false,
          rotateGesturesEnabled: false,
          tiltGesturesEnabled: false,
          scrollGesturesEnabled: false,
        ),
      ),
    );
  }
}
