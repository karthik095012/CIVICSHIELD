// Legal Service Locations Model
class LegalServiceLocation {
  final String id;
  final String name;
  final String type; // 'consultancy', 'advocate', 'court', 'law_clinic'
  final String address;
  final double latitude;
  final double longitude;
  final double rating; // 0.0 to 5.0
  final int reviewCount;
  final List<String> specialization; // e.g., ['criminal', 'civil', 'family']
  final String contactNumber;
  final String emailAddress;
  final String availability; // 'open', 'closed', 'holiday'
  final String workingHours;
  final bool isVerified;
  final String description;
  int favoriteCount;

  LegalServiceLocation({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.reviewCount,
    required this.specialization,
    required this.contactNumber,
    required this.emailAddress,
    required this.availability,
    required this.workingHours,
    required this.isVerified,
    required this.description,
    this.favoriteCount = 0,
  });

  factory LegalServiceLocation.fromJson(Map<String, dynamic> json) {
    return LegalServiceLocation(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['review_count'] as int,
      specialization: List<String>.from(json['specialization'] as List? ?? []),
      contactNumber: json['contact_number'] as String,
      emailAddress: json['email_address'] as String,
      availability: json['availability'] as String,
      workingHours: json['working_hours'] as String,
      isVerified: json['is_verified'] as bool,
      description: json['description'] as String,
      favoriteCount: json['favorite_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'review_count': reviewCount,
      'specialization': specialization,
      'contact_number': contactNumber,
      'email_address': emailAddress,
      'availability': availability,
      'working_hours': workingHours,
      'is_verified': isVerified,
      'description': description,
      'favorite_count': favoriteCount,
    };
  }

  LegalServiceLocation copyWith({int? favoriteCount}) {
    return LegalServiceLocation(
      id: id,
      name: name,
      type: type,
      address: address,
      latitude: latitude,
      longitude: longitude,
      rating: rating,
      reviewCount: reviewCount,
      specialization: specialization,
      contactNumber: contactNumber,
      emailAddress: emailAddress,
      availability: availability,
      workingHours: workingHours,
      isVerified: isVerified,
      description: description,
      favoriteCount: favoriteCount ?? this.favoriteCount,
    );
  }

  String getTypeLabel() {
    switch (type) {
      case 'consultancy':
        return 'Legal Consultancy';
      case 'advocate':
        return 'Advocate';
      case 'court':
        return 'Court';
      case 'law_clinic':
        return 'Law Clinic';
      default:
        return type;
    }
  }

  String getAvailabilityStatus() {
    switch (availability) {
      case 'open':
        return '🟢 Open';
      case 'closed':
        return '🔴 Closed';
      case 'holiday':
        return '🟡 Holiday';
      default:
        return availability;
    }
  }
}
