import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_overlay/model.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qrscanner/common_component/custom_text_field.dart';
import 'package:qrscanner/common_component/snack_bar.dart';
import 'package:qrscanner/core/appStorage/app_storage.dart';
import 'package:qrscanner/core/router/router.dart';
import 'package:qrscanner/core/validator/validation.dart';
import 'package:qrscanner/features/extract_image/extact_image_states.dart';
import 'package:qrscanner/features/extract_image/extract_image_controller.dart';
import 'package:qrscanner/features/scan_view/scan_view.dart';
import '../../common_component/custom_app_bar.dart';
import '../../common_component/custom_button.dart';
import '../../constant.dart';

class ExtractImageView extends StatelessWidget {
  final String? scanType;
// final File? image;
// final RecognizedText? recognizedText;

  ExtractImageView({
    Key? key,
    this.scanType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExtractImageController(scanType),
      child: BlocBuilder<ExtractImageController, ExtractImageStates>(
          builder: (context, state) {
            OverlayFormat format = OverlayFormat.cardID3;

            CardOverlay overlay = CardOverlay.byFormat(format);
        return Scaffold(
          body: Container(
            decoration: containerDecoration,
            child: ListView(
              children: [
                const CustomAppBar(
                  text: 'Saved Data',
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
                  child: Form(
                    key: ExtractImageController.of(context).formKey,
                    child: ListView(
                      physics: ScrollPhysics(),
                      children: [
                        ExtractImageController.of(context).image != null
                            ? AspectRatio(
                          aspectRatio: overlay.ratio!,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  alignment: FractionalOffset.center,
                                  image: FileImage(
                                    ExtractImageController.of(context).image!,
                                  ),
                                )),
                          ),
                        )
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset('assets/images/cam.png'),
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: colorPrimary, width: 1.0),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.3),
                          child: CustomButton(
                            text: 'Camera',
                            heightButton:
                                MediaQuery.of(context).size.height * 0.06,
                            onPress: () async {
                              MagicRouter.navigateTo(ScannerCameraOverlay())?.then(
                                (value) {
                                  if (value != null) {
                                    print('skjsdkjsdk' +value[0].text.toString());
                                    print('skjsdkjsdk' +value[0].text.length.toString());

                                    ExtractImageController.of(context)
                                        .getText(value[0]);
                                    ExtractImageController.of(context)
                                        .setImage(value[1]);
                                  }
                                },
                              );
                              // ExtractImageController.of(context).getImage();
                            },
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        BlocBuilder<ExtractImageController, ExtractImageStates>(
                          buildWhen: (context, state) =>
                              state is ScanPinSuccess,
                          builder: (context, state) => CustomTextField(
                            lableText: 'Pin No',
                            hasLabel: true,
                            isNumber: true,
                            validator: (v) => Validator.serial(v!),
                            controller: ExtractImageController.of(context).pin,
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        BlocBuilder<ExtractImageController, ExtractImageStates>(
                          buildWhen: (context, state) =>
                              state is ScanPinSuccess,
                          builder: (context, state) => CustomTextField(
                            hasLabel: true,
                            isNumber: true,
                            isNext: false,
                            lableText: 'Serial',
                            validator: (v) => Validator.serial(v!),
                            controller:
                                ExtractImageController.of(context).serial,
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        BlocBuilder<ExtractImageController, ExtractImageStates>(
                          builder: (context, state) => state is ScanLoading
                              ? CupertinoActivityIndicator(
                                  color: colorPrimary,
                                )
                              : CustomButton(
                                  text: 'Save',
                                  onPress: () {
                                    // ExtractImageController.of(context).requestPermission(Permission.storage);
                                    ExtractImageController.of(context).scan();
                                    // if (ExtractImageController.of(context)
                                    //         .pin
                                    //         .text
                                    //         .isNotEmpty &&
                                    //     ExtractImageController.of(context)
                                    //         .serial
                                    //         .text
                                    //         .isNotEmpty) {
                                    //   if (AppStorage.excelData.isNotEmpty) {
                                    //     for (int i = 0;
                                    //         i < AppStorage.excelData.length;
                                    //         i++) {
                                    //       if (ExtractImageController.of(context)
                                    //                   .pin
                                    //                   .text ==
                                    //               AppStorage.excelData[i]
                                    //                   ['pin'] ||
                                    //           ExtractImageController.of(context)
                                    //                   .serial
                                    //                   .text ==
                                    //               AppStorage.excelData[i]
                                    //                   ['serial']) {
                                    //         showSnackBar('Card Exist');
                                    //       } else {
                                    //         ExtractImageController.of(context)
                                    //             .saveFile(
                                    //                 ExtractImageController.of(
                                    //                         context)
                                    //                     .image!
                                    //                     .path,
                                    //                 'name',
                                    //                 (value, total) => null)
                                    //             .then((value) async {
                                    //           // ExtractImageController.of(context)
                                    //           //     .countPlus();
                                    //           if (ExtractImageController.of(
                                    //                   context)
                                    //               .pin
                                    //               .text
                                    //               .isNotEmpty) {
                                    //             AppStorage.cacheCartItem(
                                    //               id: AppStorage
                                    //                       .excelData.isNotEmpty
                                    //                   ? AppStorage.excelData
                                    //                           .length +
                                    //                       1
                                    //                   : 1,
                                    //               pin:
                                    //                   ExtractImageController.of(
                                    //                           context)
                                    //                       .pin
                                    //                       .text,
                                    //               serial:
                                    //                   ExtractImageController.of(
                                    //                           context)
                                    //                       .serial
                                    //                       .text,
                                    //             );
                                    //           }
                                    //           // await ExtractImageController.of(context)
                                    //           //     .image!
                                    //           //     .delete();
                                    //           ExtractImageController.of(context)
                                    //               .pin
                                    //               .clear();
                                    //           ExtractImageController.of(context)
                                    //               .serial
                                    //               .clear();
                                    //           print(
                                    //               'filelel${ExtractImageController.of(context).image}');
                                    //           ExtractImageController.of(context)
                                    //               .emit(ExtractInitial());
                                    //         });
                                    //       }
                                    //     }
                                    //   } else if (AppStorage.excelData.isEmpty) {
                                    //     ExtractImageController.of(context)
                                    //         .saveFile(
                                    //             ExtractImageController.of(
                                    //                     context)
                                    //                 .image!
                                    //                 .path,
                                    //             'name',
                                    //             (value, total) => null)
                                    //         .then((value) async {
                                    //       // ExtractImageController.of(context)
                                    //       //     .countPlus();
                                    //       AppStorage.cacheCartItem(
                                    //           id: AppStorage
                                    //                   .excelData.isNotEmpty
                                    //               ? AppStorage
                                    //                       .excelData.length +
                                    //                   1
                                    //               : 1,
                                    //           pin: ExtractImageController.of(
                                    //                   context)
                                    //               .pin
                                    //               .text,
                                    //           serial: ExtractImageController.of(
                                    //                   context)
                                    //               .serial
                                    //               .text);
                                    //       ExtractImageController.of(context)
                                    //           .pin
                                    //           .clear();
                                    //       ExtractImageController.of(context)
                                    //           .serial
                                    //           .clear();
                                    //       print(
                                    //           'filelel${ExtractImageController.of(context).image}');
                                    //       ExtractImageController.of(context)
                                    //           .emit(ExtractInitial());
                                    //     });
                                    //   }
                                    // }
                                    // print('skdjsksdjksd' +
                                    //     AppStorage.excelData.toString());
                                  }),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        // BlocBuilder<ExtractImageController, ExtractImageStates>(
                        //     builder: (context, state) {
                        //   return CustomButton(
                        //     text: 'Send email',
                        //     onPress:
                        //         ExtractImageController.of(context).sendEmail,
                        //   );
                        // }),
                        const SizedBox(
                          height: 10.0,
                        ),
                        BlocBuilder<ExtractImageController, ExtractImageStates>(
                          builder: (context, state) => Center(
                              child: Text(
                                  'Nomber of Card is ${AppStorage.getCounter}')),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
