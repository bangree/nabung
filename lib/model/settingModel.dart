import 'package:equatable/equatable.dart';

class SettingModel extends Equatable {
  final bool isAutoPlay;
  final bool isOverBudget;

  const SettingModel({
    this.isAutoPlay = false,
    this.isOverBudget = false,
  });

  SettingModel copyWith({
    bool? isAutoPlay,
    bool? isOverBudget,
  }) {
    return SettingModel(
      isAutoPlay: isAutoPlay ?? this.isAutoPlay,
      isOverBudget: isOverBudget ?? this.isOverBudget,
    );
  }

  @override
  List<Object?> get props => [
        isAutoPlay,
        isOverBudget,
      ];
}
