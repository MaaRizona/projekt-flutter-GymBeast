class ExerciseDetail {
  final String id;
  final String name;
  final String bodyPart;
  final String equipment;
  final String gifUrl;
  final String target;
  final List<String> secondaryMuscles;
  // ExerciseDB dostarcza instructions jako listę stringów w nowszych wersjach, ale w podstawowej v2 często jest tylko to co wyżej.
  // Załóżmy strukturę tożsamą z Exercise dla spójności, API details zwraca ten sam obiekt JSON co element listy.

  ExerciseDetail({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.equipment,
    required this.gifUrl,
    required this.target,
    required this.secondaryMuscles,
  });

  factory ExerciseDetail.fromJson(Map<String, dynamic> json) {
    return ExerciseDetail(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Bez nazwy',
      bodyPart: json['bodyPart'] as String? ?? '',
      equipment: json['equipment'] as String? ?? '',
      gifUrl: json['gifUrl'] as String? ?? '',
      target: json['target'] as String? ?? '',
      secondaryMuscles: (json['secondaryMuscles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}
