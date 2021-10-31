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
        appBar: AppBar(),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  ShopCubit.get(context).isNewAddress
                      ? Text(
                          "Add Your Address",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Cairo",
                          ),
                        )
                      : Text(
                          "Change Your Address",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Cairo",
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
                    label: 'Name',
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
                    label: 'City',
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
                    label: 'Region',
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
                    label: 'Details',
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
                              builder: (context) => defaultButton(
                                width: 350,
                                height: 50,
                                text: 'Update',
                                isUpperCase: true,
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
                                      ShopCubit.get(context).changeUserAddress(
                                        name: nameController.text,
                                        city: cityController.text,
                                        region: regionController.text,
                                        details: detailsController.text,
                                      );
                                    }
                                  }
                                },
                                radius: 20,
                                background: MyColors.primary,
                              ),
                              fallback: (context) => buildProgressIndicator(),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            if (!ShopCubit.get(context).isNewAddress)
                              ConditionalBuilder(
                                condition: state is! DeleteAddressLoadingState,
                                builder: (context) => defaultButton(
                                  width: 350,
                                  height: 50,
                                  text: 'Delete',
                                  onPressed: () {
                                    ShopCubit.get(context).deleteUserAddress();
                                  },
                                  radius: 20,
                                  background: Colors.redAccent,
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
                              builder: (context) => defaultButton(
                                width: 350,
                                text: 'Add Address',
                                isUpperCase: true,
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
                                },
                                radius: 20,
                                background: MyColors.primary,
                              ),
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
