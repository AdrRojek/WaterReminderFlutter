import '../core/constants.dart';

class BoilerState {
  BoilerState({required this.amountMl});

  int amountMl;

  Map<String, dynamic> toMap() => {'amountMl': amountMl};

  factory BoilerState.fromMap(Map<dynamic, dynamic> map) => BoilerState(
        amountMl: _asInt(
          map['amountMl'],
          AppConstants.boilerCapacityMl,
        ),
      );
}

int _asInt(dynamic value, [int fallback = 0]) {
  if (value is int) return value;
  if (value is double) return value.round();
  if (value is num) return value.toInt();
  return fallback;
}
