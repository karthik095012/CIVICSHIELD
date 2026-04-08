// Legal Document Analysis Model

class DocumentAnalysis {
  final String documentName;
  final String uploadedAt;
  final String documentType; // 'pdf', 'text', 'image'
  final String content;
  final CaseAnalysis caseAnalysis;
  final CasePrediction casePrediction;
  final BiasDetection biasDetection;

  DocumentAnalysis({
    required this.documentName,
    required this.uploadedAt,
    required this.documentType,
    required this.content,
    required this.caseAnalysis,
    required this.casePrediction,
    required this.biasDetection,
  });

  Map<String, dynamic> toMap() {
    return {
      'documentName': documentName,
      'uploadedAt': uploadedAt,
      'documentType': documentType,
      'content': content,
      'caseAnalysis': caseAnalysis.toMap(),
      'casePrediction': casePrediction.toMap(),
      'biasDetection': biasDetection.toMap(),
    };
  }

  factory DocumentAnalysis.fromMap(Map<String, dynamic> map) {
    return DocumentAnalysis(
      documentName: map['documentName'] ?? '',
      uploadedAt: map['uploadedAt'] ?? '',
      documentType: map['documentType'] ?? 'text',
      content: map['content'] ?? '',
      caseAnalysis: CaseAnalysis.fromMap(map['caseAnalysis'] ?? {}),
      casePrediction: CasePrediction.fromMap(map['casePrediction'] ?? {}),
      biasDetection: BiasDetection.fromMap(map['biasDetection'] ?? {}),
    );
  }
}

// Case Analysis Results
class CaseAnalysis {
  final String summary;
  final List<String> keyPoints;
  final String applicableLaws;
  final String precedents;
  final String strengths;
  final String weaknesses;

  CaseAnalysis({
    required this.summary,
    required this.keyPoints,
    required this.applicableLaws,
    required this.precedents,
    required this.strengths,
    required this.weaknesses,
  });

  Map<String, dynamic> toMap() {
    return {
      'summary': summary,
      'keyPoints': keyPoints,
      'applicableLaws': applicableLaws,
      'precedents': precedents,
      'strengths': strengths,
      'weaknesses': weaknesses,
    };
  }

  factory CaseAnalysis.fromMap(Map<String, dynamic> map) {
    return CaseAnalysis(
      summary: map['summary'] ?? '',
      keyPoints: List<String>.from(map['keyPoints'] ?? []),
      applicableLaws: map['applicableLaws'] ?? '',
      precedents: map['precedents'] ?? '',
      strengths: map['strengths'] ?? '',
      weaknesses: map['weaknesses'] ?? '',
    );
  }
}

// Case Prediction with Explainability
class CasePrediction {
  final String outcomePredictor;
  final int successProbability; // 0-100
  final String recommendation;
  final List<String> factors;
  final String explainability;

  CasePrediction({
    required this.outcomePredictor,
    required this.successProbability,
    required this.recommendation,
    required this.factors,
    required this.explainability,
  });

  Map<String, dynamic> toMap() {
    return {
      'outcomePredictor': outcomePredictor,
      'successProbability': successProbability,
      'recommendation': recommendation,
      'factors': factors,
      'explainability': explainability,
    };
  }

  factory CasePrediction.fromMap(Map<String, dynamic> map) {
    return CasePrediction(
      outcomePredictor: map['outcomePredictor'] ?? 'Pending',
      successProbability: map['successProbability'] ?? 0,
      recommendation: map['recommendation'] ?? '',
      factors: List<String>.from(map['factors'] ?? []),
      explainability: map['explainability'] ?? '',
    );
  }
}

// Bias Detection in Judicial Decisions
class BiasDetection {
  final bool biasDetected;
  final List<BiasIndicator> indicators;
  final String riskLevel; // 'low', 'medium', 'high'
  final String recommendations;
  final String fairnessScore;

  BiasDetection({
    required this.biasDetected,
    required this.indicators,
    required this.riskLevel,
    required this.recommendations,
    required this.fairnessScore,
  });

  Map<String, dynamic> toMap() {
    return {
      'biasDetected': biasDetected,
      'indicators': indicators.map((i) => i.toMap()).toList(),
      'riskLevel': riskLevel,
      'recommendations': recommendations,
      'fairnessScore': fairnessScore,
    };
  }

  factory BiasDetection.fromMap(Map<String, dynamic> map) {
    return BiasDetection(
      biasDetected: map['biasDetected'] ?? false,
      indicators: (map['indicators'] ?? [])
          .map<BiasIndicator>((i) => BiasIndicator.fromMap(i))
          .toList(),
      riskLevel: map['riskLevel'] ?? 'low',
      recommendations: map['recommendations'] ?? '',
      fairnessScore: map['fairnessScore'] ?? '',
    );
  }
}

// Individual Bias Indicator
class BiasIndicator {
  final String type;
  final String description;
  final String severity; // 'low', 'medium', 'high'

  BiasIndicator({
    required this.type,
    required this.description,
    required this.severity,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'description': description,
      'severity': severity,
    };
  }

  factory BiasIndicator.fromMap(Map<String, dynamic> map) {
    return BiasIndicator(
      type: map['type'] ?? '',
      description: map['description'] ?? '',
      severity: map['severity'] ?? 'low',
    );
  }
}
