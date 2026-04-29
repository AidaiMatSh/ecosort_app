class WasteEntry {
  final String category;
  final double amount;
  final DateTime date;

  WasteEntry({
    required this.category,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  factory WasteEntry.fromJson(Map<String, dynamic> json) {
    return WasteEntry(
      category: json['category'],
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
    );
  }
}
