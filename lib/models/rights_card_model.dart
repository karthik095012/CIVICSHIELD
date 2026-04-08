class RightsCardModel {
  final String id;
  final String title;
  final String category;
  final String icon;
  final String summary;
  final String details;
  final List<String> dos;
  final List<String> donts;
  final List<Map<String, String>> myths;
  final List<String> emergencyContacts;
  final List<String> keywords;

  RightsCardModel({
    required this.id,
    required this.title,
    required this.category,
    required this.icon,
    required this.summary,
    required this.details,
    required this.dos,
    required this.donts,
    required this.myths,
    required this.emergencyContacts,
    required this.keywords,
  });

  factory RightsCardModel.fromJson(Map<String, dynamic> json) {
    return RightsCardModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      icon: json['icon'] as String,
      summary: json['summary'] as String,
      details: json['details'] as String,
      dos: List<String>.from(json['dos'] as List),
      donts: List<String>.from(json['donts'] as List),
      myths: List<Map<String, String>>.from(
        (json['myths'] as List).map((m) => Map<String, String>.from(m as Map)),
      ),
      emergencyContacts: List<String>.from(json['emergency_contacts'] as List),
      keywords: List<String>.from(json['keywords'] as List),
    );
  }
}
