import 'package:uuid/uuid.dart';

class Authority {
  final String id;
  final String name;
  final String description;
  final String category;
  final String phone;
  final String? email;
  final String? website;
  final String address;
  final String city;
  final String state;
  final double latitude;
  final double longitude;
  final List<String> services;
  final int helpfulCount;
  final DateTime createdAt;

  Authority({
    String? id,
    required this.name,
    required this.description,
    required this.category,
    required this.phone,
    this.email,
    this.website,
    required this.address,
    required this.city,
    required this.state,
    required this.latitude,
    required this.longitude,
    required this.services,
    this.helpfulCount = 0,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  factory Authority.fromJson(Map<String, dynamic> json) {
    return Authority(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      website: json['website'] as String?,
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      services: List<String>.from(json['services'] as List),
      helpfulCount: json['helpfulCount'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'phone': phone,
      'email': email,
      'website': website,
      'address': address,
      'city': city,
      'state': state,
      'latitude': latitude,
      'longitude': longitude,
      'services': services,
      'helpfulCount': helpfulCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class AuthorityCategory {
  final String id;
  final String name;
  final String icon;
  final String description;

  const AuthorityCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
  });

  static List<AuthorityCategory> getAllCategories() {
    return [
      const AuthorityCategory(
        id: 'traffic',
        name: 'Traffic Police',
        icon: '🚔',
        description: 'Traffic law enforcement and road safety',
      ),
      const AuthorityCategory(
        id: 'anticorruption',
        name: 'Anti-Corruption',
        icon: '⚖️',
        description: 'Public grievance and anti-corruption bodies',
      ),
      const AuthorityCategory(
        id: 'consumer',
        name: 'Consumer Protection',
        icon: '🛡️',
        description: 'Consumer rights and protection',
      ),
      const AuthorityCategory(
        id: 'legal',
        name: 'Legal Aid',
        icon: '📜',
        description: 'Legal aid and court services',
      ),
      const AuthorityCategory(
        id: 'rtiaccessibility',
        name: 'RTI/Accessibility',
        icon: '📋',
        description: 'Right to Information services',
      ),
      const AuthorityCategory(
        id: 'women',
        name: 'Women Safety',
        icon: '👩',
        description: 'Women safety and support services',
      ),
    ];
  }
}
