

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrscanner/core/appStorage/edit_model.dart';
import 'package:qrscanner/core/router/router.dart';
import 'package:qrscanner/features/saved_data/saved_data_view.dart';

import '../../core/dioHelper/dio_helper.dart';
import 'edit_states.dart';

class EditController extends Cubit<EditStates> {
  EditController(this.pin,this.serial) : super(EditInitial());

  static EditController of(context) => BlocProvider.of(context);





  TextEditingController pin = TextEditingController( );
  TextEditingController serial = TextEditingController();

  final formKey = GlobalKey<FormState>();
  EditModel? editModel;

  void edit(int id) {
    emit(EditLoading());
    final body = {
      'pin': pin.text,
      'serial': serial.text,
      'id': id,
    };
    DioHelper.post('update', true, body: body).then((value) {
      final data = value.data as Map<String,dynamic>;
      if(data['status'] == 1){
        editModel = EditModel.fromJson(value.data);
        MagicRouter.navigateAndPopAll(SavedDataView());
        emit(EditSuccess());
      }

    }).catchError((error) {
      print(error.toString());
      print("not saved");
      emit(EditError());
    });
  }
}
