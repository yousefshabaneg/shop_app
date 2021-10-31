import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/business_logic/login_cubit/login_states.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_cubit.dart';
import 'package:shop_app/data/api/dio_helper.dart';
import 'package:shop_app/data/models/shop_app/address_model.dart';
import 'package:shop_app/data/models/shop_app/login_model.dart';
import 'package:shop_app/shared/constants/constants.dart';
import 'package:shop_app/shared/constants/end_points.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());
  static LoginCubit get(context) => BlocProvider.of(context);

  late ShopLoginModel loginModel;

  bool isPassword = true;
  IconData suffix = Icons.visibility_outlined;

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());
    DioHelper.postData(url: Login, data: {
      'email': email,
      'password': password,
    }).then((value) {
      loginModel = ShopLoginModel.fromJson(value.data);
      print(loginModel.message);
      emit(LoginSuccessState(loginModel));
    }).catchError((error) {
      print(error.toString());
      emit(LoginErrorState(error));
    });
  }

  void userRegister({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) {
    emit(RegisterLoadingState());
    DioHelper.postData(url: Register, data: {
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
    }).then((value) {
      loginModel = ShopLoginModel.fromJson(value.data);
      print(loginModel.message);
      emit(RegisterSuccessState(loginModel));
    }).catchError((error) {
      print(error.toString());
      emit(RegisterErrorState(error));
    });
  }

  LogoutModel? logoutModel;
  void userLogout() {
    emit(LogoutLoadingState());
    DioHelper.postData(url: Logout, data: {}, token: token).then((value) {
      logoutModel = LogoutModel.fromJson(value.data);
      emit(LogoutSuccessState(logoutModel!));
    }).catchError((error) {
      print(error.toString());
      emit(LogoutErrorState(error));
    });
  }

  ChangePasswordModel? passModel;
  void changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    emit(ChangePasswordLoadingState());
    DioHelper.postData(
      url: Password,
      data: {
        'current_password': currentPassword,
        'new_password': newPassword,
      },
      token: token,
    ).then((value) {
      passModel = ChangePasswordModel.fromJson(value.data);
      emit(ChangePasswordSuccessState(passModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ChangePasswordErrorState(error));
    });
  }

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ChangePasswordVisibility());
  }
}
