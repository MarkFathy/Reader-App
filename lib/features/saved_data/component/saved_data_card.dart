import 'package:flutter/material.dart';
import 'package:qrscanner/common_component/custom_button.dart';
import 'package:qrscanner/common_component/custom_text.dart';
import 'package:qrscanner/core/appStorage/my_scans_model.dart';
import 'package:qrscanner/features/saved_data/saved_data_controllers.dart';

import '../../card_data_edit/card_edit_view.dart';

class SavedDataCard extends StatelessWidget {
  SavedDataCard({Key? key, this.savedData}) : super(key: key);
  SavedData? savedData;

  @override
  Widget build(BuildContext context) {
    // print(savedData!.pin!);
    // print(savedData!.serial!);
    final controller=SavesDataController.of(context);
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.grey)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CustomText(
                      text: 'Pin : ',
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    CustomText(
                      text: savedData!.pin!,
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const CustomText(
                      text: 'Serial : ',
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    CustomText(
                      text: savedData!.serial!,
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ],
                ),
              ],
            ),
            // Image.asset('assets/images/edit.png',)
            CustomButton(
              bgColor: Colors.white,
              heightButton: 40,
              isIcon: true,
              icon: Image.asset(
                'assets/images/edit.png',
                height: 50,
              ),
              onPress: () {

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CardEdit(
                          pin: TextEditingController(text: savedData!.pin!),
                          serial: TextEditingController(text: savedData!.serial!),
                      id: savedData!.id!,
                        ),


                )).then((value) {
                  if(value){
                    controller.myScans();
                  }
                });
              },
            )
            // IconButton(
            //     onPressed: () {},
            //     icon: Image.asset(
            //       'assets/images/edit.png', height: 50,
            //     ))
          ],
        ),
      ),
    );
  }
}
