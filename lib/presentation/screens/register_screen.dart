import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/business_logic/login_cubit/login_cubit.dart';
import 'package:shop_app/business_logic/login_cubit/login_states.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_cubit.dart';
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

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

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
              ShopCubit.get(context).getOrders();
              ShopCubit.get(context).getCategories();
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Container(
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
                          color: MyColors.light.withOpacity(0.9),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      defaultFormField(
                        controller: nameController,
                        focusNode: nameFocusNode,
                        keyboardType: TextInputType.name,
                        validate: (value) {
                          return value!.isEmpty ? 'Enter your name. ' : null;
                        },
                        prefixIcon: Icons.account_circle_outlined,
                        hint: 'Name',
                        onSubmit: (String value) {
                          if (value.isNotEmpty)
                            phoneFocusNode.requestFocus();
                          else
                            nameFocusNode.requestFocus();
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      defaultFormField(
                        focusNode: phoneFocusNode,
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validate: (value) {
                          return value!.isEmpty || value.length < 11
                              ? 'Please enter a valid phone number. '
                              : null;
                        },
                        prefixIcon: Icons.phone_android_outlined,
                        hint: 'Phone',
                        onSubmit: (String value) {
                          if (value.isNotEmpty)
                            emailFocusNode.requestFocus();
                          else
                            phoneFocusNode.requestFocus();
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      defaultFormField(
                        focusNode: emailFocusNode,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validate: (value) {
                          return value!.isEmpty
                              ? 'Please enter a valid email address. '
                              : null;
                        },
                        prefixIcon: Icons.email_outlined,
                        hint: 'Email Address',
                        onSubmit: (String value) {
                          if (value.isNotEmpty)
                            passwordFocusNode.requestFocus();
                          else
                            emailFocusNode.requestFocus();
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      defaultFormField(
                        focusNode: passwordFocusNode,
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        validate: (value) {
                          return value!.isEmpty
                              ? 'Please enter a valid password with at least 8 letters. '
                              : null;
                        },
                        prefixIcon: Icons.lock_outlined,
                        hint: 'Password',
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
                        condition: state is! RegisterLoadingState,
                        builder: (context) => primaryButton(
                          text: "Register",
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
                        ),
                        fallback: (context) => buildProgressIndicator(),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account ?',
                            style: TextStyle(
                              color: MyColors.light.withOpacity(0.7),
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
                                color: MyColors.primary,
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
