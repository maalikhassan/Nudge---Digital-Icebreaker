// A simple data class (model) representing one completed interaction.
// Dart doesn't have structs, so we use a class with named parameters.

class Interaction {
  final DateTime timestamp;     // when it happened
  final String scenario;        // 'train', 'cafe', 'class', 'wait'
  final String topic;           // what they talked about
  final int? plannedMinutes;    // how long stranger said they had
  final int? actualMinutes;     // how long it actually took
  final String outcome;         // 'connected' or 'declined'

  const Interaction({
    required this.timestamp,
    required this.scenario,
    required this.topic,
    this.plannedMinutes,
    this.actualMinutes,
    required this.outcome,
  });

  // Convert to Map so we can save as JSON
  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'scenario': scenario,
    'topic': topic,
    'plannedMinutes': plannedMinutes,
    'actualMinutes': actualMinutes,
    'outcome': outcome,
  };

  // Rebuild from Map when loading saved JSON
  factory Interaction.fromJson(Map<String, dynamic> j) => Interaction(
    timestamp: DateTime.parse(j['timestamp']),
    scenario: j['scenario'],
    topic: j['topic'],
    plannedMinutes: j['plannedMinutes'],
    actualMinutes: j['actualMinutes'],
    outcome: j['outcome'],
  );

  // Helper: emoji for the scenario
  String get scenarioIcon {
    switch (scenario) {
      case 'train': return '🚌';
      case 'cafe':  return '☕';
      case 'class': return '📚';
      default:      return '⏳';
    }
  }
}

