import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscanner/common_component/custom_text.dart';
import 'package:qrscanner/common_component/snack_bar.dart';
import 'package:qrscanner/constant.dart';
import 'package:qrscanner/core/appStorage/app_storage.dart';
import 'package:qrscanner/core/router/router.dart';
import 'package:qrscanner/features/card_scanner/controller.dart';
import 'package:qrscanner/features/card_scanner/states.dart';
import 'package:qrscanner/features/card_type/card_type_view.dart';
import 'package:qrscanner/features/clear_data/clear_data_view.dart';
import 'package:qrscanner/features/saved_data/saved_data_view.dart';
import 'package:qrscanner/features/settings/settings_view.dart';

class CardScannerView extends StatelessWidget {
  const CardScannerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>CardController()..requestPermission(Permission.storage),
      child: Scaffold(
        body: Container(
          decoration: containerDecoration,
          child: ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              CustomText(
                text: 'Card Scanner',
                fontSize: 20,
                color: colorSecondary,
                fontWeight: FontWeight.bold,
                alignment: Alignment.center,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.1,
                    left: 20,
                    right: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () =>
                              MagicRouter.navigateTo(const CardTypeView()),
                          child: Image.asset('assets/images/scan.png'),
                        ),
                        InkWell(
                          onTap: () =>
                              MagicRouter.navigateTo( SavedDataView()),
                          child: Image.asset('assets/images/saved.png'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 26,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BlocBuilder<CardController,CardStates>(
                          builder: (context,state)=> InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  titlePadding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: Padding(
                                    padding:  EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height *0.1),
                                    child: CupertinoActivityIndicator(color: colorPrimary,),
                                  ),
                                ),
                              );
                              CardController.of(context).clearData();
                              // AppStorage.excelData.clear();
                              // AppStorage.cacheCounter(0);
                              // showSnackBar('Deleted Successfully');
                              // MagicRouter.pop();
                            },
                            child: Image.asset('assets/images/clear.png'),
                          ),
                        ),
                        InkWell(
                          onTap: () =>
                              MagicRouter.navigateTo( SettingsView()),
                          child: Image.asset('assets/images/settings.png'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
