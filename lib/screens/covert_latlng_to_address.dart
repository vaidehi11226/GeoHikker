import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class LatlngToAddress extends StatefulWidget {
  const LatlngToAddress({super.key});

  @override
  State<LatlngToAddress> createState() => _LatlngToAddressState();
}

class _LatlngToAddressState extends State<LatlngToAddress> {
  String addressloc = "", stadd = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trekking app'),
        backgroundColor: Colors.yellow[900],
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(addressloc),
          Text(stadd),
          GestureDetector(
            onTap: () async {
              List<Location> locations =
                  await locationFromAddress("Malek, South Sudan");

              List<Placemark> placemarks = await placemarkFromCoordinates(
                  22.436854428649216, 47.28910464654421);
              setState(() {
                stadd = placemarks.reversed.last.country.toString() +
                    " " +
                    placemarks.reversed.last.subLocality.toString();
                addressloc = locations.last.longitude.toString() +
                    " " +
                    locations.last.latitude.toString();
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(color: Colors.green),
                child: Center(
                  child: Text('Convert'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
