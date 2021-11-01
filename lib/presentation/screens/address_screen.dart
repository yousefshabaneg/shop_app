import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_cubit.dart';
import 'package:shop_app/business_logic/shop_cubit/shop_states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/constants/my_colors.dart';

class AddressScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var cityController = TextEditingController();
  var regionController = TextEditingController();
  var detailsController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(listener: (context, state) {
      if (state is DeleteAddressSuccessState) {
        if (state.addressModel.status) {
          showToast(
              msg: state.addressModel.message.toString(),
              state: ToastStates.SUCCESS,
              seconds: 3);
        } else
          showToast(
              msg: state.addressModel.message.toString(),
              state: ToastStates.SUCCESS,
              seconds: 3);
      }
      if (state is ChangeAddressSuccessState) {
        if (state.addressModel.status) {
          showToast(
              msg: state.addressModel.message.toString(),
              state: ToastStates.SUCCESS,
              seconds: 3);
        } else
          showToast(
              msg: state.addressModel.message.toString(),
              state: ToastStates.SUCCESS,
              seconds: 3);
      }
      if (state is AddAddressSuccessState) {
        if (state.addressModel.status) {
          showToast(
              msg: state.addressModel.message.toString(),
              state: ToastStates.SUCCESS,
              seconds: 3);
        } else
          showToast(
              msg: state.addressModel.message.toString(),
              state: ToastStates.SUCCESS,
              seconds: 3);
      }
    }, builder: (context, state) {
      if (!ShopCubit.get(context).isNewAddress) {
        var addressModel = ShopCubit.get(context).addressModel!;
        if (addressModel.data.data.length > 0) {
          nameController.text = addressModel.data.data[0].name;
          cityController.text = addressModel.data.data[0].city;
          regionController.text = addressModel.data.data[0].region;
          detailsController.text = addressModel.data.data[0].details;
        }
      } else {
        if (ShopCubit.get(context).deleteAddress) {
          nameController.clear();
          cityController.clear();
          regionController.clear();
          detailsController.clear();
        }
      }

      return Scaffold(
        appBar: AppBar(
          leadingWidth: 130,
          leading: backButton(context),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  ShopCubit.get(context).isNewAddress
                      ? Text(
                          "Add Your Address",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Cairo",
                            color: MyColors.light,
                          ),
                        )
                      : Text(
                          "Your Address",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Cairo",
                            color: MyColors.light,
                          ),
                        ),
                  SizedBox(
                    height: 15,
                  ),
                  defaultFormField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    validate: (value) {
                      return value!.isEmpty ? 'Please fill the field' : null;
                    },
                    prefixIcon: Icons.location_on,
                    hint: 'Name',
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  defaultFormField(
                    controller: cityController,
                    keyboardType: TextInputType.text,
                    validate: (value) {
                      return value!.isEmpty ? 'Please fill the field' : null;
                    },
                    prefixIcon: Icons.location_city,
                    hint: 'City',
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  defaultFormField(
                    controller: regionController,
                    keyboardType: TextInputType.text,
                    validate: (value) {
                      return value!.isEmpty ? 'Please fill the field' : null;
                    },
                    prefixIcon: Icons.my_location_outlined,
                    hint: 'Region',
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  defaultFormField(
                    controller: detailsController,
                    keyboardType: TextInputType.text,
                    validate: (value) {
                      return value!.isEmpty ? 'Please fill the field' : null;
                    },
                    prefixIcon: Icons.details_rounded,
                    hint: 'Details',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  !ShopCubit.get(context).isNewAddress
                      ? Column(
                          children: [
                            ConditionalBuilder(
                              condition: state is! ChangeAddressLoadingState &&
                                  state is! AddAddressLoadingState,
                              builder: (context) => primaryButton(
                                  text: "Update",
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      if (ShopCubit.get(context).isNewAddress) {
                                        ShopCubit.get(context).addUserAddress(
                                          name: nameController.text,
                                          city: cityController.text,
                                          region: regionController.text,
                                          details: detailsController.text,
                                        );
                                      } else {
                                        ShopCubit.get(context)
                                            .changeUserAddress(
                                          name: nameController.text,
                                          city: cityController.text,
                                          region: regionController.text,
                                          details: detailsController.text,
                                        );
                                      }
                                    }
                                  }),
                              fallback: (context) => buildProgressIndicator(),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            if (!ShopCubit.get(context).isNewAddress)
                              ConditionalBuilder(
                                condition: state is! DeleteAddressLoadingState,
                                builder: (context) => primaryButton(
                                  text: "Delete",
                                  onPressed: () {
                                    ShopCubit.get(context).deleteUserAddress();
                                  },
                                  background: MyColors.red,
                                  colors: [
                                    Color(0xffFFC100),
                                    MyColors.green,
                                    Color(0xffF05454),
                                  ],
                                ),
                                fallback: (context) => buildProgressIndicator(),
                              ),
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            ConditionalBuilder(
                              condition: state is! AddAddressLoadingState,
                              builder: (context) => primaryButton(
                                  text: "Add Address",
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      if (ShopCubit.get(context).isNewAddress) {
                                        ShopCubit.get(context).addUserAddress(
                                          name: nameController.text,
                                          city: cityController.text,
                                          region: regionController.text,
                                          details: detailsController.text,
                                        );
                                      }
                                    }
                                  }),
                              fallback: (context) => buildProgressIndicator(),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
