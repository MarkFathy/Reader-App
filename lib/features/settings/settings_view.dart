import 'package:flutter/material.dart';
import 'package:qrscanner/common_component/custom_app_bar.dart';
import 'package:qrscanner/common_component/custom_button.dart';
import 'package:qrscanner/common_component/custom_text_field.dart';
import 'package:qrscanner/constant.dart';
import 'package:qrscanner/core/router/router.dart';
import 'package:qrscanner/features/login/login_view.dart';


class SettingsView extends StatelessWidget {

  var settingsController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: containerDecoration,
        child: ListView(
          children: [
             Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width *0.4,),
                  Text('Settings',style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.white,
                  ),),
                ],
              ),
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
                key: formKey,
                child: ListView(
                  children:  [
                    CustomTextField(
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter IP';
                        }
                        return null;
                      },
                      controller: settingsController,
                      keyboardType: TextInputType.text,
                      lableText: 'Network IP',
                    ),
                    SizedBox(height: 30,),
                    CustomButton(
                      onPress: (){
                        if(formKey.currentState!.validate()){
                          ip=settingsController.text;
                          MagicRouter.navigateAndPopAll(LogInView());
                        }
                      },
                      text: 'Save',
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}