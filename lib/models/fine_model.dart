class FineModel {
  final String id;
  final String category;
  final String violationName;
  final String description;
  final int fineAmount;
  final int? repeatOffenseAmount;
  final String lawReference;
  final String stateScope;
  final String source;
  final String? firstOffenseNote;
  final String? process;

  FineModel({
    required this.id,
    required this.category,
    required this.violationName,
    required this.description,
    required this.fineAmount,
    this.repeatOffenseAmount,
    required this.lawReference,
    required this.stateScope,
    required this.source,
    this.firstOffenseNote,
    this.process,
  });

  factory FineModel.fromJson(Map<String, dynamic> json) {
    return FineModel(
      id: json['id'] as String,
      category: json['category'] as String,
      violationName: json['violation_name'] as String,
      description: json['description'] as String,
      fineAmount: json['fine_amount'] as int,
      repeatOffenseAmount: json['repeat_offense_amount'] as int?,
      lawReference: json['law_reference'] as String,
      stateScope: json['state_scope'] as String,
      source: json['source'] as String,
      firstOffenseNote: json['first_offense_note'] as String?,
      process: json['process'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'violation_name': violationName,
      'description': description,
      'fine_amount': fineAmount,
      'repeat_offense_amount': repeatOffenseAmount,
      'law_reference': lawReference,
      'state_scope': stateScope,
      'source': source,
      'first_offense_note': firstOffenseNote,
      'process': process,
    };
  }
}
