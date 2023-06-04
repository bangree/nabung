import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabung/cubit/baseState.dart';
import 'package:nabung/model/walletModel.dart';
import 'package:nabung/repository/walletRepository.dart';
import 'package:uuid/uuid.dart';

class WalletCubit extends Cubit<BaseState<List<WalletModel>>> {
  final WalletRepository walletRepository;

  WalletCubit({
    required this.walletRepository,
  }) : super(const InitializedState());

  late StreamSubscription<List<WalletModel>> streamSubscription;

  void init({required String userId}) async {
    if (state is InitializedState) {
      emit(const LoadingState());
    }
    streamSubscription = walletRepository.watch(userId: userId).listen(
          (data) => emit(LoadedState(data: data)),
        );
  }

  void reInit() {
    emit(const InitializedState());
  }

  void createOrUpdate({
    required String userId,
    String? id,
    required String name,
    required String balance,
    required String budgetPlan,
    required String goal,
    required String color,
  }) async {
    WalletModel wallet = WalletModel(
      id: id ?? const Uuid().v1(),
      name: name,
      balance: int.tryParse(balance) ?? 0,
      budgetPlan: int.tryParse(budgetPlan) ?? 0,
      goal: int.tryParse(goal) ?? 0,
      color: color,
    );

    await walletRepository.createOrUpdate(
      userId: userId,
      walletModel: wallet,
    );
  }

  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }
}
