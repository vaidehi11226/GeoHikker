import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:uuid/uuid.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _controllertext = TextEditingController();

  var uuid = Uuid();
  String _sessionToken = '122344';
  List<Marker> _marker = [];

  static final CameraPosition _kGooglePlex = const CameraPosition(
    target:
        LatLng(19.2386327690597, 72.87090109573214), // Default initial position
    zoom: 14.4746,
  );
  FloatingSearchBarController floatingSearchBarController =
      FloatingSearchBarController();

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission();
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();

    // Add the initial marker when the app is opened
    _marker.add(
      Marker(
        markerId: MarkerId('1'),
        position: LatLng(19.2386327690597, 72.87090109573214),
        infoWindow: InfoWindow(title: 'The title of the marker'),
      ),
    );
    _controllertext.addListener(() {
      onChange();
    });
  }

  void onChange() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_controllertext.text);
  }

  void getSuggestion(String text) async {}

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            getUserCurrentLocation().then((value) async {
              print('My Current Location');
              print(
                  value.latitude.toString() + " " + value.longitude.toString());
              _marker.add(
                Marker(
                  markerId: MarkerId('2'),
                  position: LatLng(value.latitude, value.longitude),
                  infoWindow: InfoWindow(
                    title: "My Current location",
                  ),
                ),
              );
              CameraPosition cameraPosition = CameraPosition(
                  zoom: 14, target: LatLng(value.latitude, value.longitude));
              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(
                  CameraUpdate.newCameraPosition(cameraPosition));
              setState(() {});
            });
          },
          child: const Icon(
            Icons.location_disabled_outlined,
          )),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _kGooglePlex,
            mapType: MapType.normal,
            markers: Set<Marker>.of(_marker),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          FloatingSearchBar(
            controller: floatingSearchBarController,
            hint: 'Search...',
            scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
            transitionDuration: const Duration(milliseconds: 800),
            transitionCurve: Curves.easeInOut,
            physics: const BouncingScrollPhysics(),
            axisAlignment: isPortrait ? 0.0 : -1.0,
            openAxisAlignment: 0.0,
            width: isPortrait ? 600 : 500,
            debounceDelay: const Duration(milliseconds: 500),
            onQueryChanged: (query) {
              // Perform the search operation here
              // ...
            },
            queryStyle: TextStyle(color: Colors.black, fontSize: 18.0),
            hintStyle: TextStyle(color: Colors.black38, fontSize: 18.0),
            iconColor: Colors.black,
            backgroundColor: Colors.white,
            borderRadius: BorderRadius.circular(24),
            builder: (BuildContext context, Animation<double> transition) {
              // Return your page layout here
              return ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Material(
                  color: Colors.white,
                  elevation: 4.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Your widgets go here
                    ],
                  ),
                ),
              );
            },
            // ... rest of the FloatingSearchBar properties ...
          ),
        ],
      ),
    );
  }
}
