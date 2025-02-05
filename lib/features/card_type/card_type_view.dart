import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrscanner/common_component/custom_app_bar.dart';
import 'package:qrscanner/constant.dart';
import 'package:qrscanner/core/router/router.dart';
import 'package:qrscanner/features/card_type/card_type_controller.dart';
import 'package:qrscanner/features/extract_image/extract_image_view.dart';

class CardTypeView extends StatelessWidget {
  const CardTypeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: containerDecoration,
        child: ListView(
          children: [
            const CustomAppBar(
              text: 'Card Type',
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1,
                  left: 10,
                  right: 10),
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
                            MagicRouter.navigateTo(ExtractImageView(scanType: 'Mob',)),
                        child: Image.asset('assets/images/mob1.png'),
                      ),
                      InkWell(
                        onTap: () =>
                            MagicRouter.navigateTo(ExtractImageView(scanType: 'Mob_paber',)),
                        child: Image.asset('assets/images/mob2.png'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () =>
                            MagicRouter.navigateTo(ExtractImageView(scanType: 'zain',)),
                        child: Image.asset('assets/images/zain1.png'),
                      ),
                      InkWell(
                        onTap: () =>
                            MagicRouter.navigateTo(ExtractImageView(scanType: 'zain_paber',)),
                        child: Image.asset('assets/images/zain2.png'),


                      ),
                    ],
                  ),
                ],
              ),
            ) ,
          ],
        ),
      ),
    );
  }
}
