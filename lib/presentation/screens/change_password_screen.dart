import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/business_logic/login_cubit/login_cubit.dart';
import 'package:shop_app/business_logic/login_cubit/login_states.dart';
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
        appBar: AppBar(
          leadingWidth: 130,
          leading: backButton(context),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsetsDirectional.all(20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Change Your Password",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Cairo",
                      color: MyColors.light,
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
                    hint: 'Current Password',
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
                    hint: 'New Password',
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
                    hint: 'Confirm Password',
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
                    builder: (context) => primaryButton(
                      text: "Change Password",
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          LoginCubit.get(context).changePassword(
                            currentPassword: currentPassController.text,
                            newPassword: newPassController.text,
                          );
                        }
                      },
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
