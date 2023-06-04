import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabung/cubit/baseState.dart';
import 'package:nabung/model/transactionModel.dart';
import 'package:nabung/repository/transactionRepository.dart';

class TransactionCubit extends Cubit<BaseState<List<TransactionModel>>> {
  final TransactionRepository transactionRepository;

  TransactionCubit({
    required this.transactionRepository,
  }) : super(const InitializedState());

  late StreamSubscription<List<TransactionModel>> streamSubscription;

  void init({required String userId}) async {
    if (state is InitializedState) {
      emit(const LoadingState());
    }
    streamSubscription = transactionRepository.watch(userId: userId).listen(
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
