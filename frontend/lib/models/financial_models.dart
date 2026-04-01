
class Summary {
  final double income;
  final double expenses;
  final double savings;
  final double savingsRate;

  Summary({
    required this.income,
    required this.expenses,
    required this.savings,
    required this.savingsRate,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      // Matching Django keys: "income", "expense", "savings", "savingsRate"
      income: (json['income'] as num?)?.toDouble() ?? 0.0,
      
      // IMPORTANT: Your Django service likely uses 'expense' (singular)
      // while your UI uses 'expenses'. This mapping fixes the ₹0 issue.
      expenses: (json['expense'] as num?)?.toDouble() ?? 0.0, 
      
      savings: (json['savings'] as num?)?.toDouble() ?? 0.0,
      savingsRate: (json['savingsRate'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class HealthScore {
  final double score;
  final String label;
  final List<String> suggestions;
  final HealthComponents components;

  HealthScore({
    required this.score,
    required this.label,
    required this.suggestions,
    required this.components,
  });

  factory HealthScore.fromJson(Map<String, dynamic> json) {
    return HealthScore(
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      label: json['label'] ?? "N/A",
      suggestions: List<String>.from(json['suggestions'] ?? []),
      components: HealthComponents.fromJson(json['components'] ?? {}),
    );
  }
}

class HealthComponents {
  final double emergencyFund;
  final double savingsRate;
  final double debtRatio;
  final double investmentRatio;

  HealthComponents({
    required this.emergencyFund,
    required this.savingsRate,
    required this.debtRatio,
    required this.investmentRatio,
  });

  factory HealthComponents.fromJson(Map<String, dynamic> json) {
    return HealthComponents(
      // Matching your Django HealthComponentSerializer camelCase keys
      emergencyFund: (json['emergencyFund'] as num?)?.toDouble() ?? 0.0,
      savingsRate: (json['savingsRate'] as num?)?.toDouble() ?? 0.0,
      debtRatio: (json['debtRatio'] as num?)?.toDouble() ?? 0.0,
      investmentRatio: (json['investmentRatio'] as num?)?.toDouble() ?? 0.0,
    );
  }
}