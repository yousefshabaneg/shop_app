import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/business_logic/login_cubit/login_states.dart';
import 'package:shop_app/data/api/dio_helper.dart';
import 'package:shop_app/shared/constants/end_points.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());
  static LoginCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;
  IconData suffix = Icons.visibility_outlined;

  void userLogin({
    required String email,
    required String password,
  }) {
    DioHelper.postData(lang: 'ar', url: login, data: {
      'email': email,
      'password': password,
    }).then((value) {
      print(value.data);
      emit(LoginSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(LoginErrorState(error));
    });
  }

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ChangePasswordVisibility());
  }
}
