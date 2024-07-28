import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscanner/common_component/snack_bar.dart';
import 'package:qrscanner/core/appStorage/app_storage.dart';
import 'package:qrscanner/core/router/router.dart';
import 'package:qrscanner/features/card_scanner/states.dart';

import '../../core/dioHelper/dio_helper.dart';

class CardController extends Cubit<CardStates> {
  CardController() : super(CardInit());

  static CardController of(context) => BlocProvider.of(context);

  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      var photo= await Permission.manageExternalStorage.request();
      print("dhdhdhdh$photo");
      return true;

      ///Created By mahmoud maray
    } else {
      var result = await permission.request();
     var video=  await Permission.manageExternalStorage.request();
     var photo= await Permission.photos.status.isGranted;
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    print("dkfldf");
    await permission.request();
    return false;
  }

  void clearData() {
    emit(CardLoading());
    DioHelper.post('delete', true, body: {}).then((value) {
      final data = value.data as Map<String, dynamic>;
      if (data['status'] == 1) {
        MagicRouter.pop();
        showSnackBar('Deleted Successfully');
        AppStorage.cacheCounter(0);
        emit(CardSuccess());
      } else {
        MagicRouter.pop();
        showSnackBar(data['message']);
        emit(CardError());
      }
    }).catchError((error) {
      MagicRouter.pop();
      emit(CardError());
      print(error.toString());
    });
  }
}
