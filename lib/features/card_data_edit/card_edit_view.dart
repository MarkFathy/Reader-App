import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrscanner/common_component/custom_app_bar.dart';
import 'package:qrscanner/common_component/custom_button.dart';
import 'package:qrscanner/common_component/custom_text_field.dart';
import 'package:qrscanner/common_component/snack_bar.dart';
import 'package:qrscanner/constant.dart';
import 'package:qrscanner/core/appStorage/app_storage.dart';
import 'package:qrscanner/core/router/router.dart';
import 'package:qrscanner/features/card_data_edit/edit_controller.dart';
import 'package:qrscanner/features/card_data_edit/edit_states.dart';

class CardEdit extends StatelessWidget {
  CardEdit(
      {required this.serial, required this.pin, required this.id, Key? key})
      : super(key: key);
  final TextEditingController? pin;
  final TextEditingController? serial;
  final int? id;

  // EditController.of(context).pin = pin!;
  // final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditController(pin!, serial!),
      child: BlocBuilder<EditController, EditStates>(builder: (context, state) {
        print("piiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiin is $pin");
        print("piiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiin is $serial");
        print("piiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiin is $id");
        print(
            'piiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiin ${EditController.of(context).serial}');
        return Scaffold(
          body: Container(
            decoration: containerDecoration,
            child: ListView(
              children: [
                const CustomAppBar(
                  text: 'Card edit',
                ),
                Container(
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.06,
                        left: 20,
                        right: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                    ),
                    child: BlocBuilder<EditController, EditStates>(
                        builder: (context, state) => Form(
                              key: EditController.of(context).formKey,
                              child: ListView(
                                children: [
                                  CustomTextField(
                                    // initialValue: EditController.of(context).pin.text,
                                    controller: EditController.of(context).pin,
                                  ),
                                  CustomTextField(
                                    // initialValue: EditController.of(context).pin.text,
                                    controller:
                                        EditController.of(context).serial,
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  CustomButton(
                                    text: 'Save',
                                    onPress: () {
                                      // EditController.of(context).edit(id!);
                                      if (AppStorage.excelData.firstWhere(
                                              (element) =>
                                                  element['id'] == id)['id'] ==
                                          id) {
                                        AppStorage.cacheCartItem(
                                            id: id,
                                            pin: pin!.text,
                                            serial: serial!.text).then((value) {
                                              showSnackBar('تم التعديل بنجاح');
                                              MagicRouter.popWithResult(true);
                                        });
                                      }
                                    },
                                  )
                                ],
                              ),
                            ))),
              ],
            ),
          ),
        );
      }),
    );
  }
}
