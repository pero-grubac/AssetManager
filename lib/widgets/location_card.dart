import 'package:asset_manager/models/location.dart';
import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({super.key, required this.location});
  final Location location;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.location_city),
                const SizedBox(width: 8),
                Text(location.address)
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Row(
                  children: [
                    const Icon(Icons.navigation),
                    const SizedBox(width: 8),
                    Text(location.longitude as String)
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.navigation),
                    const SizedBox(width: 8),
                    Text(location.latitude as String)
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
