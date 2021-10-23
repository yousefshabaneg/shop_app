import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/business_logic/login_cubit/login_cubit.dart';
import 'package:shop_app/business_logic/login_cubit/login_states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/constants/my_colors.dart';

class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Text(
                          'LOGIN',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 60.0,
                            color: MyColors.primary,
                          ),
                        ),
                        Text(
                          'Login now to browse our hot offers.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: MyColors.darkness,
                          ),
                        ),
                        SizedBox(
                          height: 30,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                print('Forgotted Password!');
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: MyColors.dark,
                                  fontSize: 13.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        defaultButton(
                          text: 'Login',
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              LoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text);
                            }
                          },
                          radius: 20,
                        ),
                        SizedBox(
                          height: 20,
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
                              '''Don't have an account? ''',
                              style: TextStyle(
                                color: MyColors.dark,
                                fontSize: 16.0,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Register Now',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
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
      ),
    );
  }
}
