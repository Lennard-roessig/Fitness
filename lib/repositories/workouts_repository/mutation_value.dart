import 'dart:math';

enum MutationType { LinearReduction, LinearIncrease, Const, Custom }

enum MutationTarget { Intervall, Repetitions }

class MutationValue {
  final MutationType type;
  final MutationTarget mutationTarget;
  final int max;
  final int min;
  final List<Point<int>> points;

  MutationValue(
    this.type,
    this.mutationTarget,
    this.max,
    this.min,
    this.points,
  );

  @override
  String toString() {
    return 'MutationValue{type: $type, mutationTarget: $mutationTarget, max: $max, min: $min, points: $points}';
  }

  Map<String, Object> toJson() {
    var mappedPoints = points.map((e) => {'x': e.x, 'y': e.y});
    return {
      'type': type.toString(),
      'mutationTarget': mutationTarget.toString(),
      'max': max,
      'min': min,
      'points': mappedPoints.toList()
    };
  }

  static MutationValue fromJson(Map<String, Object> json) {
    return MutationValue(
      getMutationTypeFromString(json['type']),
      getMutationTargetFromString(json['mutationTarget']),
      json['max'] as int,
      json['min'] as int,
      (json['points'] as List)
          .map(
            (e) => Point(
              e['x'] as int,
              e['y'] as int,
            ),
          )
          .toList(),
    );
  }

  static MutationType getMutationTypeFromString(String mutationTypeString) {
    for (MutationType element in MutationType.values) {
      if (element.toString() == mutationTypeString) {
        return element;
      }
    }
    return null;
  }

  static MutationTarget getMutationTargetFromString(
      String mutationTargetString) {
    for (MutationTarget element in MutationTarget.values) {
      if (element.toString() == mutationTargetString) {
        return element;
      }
    }
    return null;
  }
}
