import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:joven/config/url.dart';
import 'package:joven/routes.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MapController _mapController = MapController();
  final LatLng _defaultLocation = const LatLng(-7.494855, 112.715499);
  LatLng? _currentPosition;
  double _bearing = 0.0;
  bool _isInitialLocation = true;
  final double _defaultZoom = 17.0;
  List<Marker> markers = [];

  void _getUsersLocation() async {
    Stream<Position> positionStream = Geolocator.getPositionStream();
    positionStream.listen((Position position) {
      final newPosition = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentPosition = newPosition;
        _bearing = position.heading;

        markers
          ..clear()
          ..add(
            Marker(
              width: 80.0,
              height: 80.0,
              point: newPosition,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Transform.rotate(
                    angle: _bearing * (3.14159265359 / 180),
                    child: const Icon(
                      Icons.navigation, // Ikon marker
                      color: Colors.blue,
                      size: 40.0,
                    ),
                  ),
                ),
              ),
            ),
          );
      });

      if (_isInitialLocation) {
        _mapController.move(newPosition, _defaultZoom);
        _isInitialLocation = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    markers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: _defaultLocation,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.navigation,
              color: Colors.blue,
              size: 40.0,
            ),
          ),
        ),
      ),
    );

    _getUsersLocation();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _defaultLocation,
                initialZoom: _defaultZoom,
              ),
              children: [
                TileLayer(
                  urlTemplate: Url.MAP_LAYER,
                ),
                MarkerLayer(
                  markers: markers,
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            left: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(
                      BorderSide(color: Colors.grey, width: 2),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://avatars.githubusercontent.com/u/57899010?v=4',
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Row(
                    children: [
                      Text('Lagi offline'),
                      SizedBox(width: 5),
                      Icon(Icons.arrow_forward_ios_rounded),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.power_settings_new),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _mapController.move(
                _currentPosition ?? _defaultLocation,
                _defaultZoom,
              );
            },
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.store);
            },
            child: const Icon(Icons.store),
          ),
        ],
      ),
    );
  }
}
