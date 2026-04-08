import 'package:flutter/material.dart';
import 'dart:math';
import 'vector3.dart';
import 'incident_3d.dart';

class Scene3D extends StatefulWidget {
  final List<Incident3D> incidents;
  final double width;
  final double height;

  const Scene3D({
    Key? key,
    required this.incidents,
    this.width = 400,
    this.height = 400,
  }) : super(key: key);

  @override
  State<Scene3D> createState() => _Scene3DState();
}

class _Scene3DState extends State<Scene3D> {
  double rotationX = 0.5;
  double rotationY = 0.5;
  double zoom = 150;
  Offset? _lastFocalPoint;
  double _zoomAtScaleStart = 150;
  int? selectedIncidentIndex;

  void _handleScaleStart(ScaleStartDetails details) {
    _lastFocalPoint = details.focalPoint;
    _zoomAtScaleStart = zoom;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      if (_lastFocalPoint != null) {
        final delta = details.focalPoint - _lastFocalPoint!;
        rotationY += delta.dx * 0.01;
        rotationX += delta.dy * 0.01;
      }
      _lastFocalPoint = details.focalPoint;

      // details.scale is relative to scale start.
      zoom = (_zoomAtScaleStart * details.scale).clamp(50.0, 300.0);
    });
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    _lastFocalPoint = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _handleScaleStart,
      onScaleUpdate: _handleScaleUpdate,
      onScaleEnd: _handleScaleEnd,
      child: Column(
        children: [
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF162A3F),
                  Color(0xFF0D1B2A),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF00897B), width: 2),
            ),
            child: CustomPaint(
              painter: Scene3DPainter(
                incidents: widget.incidents,
                rotationX: rotationX,
                rotationY: rotationY,
                zoom: zoom,
                selectedIncidentIndex: selectedIncidentIndex,
              ),
              child: Container(),
            ),
          ),
          const SizedBox(height: 16),
          _buildLegend(),
          const SizedBox(height: 12),
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF162A3F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00897B), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _legendItem('🚗 Traffic', const Color(0xFF3498DB)),
          _legendItem('🅿️ Parking', const Color(0xFFF39C12)),
          _legendItem('⚖️ Regulatory', const Color(0xFFE74C3C)),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFFE0F2F1)),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF162A3F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00897B), width: 1),
      ),
      child: Column(
        children: [
          const Text(
            'Drag to rotate • Pinch to zoom',
            style: TextStyle(fontSize: 12, color: Color(0xFFE0F2F1)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => setState(() {
                  rotationX = 0.5;
                  rotationY = 0.5;
                  zoom = 150;
                  selectedIncidentIndex = null;
                }),
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Reset View'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00897B),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Scene3DPainter extends CustomPainter {
  final List<Incident3D> incidents;
  final double rotationX;
  final double rotationY;
  final double zoom;
  final int? selectedIncidentIndex;

  Scene3DPainter({
    required this.incidents,
    required this.rotationX,
    required this.rotationY,
    required this.zoom,
    this.selectedIncidentIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw grid background
    _drawGrid(canvas, size);

    // Project and sort incidents by depth
    final projectedIncidents = <(int, Vector3, Offset)>[];
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    for (int i = 0; i < incidents.length; i++) {
      final pos = incidents[i].position
        .rotateX(rotationX)
        .rotateY(rotationY);

      // Perspective projection
      final scale = zoom / (pos.z + 200);
      final screenX = centerX + pos.x * scale;
      final screenY = centerY - pos.y * scale;

      if (screenX > -50 && screenX < size.width + 50 &&
          screenY > -50 && screenY < size.height + 50) {
        projectedIncidents.add((i, pos, Offset(screenX, screenY)));
      }
    }

    // Sort by depth (Z) - draw distant first
    projectedIncidents.sort((a, b) => a.$2.z.compareTo(b.$2.z));

    // Draw lines connecting incidents (optional 3D wireframe effect)
    _drawConnections(canvas, projectedIncidents);

    // Draw incidents
    for (final (index, pos, screenPos) in projectedIncidents) {
      final incident = incidents[index];
      final isSelected = index == selectedIncidentIndex;
      final scale = zoom / (pos.z + 200);

      _drawIncidentMarker(
        canvas,
        screenPos,
        incident,
        scale,
        isSelected,
      );
    }

    // Draw info panel if selected
    if (selectedIncidentIndex != null &&
        selectedIncidentIndex! < incidents.length) {
      _drawInfoPanel(canvas, size, incidents[selectedIncidentIndex!]);
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00897B).withOpacity(0.15)
      ..strokeWidth = 0.5;

    const gridSize = 50.0;
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Center crosshair
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    canvas.drawLine(
      Offset(centerX - 20, centerY),
      Offset(centerX + 20, centerY),
      Paint()
        ..color = const Color(0xFF00897B).withOpacity(0.5)
        ..strokeWidth = 1,
    );
    canvas.drawLine(
      Offset(centerX, centerY - 20),
      Offset(centerX, centerY + 20),
      Paint()
        ..color = const Color(0xFF00897B).withOpacity(0.5)
        ..strokeWidth = 1,
    );
  }

  void _drawConnections(Canvas canvas, List<(int, Vector3, Offset)> points) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = const Color(0xFF00897B).withOpacity(0.2)
      ..strokeWidth = 0.5;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i].$3, points[i + 1].$3, paint);
    }
  }

  void _drawIncidentMarker(
    Canvas canvas,
    Offset position,
    Incident3D incident,
    double scale,
    bool isSelected,
  ) {
    final radius = (8 + scale * 2).clamp(6.0, 20.0);
    final color = incident.getColor();

    // Glow effect
    if (isSelected) {
      canvas.drawCircle(
        position,
        radius + 8,
        Paint()
          ..color = color.withOpacity(0.2)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );
    }

    // Main circle
    canvas.drawCircle(
      position,
      radius,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );

    // Border
    canvas.drawCircle(
      position,
      radius,
      Paint()
        ..color = Colors.white.withOpacity(0.8)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );

    // Icon text in center
    final textPainter = TextPainter(
      text: TextSpan(
        text: incident.getIcon(),
        style: TextStyle(fontSize: 12 * scale.clamp(0.8, 1.5)),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      position - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  void _drawInfoPanel(Canvas canvas, Size size, Incident3D incident) {
    const panelWidth = 280.0;
    const panelHeight = 140.0;
    const padding = 16.0;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width - panelWidth - padding,
        padding,
        panelWidth,
        panelHeight,
      ),
      const Radius.circular(12),
    );

    // Background
    canvas.drawRRect(
      rect,
      Paint()
        ..color = const Color(0xFF0D1B2A).withOpacity(0.95)
        ..style = PaintingStyle.fill,
    );

    // Border
    canvas.drawRRect(
      rect,
      Paint()
        ..color = incident.getColor()
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );

    // Draw text
    double yOffset = padding + 8;
    _drawTextLine(canvas, '${incident.getIcon()} ${incident.type.toUpperCase()}',
        size.width - panelWidth + padding, yOffset, incident.getColor(), 13, true);

    yOffset += 20;
    _drawTextLine(canvas, incident.description,
        size.width - panelWidth + padding, yOffset, const Color(0xFFE0F2F1), 11, false);

    yOffset += 24;
    final dateStr = '${incident.date.day}/${incident.date.month}/${incident.date.year}';
    _drawTextLine(canvas, dateStr,
        size.width - panelWidth + padding, yOffset, const Color(0xFFA0D8D0), 10, false);
  }

  void _drawTextLine(Canvas canvas, String text, double x, double y, Color color,
      double fontSize, bool bold) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: bold ? 1 : 2,
      ellipsis: '...',
    );
    textPainter.layout(maxWidth: 250);
    textPainter.paint(canvas, Offset(x, y));
  }

  @override
  bool shouldRepaint(Scene3DPainter oldDelegate) =>
      oldDelegate.rotationX != rotationX ||
      oldDelegate.rotationY != rotationY ||
      oldDelegate.zoom != zoom ||
      oldDelegate.selectedIncidentIndex != selectedIncidentIndex;
}
