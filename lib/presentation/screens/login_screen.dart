import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/business_logic/login_cubit/login_cubit.dart';
import 'package:shop_app/business_logic/login_cubit/login_states.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_cubit.dart';
import 'package:shop_app/data/cashe_helper.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/presentation/screens/register_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/constants/constants.dart';
import 'package:shop_app/shared/constants/my_colors.dart';

class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          if (state.loginModel.status) {
            CashHelper.saveData(
                    key: 'token', value: state.loginModel.data!.token)
                .then((value) {
              token = state.loginModel.data!.token;
              ShopCubit.get(context).getOrders();
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
          appBar: AppBar(
            backgroundColor: MyColors.secondary,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light,
              statusBarColor: MyColors.secondary,
            ),
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome \n Back',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 35.0,
                        height: 1.3,
                        letterSpacing: -0.8,
                        color: MyColors.primary,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Login now to browse our hot offers.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: MyColors.light.withOpacity(0.9),
                      ),
                    ),
                    SizedBox(
                      height: 50,
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
                      height: 30,
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
                      onSubmit: (value) {
                        if (formKey.currentState!.validate()) {
                          LoginCubit.get(context).userLogin(
                              email: emailController.text,
                              password: passwordController.text);
                        }
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: MyColors.light.withOpacity(0.6),
                              fontSize: 13.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ConditionalBuilder(
                      condition: state is! LoginLoadingState,
                      builder: (context) => primaryButton(
                        text: "Login",
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            LoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text);
                          }
                        },
                      ),
                      fallback: (context) => buildProgressIndicator(),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '''Don't have an account? ''',
                          style: TextStyle(
                            color: MyColors.light.withOpacity(0.7),
                            fontSize: 16.0,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            navigateAndFinish(context, RegisterScreen());
                          },
                          child: Text(
                            'Sign Up',
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
        );
      },
    );
  }
}
