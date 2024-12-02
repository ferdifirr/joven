import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:joven/config/url.dart';
import 'package:joven/routes.dart';
import 'package:joven/widget/home_drawer.dart';
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

  @override
  void initState() {
    super.initState();
    _initializeDefaultMarker();
    _getUsersLocation();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _initializeDefaultMarker() {
    markers.add(_buildMarker(_defaultLocation, _bearing));
  }

  Marker _buildMarker(LatLng position, double bearing) {
    return Marker(
      width: 80.0,
      height: 80.0,
      point: position,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Transform.rotate(
            angle: bearing * (3.14159265359 / 180),
            child: const Icon(
              Icons.navigation,
              color: Colors.blue,
              size: 40.0,
            ),
          ),
        ),
      ),
    );
  }

  void _getUsersLocation() {
    Geolocator.getPositionStream().listen((Position position) {
      final newPosition = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentPosition = newPosition;
        _bearing = position.heading;

        markers = [_buildMarker(newPosition, _bearing)];
      });

      if (_isInitialLocation) {
        _mapController.move(newPosition, _defaultZoom);
        _isInitialLocation = false;
      }
    });
  }

  Widget _buildProfilePicture() {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: (){
            Scaffold.of(context).openDrawer();
          },
          child: Container(
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
        );
      }
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 40,
      right: 20,
      left: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildProfilePicture(),
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
    );
  }

  Widget _buildFloatingActions() {
    return Column(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawer(),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _defaultLocation,
              initialZoom: _defaultZoom,
            ),
            children: [
              TileLayer(urlTemplate: Url.MAP_LAYER),
              MarkerLayer(markers: markers),
            ],
          ),
          _buildTopBar(),
        ],
      ),
      floatingActionButton: _buildFloatingActions(),
    );
  }
}
