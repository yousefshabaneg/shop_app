import 'package:shop_app/data/models/shop_app/address_model.dart';
import 'package:shop_app/data/models/shop_app/login_model.dart';

abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  final ShopLoginModel loginModel;

  LoginSuccessState(this.loginModel);
}

class LoginLoadingState extends LoginStates {}

class LoginErrorState extends LoginStates {
  final String error;

  LoginErrorState(this.error);
}

class RegisterSuccessState extends LoginStates {
  final ShopLoginModel loginModel;

  RegisterSuccessState(this.loginModel);
}

class RegisterLoadingState extends LoginStates {}

class RegisterErrorState extends LoginStates {
  final String error;

  RegisterErrorState(this.error);
}

class LogoutSuccessState extends LoginStates {
  final LogoutModel logoutModel;

  LogoutSuccessState(this.logoutModel);
}

class LogoutLoadingState extends LoginStates {}

class LogoutErrorState extends LoginStates {
  final String error;

  LogoutErrorState(this.error);
}

class ChangePasswordSuccessState extends LoginStates {
  final ChangePasswordModel changePasswordModel;

  ChangePasswordSuccessState(this.changePasswordModel);
}

class ChangePasswordLoadingState extends LoginStates {}

class ChangePasswordErrorState extends LoginStates {
  final String error;

  ChangePasswordErrorState(this.error);
}

class ChangePasswordVisibility extends LoginStates {}
