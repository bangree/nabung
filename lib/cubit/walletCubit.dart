import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabung/cubit/baseState.dart';
import 'package:nabung/model/walletModel.dart';
import 'package:nabung/repository/walletRepository.dart';

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

  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }
}
