import 'package:flutter_app/models/outfit.dart';

class DateOutfit {
  final String id;
  final DateTime date;
  final Outfit outfit;

  DateOutfit({
    required this.id,
    required this.date,
    required this.outfit,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'outfitId': outfit.id,
    };
  }

  factory DateOutfit.fromMap(Map<String, dynamic> map, String id) {
    return DateOutfit(
      id: id,
      date: DateTime.parse(map['date']),
      outfit: Outfit.fromMap(map['outfit'], map['outfitId']),
    );
  }
}
