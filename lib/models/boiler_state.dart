import '../core/constants.dart';

class BoilerState {
  BoilerState({required this.amountMl});

  int amountMl;

  Map<String, dynamic> toMap() => {'amountMl': amountMl};

  factory BoilerState.fromMap(Map<dynamic, dynamic> map) => BoilerState(
        amountMl: map['amountMl'] as int? ?? AppConstants.boilerCapacityMl,
      );
}
