import 'dart:math';

class Vector3 {
  double x, y, z;

  Vector3(this.x, this.y, this.z);

  Vector3 operator +(Vector3 other) => Vector3(x + other.x, y + other.y, z + other.z);
  Vector3 operator -(Vector3 other) => Vector3(x - other.x, y - other.y, z - other.z);
  Vector3 operator *(double scalar) => Vector3(x * scalar, y * scalar, z * scalar);
  Vector3 operator /(double scalar) => Vector3(x / scalar, y / scalar, z / scalar);

  double length() => sqrt(x * x + y * y + z * z);
  
  Vector3 normalize() {
    final len = length();
    if (len == 0) return Vector3(0, 0, 0);
    return this / len;
  }

  double dot(Vector3 other) => x * other.x + y * other.y + z * other.z;

  Vector3 cross(Vector3 other) => Vector3(
    y * other.z - z * other.y,
    z * other.x - x * other.z,
    x * other.y - y * other.x,
  );

  // Rotate around X axis
  Vector3 rotateX(double angle) {
    final cosAngle = cos(angle);
    final sinAngle = sin(angle);
    return Vector3(x, y * cosAngle - z * sinAngle, y * sinAngle + z * cosAngle);
  }

  // Rotate around Y axis
  Vector3 rotateY(double angle) {
    final cosAngle = cos(angle);
    final sinAngle = sin(angle);
    return Vector3(x * cosAngle + z * sinAngle, y, -x * sinAngle + z * cosAngle);
  }

  // Rotate around Z axis
  Vector3 rotateZ(double angle) {
    final cosAngle = cos(angle);
    final sinAngle = sin(angle);
    return Vector3(x * cosAngle - y * sinAngle, x * sinAngle + y * cosAngle, z);
  }

  static Vector3 zero() => Vector3(0, 0, 0);
}
