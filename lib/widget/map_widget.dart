import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:joven/config/url.dart';
import 'package:joven/service/location_service.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final LocationService _locationService = LocationService();
  final MapController _mapController = MapController();
  LatLng _center = const LatLng(-7.494855, 112.715499);
  String _address = 'Fetching address...';
  Map<String, dynamic> _data = {};
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final location = await _locationService.getCurrentPosition();
    setState(() {
      _center = LatLng(location!.latitude, location.longitude);
    });
    _mapController.move(_center, 17.0);
    _updateAddress();
  }

  Future<void> _updateAddress() async {
    _address = 'Fetching address...';
    String? address = await _locationService.getAddress(_center);
    if (address != null) {
      setState(() {
        _address = address;
      });
    }
  }

  void _onPositionChanged(MapCamera position, bool hasGesture) {
    if (hasGesture) {
      setState(() {
        _center = position.center;
      });

      if (_debounce?.isActive ?? false) {
        _debounce!.cancel();
      }

      _debounce = Timer(const Duration(milliseconds: 500), () {
        _updateAddress();
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          IconButton(
            onPressed: () {
              _data = {
                'latitude': _center.latitude,
                'longitude': _center.longitude,
                'address': _address,
              };
              Navigator.of(context).pop(_data);
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 17.0,
              onPositionChanged: _onPositionChanged,
            ),
            children: [
              TileLayer(
                urlTemplate: Url.MAP_LAYER,
              ),
            ],
          ),
          const Center(
            child: Icon(
              Icons.location_on,
              size: 40,
              color: Colors.red,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _address,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
