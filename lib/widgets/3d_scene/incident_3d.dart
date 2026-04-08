import 'package:flutter/material.dart';
import 'vector3.dart';

class Incident3D {
  final String id;
  final String type; // traffic, parking, regulatory
  final Vector3 position;
  final String description;
  final DateTime date;

  Incident3D({
    required this.id,
    required this.type,
    required this.position,
    required this.description,
    required this.date,
  });

  Color getColor() {
    switch (type) {
      case 'traffic':
        return const Color(0xFF3498DB); // Blue
      case 'parking':
        return const Color(0xFFF39C12); // Orange
      case 'regulatory':
        return const Color(0xFFE74C3C); // Red
      default:
        return const Color(0xFF95A5A6); // Gray
    }
  }

  String getIcon() {
    switch (type) {
      case 'traffic':
        return '🚗';
      case 'parking':
        return '🅿️';
      case 'regulatory':
        return '⚖️';
      default:
        return '📍';
    }
  }
}
