import 'package:flutter/material.dart';

class CenteredCircularLoading extends StatelessWidget {
  const CenteredCircularLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
