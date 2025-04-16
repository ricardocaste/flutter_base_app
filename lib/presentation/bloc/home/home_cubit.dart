
import 'package:flutter_app/presentation/bloc/home/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void loadHome() {
    emit(HomeLoading());
  }
}