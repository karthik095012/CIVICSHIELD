class SchemeModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String eligibility;
  final String benefitAmount;
  final String howToApply;
  final String deadline;
  final String officialLink;
  final List<String> targetGroup;
  final String stateScope;
  bool isBookmarked;

  SchemeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.eligibility,
    required this.benefitAmount,
    required this.howToApply,
    required this.deadline,
    required this.officialLink,
    required this.targetGroup,
    required this.stateScope,
    this.isBookmarked = false,
  });

  factory SchemeModel.fromJson(Map<String, dynamic> json) {
    return SchemeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      eligibility: json['eligibility'] as String,
      benefitAmount: json['benefit_amount'] as String,
      howToApply: json['how_to_apply'] as String,
      deadline: json['deadline'] as String,
      officialLink: json['official_link'] as String,
      targetGroup: List<String>.from(json['target_group'] as List),
      stateScope: json['state_scope'] as String,
    );
  }

  SchemeModel copyWith({bool? isBookmarked}) {
    return SchemeModel(
      id: id,
      name: name,
      description: description,
      category: category,
      eligibility: eligibility,
      benefitAmount: benefitAmount,
      howToApply: howToApply,
      deadline: deadline,
      officialLink: officialLink,
      targetGroup: targetGroup,
      stateScope: stateScope,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}
