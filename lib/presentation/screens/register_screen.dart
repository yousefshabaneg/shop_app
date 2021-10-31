import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/business_logic/login_cubit/login_cubit.dart';
import 'package:shop_app/business_logic/login_cubit/login_states.dart';
import 'package:shop_app/data/cashe_helper.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/presentation/screens/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/constants/constants.dart';
import 'package:shop_app/shared/constants/my_colors.dart';

class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state is RegisterSuccessState) {
          if (state.loginModel.status) {
            CashHelper.saveData(
                    key: 'token', value: state.loginModel.data!.token)
                .then((value) {
              token = state.loginModel.data!.token;
              navigateAndFinish(context, ShopLayout());
            });
            showToast(
                msg: state.loginModel.message!, state: ToastStates.SUCCESS);
          } else {
            showToast(msg: state.loginModel.message!, state: ToastStates.ERROR);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Container(
                  height: MediaQuery.of(context).size.height - 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Create \n An Account',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 30.0,
                          height: 1.4,
                          letterSpacing: -0.8,
                          color: MyColors.primary,
                        ),
                      ),
                      Text(
                        'Register now to browse our hot offers.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: MyColors.darkness,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      defaultFormField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        validate: (value) {
                          return value!.isEmpty ? 'Enter your name. ' : null;
                        },
                        prefixIcon: Icons.account_circle_outlined,
                        label: 'Name',
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validate: (value) {
                          return value!.isEmpty || value.length < 11
                              ? 'Please enter a valid phone number. '
                              : null;
                        },
                        prefixIcon: Icons.phone_android_outlined,
                        label: 'Phone',
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validate: (value) {
                          return value!.isEmpty
                              ? 'Please enter a valid email address. '
                              : null;
                        },
                        prefixIcon: Icons.email_outlined,
                        label: 'Email Address',
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      defaultFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        validate: (value) {
                          return value!.isEmpty
                              ? 'Please enter a valid password with at least 8 letters. '
                              : null;
                        },
                        prefixIcon: Icons.lock_outlined,
                        label: 'Password',
                        isPassword: LoginCubit.get(context).isPassword,
                        suffixIcon: LoginCubit.get(context).suffix,
                        suffixPressed: () {
                          LoginCubit.get(context).changePasswordVisibility();
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ConditionalBuilder(
                        condition: state is! RegisterLoadingState,
                        builder: (context) => defaultButton(
                          text: 'Register',
                          isUpperCase: true,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              LoginCubit.get(context).userRegister(
                                name: nameController.text,
                                phone: phoneController.text,
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          radius: 30,
                          background: MyColors.primary,
                        ),
                        fallback: (context) => buildProgressIndicator(),
                      ),
                      Divider(
                        color: MyColors.black,
                        height: 30,
                        thickness: 0.4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account ?',
                            style: TextStyle(
                              color: MyColors.dark,
                              fontSize: 16.0,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              navigateAndFinish(context, LoginScreen());
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                                decorationThickness: 3,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
