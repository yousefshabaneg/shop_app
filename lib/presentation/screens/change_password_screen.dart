import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/business_logic/login_cubit/login_cubit.dart';
import 'package:shop_app/business_logic/login_cubit/login_states.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_cubit.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/constants/my_colors.dart';

class ChangePasswordScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var currentPassController = TextEditingController();
  var newPassController = TextEditingController();
  var confirmPassController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(listener: (context, state) {
      if (state is ChangePasswordSuccessState) {
        if (state.changePasswordModel.status) {
          currentPassController.clear();
          newPassController.clear();
          confirmPassController.clear();
          showToast(
              msg: state.changePasswordModel.message,
              state: ToastStates.SUCCESS);
        } else
          showToast(
              msg: state.changePasswordModel.message, state: ToastStates.ERROR);
      }
    }, builder: (context, state) {
      return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsetsDirectional.all(20),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Text(
                    "Change Your Password",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Cairo",
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  defaultFormField(
                    controller: currentPassController,
                    keyboardType: TextInputType.visiblePassword,
                    validate: (value) {
                      return value!.length < 8
                          ? 'Must be at least 8 character'
                          : null;
                    },
                    prefixIcon: Icons.lock_outlined,
                    label: 'Current Password',
                    isPassword: LoginCubit.get(context).isPassword,
                    suffixIcon: LoginCubit.get(context).suffix,
                    suffixPressed: () {
                      LoginCubit.get(context).changePasswordVisibility();
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  defaultFormField(
                    controller: newPassController,
                    keyboardType: TextInputType.visiblePassword,
                    validate: (value) {
                      if (value!.length < 8) {
                        return 'Must be at least 8 character';
                      } else if (newPassController.text ==
                          currentPassController.text) {
                        return 'Must be different from current password.';
                      }
                      return null;
                    },
                    prefixIcon: Icons.lock_outlined,
                    label: 'New Password',
                    isPassword: LoginCubit.get(context).isPassword,
                    suffixIcon: LoginCubit.get(context).suffix,
                    suffixPressed: () {
                      LoginCubit.get(context).changePasswordVisibility();
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  defaultFormField(
                    controller: confirmPassController,
                    keyboardType: TextInputType.visiblePassword,
                    validate: (value) {
                      if (value!.length < 8) {
                        return 'Must be at least 8 character';
                      } else if (newPassController.text !=
                          confirmPassController.text) {
                        return 'Must match with new password';
                      }
                      return null;
                    },
                    prefixIcon: Icons.lock_outlined,
                    label: 'Confirm Password',
                    isPassword: LoginCubit.get(context).isPassword,
                    suffixIcon: LoginCubit.get(context).suffix,
                    suffixPressed: () {
                      LoginCubit.get(context).changePasswordVisibility();
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  ConditionalBuilder(
                    condition: state is! ChangePasswordLoadingState,
                    builder: (context) => defaultButton(
                      width: 350,
                      height: 50,
                      text: 'Change Password',
                      isUpperCase: true,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          LoginCubit.get(context).changePassword(
                            currentPassword: currentPassController.text,
                            newPassword: newPassController.text,
                          );
                        }
                      },
                      radius: 20,
                      background: MyColors.primary,
                    ),
                    fallback: (context) => buildProgressIndicator(),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
