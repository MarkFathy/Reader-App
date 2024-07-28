import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrscanner/common_component/custom_button.dart';
import 'package:qrscanner/common_component/custom_text.dart';
import 'package:qrscanner/common_component/custom_text_field.dart';
import 'package:qrscanner/core/appStorage/app_storage.dart';
import 'package:qrscanner/core/appStorage/my_scans_model.dart';
import 'package:qrscanner/core/router/router.dart';
import 'package:qrscanner/features/extract_image/extract_image_controller.dart';
import 'package:qrscanner/features/saved_data/component/saved_data_card.dart';
import 'package:qrscanner/features/saved_data/saved_data_controllers.dart';
import 'package:qrscanner/features/saved_data/saved_data_states.dart';
import '../../constant.dart';
import '../card_scanner/card_scanner_view.dart';

class SavedDataView extends StatelessWidget {
  SavedDataView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SavesDataController()..myScans(),
      child: Scaffold(
        body: Container(
          decoration: containerDecoration,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // const BackButton(
                    //   color: Colors.white,
                    // ),
                    IconButton(
                        onPressed: () {
                          MagicRouter.navigateTo(CardScannerView());
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                    ),
                    CustomText(
                      text: 'Saved Data',
                      alignment: Alignment.center,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: colorSecondary,
                    )
                  ],
                ),
              ),
              // const CustomAppBar(
              //   text: 'Saved Data',
              // ),
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
                child: BlocBuilder<SavesDataController, SavedDataStates>(
                  builder: (context, state) => state is SavedDataLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: colorSecondary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    // text: 'No .${AppStorage.excelData.length}',
                                    text:
                                        'No .${SavesDataController.of(context).myScansModel!.data!.length}',
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  Row(
                                    children: [
                                      CustomButton(
                                        text: 'Excel',
                                        fontSize: 14,
                                        isBold: false,
                                        widthButton:
                                            MediaQuery.of(context).size.width *
                                                0.30,
                                        icon: const Icon(Icons.folder,
                                            color: Colors.white),
                                        isIcon: true,
                                        bgColor: Color(0xff869FD8),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      CustomButton(
                                        text: 'Send mail',
                                        fontSize: 14,
                                        isBold: false,
                                        widthButton:
                                            MediaQuery.of(context).size.width *
                                                0.30,
                                        icon: const Icon(Icons.mail_outline,
                                            color: Colors.white),
                                        isIcon: true,
                                        bgColor: Color(0xff869FD8),
                                        onPress: () {
                                          // SavesDataController.of(context)
                                          //     .sendEmailCacheData();
                                          SavesDataController.of(context).sendEmail();
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: CustomTextField(
                                hint: 'Search....',
                              ),
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: AppStorage.excelData.length,
                                itemBuilder: (context, index) {
                                  // save(
                                  //     SavesDataController.of(context)
                                  //         .myScansModel!
                                  //         .data![index],
                                  //     index);
                                  return Dismissible(
                                    key: UniqueKey(),
                                    background: Container(
                                      color: Colors.red,
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    direction: DismissDirection.startToEnd,
                                    onDismissed: (d) {
                                      // AppStorage.excelData.removeWhere((element) => element['id']==AppStorage.excelData[index]['id']);
                                      SavesDataController.of(context)
                                          .deleteCard(
                                          SavesDataController.of(context).myScansModel!.data![index].id!);
                                    },
                                    child: SavedDataCard(
                                      savedData: SavesDataController.of(context).myScansModel!.data![index],
                                      // savedData: SavedData(
                                      //     id: AppStorage.excelData[index]['id'],
                                      //     pin: AppStorage.excelData[index]
                                      //         ['pin'],
                                      //     serial: AppStorage.excelData[index]
                                      //         ['serial']),
                                    ),
                                  );
                                }

                                // var cell = SavesDataController.of(context).sheetObject.cell(CellIndex.indexByString('A${i+1}'));   //i+1 means when the loop iterates every time it will write values in new row, e.g A1, A2, ...
                                //          cell.value =  SavesDataController.of(context)
                                // .myScansModel!
                                // .data![index]; // Insert value to selected cell;

                                // itemBuilder: (context, index) => dataCard(CardTypeController.of(context).getCategoriesModel!.data![index]),
                                )
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
