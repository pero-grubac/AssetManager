import 'package:asset_manager/models/asset_location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  static const id = 'map_screen';

  const MapScreen({
    super.key,
    this.assetLocation,
    this.isSelecting = true,
  });
  final AssetLocation? assetLocation;
  final bool isSelecting;
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late AssetLocation _assetLocation;
  bool _isMapLoading = true;
  LatLng? pickedLocation;

  @override
  void initState() {
    super.initState();
    _assetLocation = widget.assetLocation ??
        AssetLocation(
          latitude: 37.422,
          longitude: -122.084,
          address: 'address',
        );
  }

  void _onMarkerTap(LatLng position) {
    print('Marker tapped at: ${position.latitude}, ${position.longitude}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? 'Pick your location' : 'Your location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                Navigator.of(context).pop(pickedLocation);
              },
            )
        ],
      ),
      body: Stack(children: [
        GoogleMap(
          onTap: !widget.isSelecting
              ? null
              : (position) {
                  setState(() {
                    pickedLocation = position;
                  });
                },
          initialCameraPosition: CameraPosition(
            target: LatLng(
              _assetLocation.latitude,
              _assetLocation.longitude,
            ),
            zoom: 16,
          ),
          markers: (pickedLocation == null && widget.isSelecting)
              ? {}
              : {
                  Marker(
                    markerId: MarkerId(_assetLocation.id),
                    position: pickedLocation ??
                        LatLng(
                          _assetLocation.latitude,
                          _assetLocation.longitude,
                        ),
                    onTap: () => _onMarkerTap(
                      pickedLocation ??
                          LatLng(
                            _assetLocation.latitude,
                            _assetLocation.longitude,
                          ),
                    ),
                  )
                },
          onMapCreated: (controller) {
            setState(() {
              _isMapLoading = false;
            });
          },
        ),
        if (_isMapLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ]),
    );
  }
}
