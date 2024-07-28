import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modern_form_esys_flutter_share/modern_form_esys_flutter_share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscanner/common_component/snack_bar.dart';
import 'package:qrscanner/core/appStorage/app_storage.dart';
import 'package:qrscanner/core/appStorage/my_scans_model.dart';
import 'package:qrscanner/features/saved_data/saved_data_states.dart';
import '../../core/dioHelper/dio_helper.dart';

class SavesDataController extends Cubit<SavedDataStates> {
  SavesDataController() : super(SavedDataInit());

  static SavesDataController of(context) => BlocProvider.of(context);

  MyScansModel? myScansModel;
  Excel excel = Excel.createExcel();

  // Sheet? sheetObject = excel['SheetName'];
  //excel.link("SheetName", "existingSheetObject");


  void sendEmail()async{
    ///Created by mahmoud maray
    Sheet sheetObject = excel['Output'];
    CellStyle cellStyle = CellStyle(
        backgroundColorHex: "#1AFF1A",
        fontFamily: getFontFamily(FontFamily.Calibri));
    for (int i = 0; i < myScansModel!.data!.length; i++) {
      var cell1 = sheetObject.cell(CellIndex.indexByString('A1'));
      var cell2 = sheetObject.cell(CellIndex.indexByString('B${i + 2}'));
      var cell3 = sheetObject.cell(CellIndex.indexByString('C1'));
      var cell4 = sheetObject.cell(CellIndex.indexByString('D${i + 2}'));
      cell1.value="Pin";
      cell3.value="Serial";
      cell2.value =
      myScansModel!.data![i].pin; // Insert value to selected cell;
      cell4.value = myScansModel!.data![i].serial;
    }
    var fileBytes = excel.save();
    await Share.file('output', 'Output.xlsx', fileBytes!, 'output/xlsx',
        text: 'My Work today');

  }

  void sendEmailCacheData() async {
    ///Created by mahmoud maray
    Sheet sheetObject = excel['Output'];
    CellStyle cellStyle = CellStyle(
        backgroundColorHex: "#1AFF1A",
        fontFamily: getFontFamily(FontFamily.Calibri));
    for (int i = 0; i < AppStorage.excelData.length; i++) {
      var cell1 = sheetObject.cell(CellIndex.indexByString('A1'));
      var cell2 = sheetObject.cell(CellIndex.indexByString('B${i + 2}'));
      var cell3 = sheetObject.cell(CellIndex.indexByString('C1'));
      var cell4 = sheetObject.cell(CellIndex.indexByString('D${i + 2}'));
      cell1.value="Pin";
      cell3.value="Serial";
      cell2.value =
      AppStorage.excelData[i]['pin']; // Insert value to selected cell;
      cell4.value = AppStorage.excelData[i]['serial'];
    }
    var fileBytes = excel.save();
    await Share.file('output', 'Output.xlsx', fileBytes!, 'output/xlsx',
        text: 'My Work today');
  }

  void deleteCard(int id) {
    emit(SavedDataDelete());
    DioHelper.get('delete_card?id=$id')?.then((value) {
      final data = value.data as Map<String, dynamic>;
      if (data['status'] == 1) {
        myScans();
        showSnackBar('Deleted Successfully');
        emit(SavedDataSuccess());
      } else {
        showSnackBar(data['message']);
        emit(SavedDataError());
      }
    }).catchError((error) {
      emit(SavedDataError());
      print(error.toString());
    });
  }


  void myScans() {
    emit(SavedDataLoading());
    DioHelper.get('history')?.then((value) {
      myScansModel = MyScansModel.fromJson(value.data);
      emit(SavedDataSuccess());
    }).catchError((error) {
      print(error.toString());
      emit(SavedDataError());
    });
  }
  // String id = myScansModel!.data!.id;
}
