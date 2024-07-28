import 'dart:async';
import 'dart:io';
import 'package:cr_file_saver/file_saver.dart';
import 'package:dio/dio.dart';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modern_form_esys_flutter_share/modern_form_esys_flutter_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscanner/common_component/snack_bar.dart';
import 'package:qrscanner/core/appStorage/app_storage.dart';
import 'package:qrscanner/core/dioHelper/dio_helper.dart';
import 'package:qrscanner/features/extract_image/extact_image_states.dart';
import 'package:regexpattern/regexpattern.dart';
import '../../core/appStorage/scan_model.dart';

class ExtractImageController extends Cubit<ExtractImageStates> {
  ExtractImageController(this.scanType) : super(ExtractInitial());

  static ExtractImageController of(context) => BlocProvider.of(context);
  TextEditingController pin = TextEditingController();
  TextEditingController serial = TextEditingController();

  final String? scanType;

  // final RecognizedText? textRecognizer;
  Excel excel = Excel.createExcel();

  @override
  void onChange(Change<ExtractImageStates> change) {
    // TODO: implement onChange
    print("xbbxbxbxbxbbxb");
    super.onChange(change);
  }

  String scannedText = '';
  bool textScanned = false;
  var picker = ImagePicker();
  File? image;
  XFile? scanImage;
  final formKey = GlobalKey<FormState>();

  void setImage(value) {
    image = value;
    emit(ScanPinSuccess());
  }

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      image = File(pickedFile.path);
      // scanImage = File(pickedFile.path);
      textScanned = true;
      emit(
          ImagePickedSuccess()); //rename state as you need if use this code for new project (dont forget make this state in states file)
      // await getText(pickedFile);
    } else {
      print('No image selected.');
      textScanned = false;
      image = null;
      emit(
          ImagePickedError()); //rename state as you need if use this code for new project (dont forget make this state in states file)
      scannedText = 'eeeeeeeeeeerrrrrrrrrooooooorrrrrrrr';
    }
  }

  // bool isNumeric(String s) {
  //   if (s == null) {
  //     return false;
  //   }
  //   return double.tryParse(s) != null;
  // }

  // RegExp(r'^[z0-9_.]+$').hasMatch(line.text)

  Future<void> getText(RecognizedText recognizedText) async {
    print("shsjdhsj");
    // final inputImage = InputImage.fromFilePath(scanImage!.path);
    // final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    // RecognizedText recognizedText =
    //     await textRecognizer.processImage(inputImage);
    // await textRecognizer.close();
    // scannedText = '';
    // print(recognizedText.text.length);
    // for (var element in recognizedText.blocks) {
    //   if (element.text
    //           .replaceAll(RegExp('[A-Za-z]'), '')
    //           .replaceAll(' ', '')
    //           .length ==
    //       17) {
    //     pin.text = element.text;
    //   }
    //   if (element.text
    //           .replaceAll(RegExp('[A-Za-z]'), '')
    //           .replaceAll(' ', '')
    //           .length ==
    //       12) {
    //     serial.text = element.text;
    //   }
    // }
    if(scanType == 'Mob'){
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          // Same getters as TextBlock

          if (block.text
              .replaceAll(RegExp('[A-Za-z]'), '')
              .replaceAll(" ", "")
              .isNumeric()) {
            if (block.text
                .replaceAll(RegExp('[A-Za-z]'), '')
                .replaceAll(" ", "")
                .length ==
                17 ) {
              pin.text = block.text.replaceAll(RegExp('[A-Za-z]'), '');
              emit(ScanPinSuccess());
            }
          }
          for (TextElement element in line.elements) {
            // Same getters as TextBlock
            print("sjsjjs${element.text}");
            print("sjsjjs${element.text.length}");
            if(element.text.replaceAll(" ", '').length ==
                12){
              print("insssid");
              serial.text = element.text
                  .replaceAll(" ", "")
                  .replaceAll(RegExp('[A-Za-z]'), '');
              print("seeeeriiai${serial.text}");
            }

          }
        }
      }
    }else{

      for (var element in recognizedText.blocks) {
        print('oooooooooooooooooooooooooooo${element.text}');
        print('oooooooooolengthoooooooo${element.text.length}');
        if (scanType == 'Mob_paber') {
          if (element.text.split(' ').first.isNumeric()) {
            if (element.text.length == 20) {
              print('donnnnne${element.text}');
              pin.text = element.text;
              emit(ScanPinSuccess());
            }
          }
          if (element.text.contains('Serial')) {
            if (element.text
                .replaceAll('Serial', '')
                .replaceAll('No.', '')
                .replaceAll(' ', '')
                .substring(0, 12)
                .isNumeric()) {
              serial.text = element.text
                  .replaceAll('Serial', '')
                  .replaceAll('No.', '')
                  .replaceAll(' ', '')
                  .substring(0, 12);
              print('sesesesee${serial.text}');
              print('nnnnnnn${element.text}');
            }
          }
        } else if (scanType == 'zain_paber') {
          if (element.text.split(' ').first.isNumeric()) {
            if (element.text.length == 16) {
              print('donnnnne${element.text}');
              pin.text = element.text;
              emit(ScanPinSuccess());
            }
            if (element.text.length == 12) {
              serial.text = element.text;
            }
          }
        } else if (scanType == 'zain') {
          if (element.text.split(' ').first.isNumeric()) {
            print('shshshhsh${element.text}');
            print('shshshhshllllll${element.text.length}');
            print('bsbsbbsbsb${element.text.split('')}');
            if (element.text.length == 17) {
              print('donnnnne${element.text}');
              pin.text = element.text;
              emit(ScanPinSuccess());
            }
            if (element.text.length == 12) {
              serial.text = element.text;
            }
          }
        }
      }
    }

    textScanned = false;
    emit(Scanning());
  }

  ScanModel? scanModel;

  Future<void> scan() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    emit(ScanLoading());
    final body = {
      'pin': pin.text.replaceAll(' ', ''),
      'serial': serial.text.replaceAll(' ', ''),
      'phone_type': Platform.isAndroid ? 'android' : 'iphone',
      'category_id': scanType == 'Mob'
          ? '1'
          : scanType == 'Mob_paber'
              ? '2'
              : scanType == 'zain'
                  ? '3'
                  : '4',
    };

    FormData formData = FormData.fromMap(body);
    formData.files.add(
      MapEntry('image', await MultipartFile.fromFile(image!.path)),
    );
    if (kDebugMode) {
      print(body);
    }
    DioHelper.post('scan', true, body: body, formData: formData).then((value) {
      final data = value.data;
      print(data);
      if (data['status'] == 1) {
        showSnackBar('تم االارسال بنجاح');
        countPlus();
        saveFile(image!.path, serial.text, (value, total) => null)
            .then((value) {
          pin.clear();
          serial.clear();
        });
        emit(ScanSuccess());
      } else {
        showSnackBar(data['message']);
        // print('object')
        emit(ScanError());
      }
    }).catchError((error) {
      print(error.toString());
      emit(ScanError());
    });
  }

  void scanLocale() {
    // if (AppStorage.excelData.isNotEmpty) {
    //   for (int i = 0;
    //       i < AppStorage.excelData.length;
    //       i++) {
    //     if (ExtractImageController.of(context)
    //                 .pin
    //                 .text ==
    //             AppStorage.excelData[i]
    //                 ['pin'] ||
    //         ExtractImageController.of(context)
    //                 .serial
    //                 .text ==
    //             AppStorage.excelData[i]
    //                 ['serial']) {
    //       showSnackBar('Card Exist');
    //     } else {
    //       ExtractImageController.of(context)
    //           .saveFile(
    //               ExtractImageController.of(
    //                       context)
    //                   .image!
    //                   .path,
    //               'name',
    //               (value, total) => null)
    //           .then((value) async {
    //         // ExtractImageController.of(context)
    //         //     .countPlus();
    //         if (ExtractImageController.of(
    //                 context)
    //             .pin
    //             .text
    //             .isNotEmpty) {
    //           AppStorage.cacheCartItem(
    //             id: Random().nextInt(10000),
    //             pin: ExtractImageController.of(
    //                     context)
    //                 .pin
    //                 .text,
    //             serial:
    //                 ExtractImageController.of(
    //                         context)
    //                     .serial
    //                     .text,
    //           );
    //         }
    //         print(AppStorage.excelData);
    //         // await ExtractImageController.of(context)
    //         //     .image!
    //         //     .delete();
    //         ExtractImageController.of(context)
    //             .pin
    //             .clear();
    //         ExtractImageController.of(context)
    //             .serial
    //             .clear();
    //         print(
    //             'filelel${ExtractImageController.of(context).image}');
    //         ExtractImageController.of(context)
    //             .emit(ExtractInitial());
    //       });
    //     }
    //   }
    // } else if (AppStorage.excelData.isEmpty) {
    //   ExtractImageController.of(context)
    //       .saveFile(
    //           ExtractImageController.of(context)
    //               .image!
    //               .path,
    //           'name',
    //           (value, total) => null)
    //       .then((value) async {
    //     // ExtractImageController.of(context)
    //     //     .countPlus();
    //     AppStorage.cacheCartItem(
    //         id: Random().nextInt(10000),
    //         pin: ExtractImageController.of(
    //                 context)
    //             .pin
    //             .text,
    //         serial: ExtractImageController.of(
    //                 context)
    //             .serial
    //             .text);
    //     ExtractImageController.of(context)
    //         .pin
    //         .clear();
    //     ExtractImageController.of(context)
    //         .serial
    //         .clear();
    //     print(
    //         'filelel${ExtractImageController.of(context).image}');
    //     ExtractImageController.of(context)
    //         .emit(ExtractInitial());
    //   });
    // }
  }

  void sendEmail() async {
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
      cell1.value = "Pin";
      cell3.value = "Serial";
      cell2.value =
          AppStorage.excelData[i]['pin']; // Insert value to selected cell;
      cell4.value = AppStorage.excelData[i]['serial'];
    }
    var fileBytes = excel.save();
    await Share.file('output', 'Output.xlsx', fileBytes!, 'output/xlsx',
        text: 'My Work today');
  }

  Future<bool> saveFile(String url, String fileName,
      Function(int value, int total) onReceiveProgress) async {
    try {
      print('dkjd');
      if (await _requestPermission(Permission.storage)) {
        Directory? directory;
        directory = await getExternalStorageDirectory();
        String newPath = "";
        List<String> paths = directory!.path.split("/");
        print('dsllds' + paths.toString());
        for (int x = 1; x < paths.length; x++) {
          String folder = paths[x];
          if (folder != "Android") {
            newPath += "/" + folder;
          } else {
            break;
          }
        }
        newPath = newPath + "/Cards";
        print(newPath);
        directory = Directory(newPath);

        ///Created by mahmoud maray
        File saveFile = File(directory.path + "/$fileName");
        if (!await directory.exists()) {
          await directory.create(recursive: true);
          print('donnw');
        }
        if (await directory.exists()) {
          print('dlkfd');
          newPath =
              newPath + "/${DateFormat('yyyy-MM-dd').format(DateTime.now())}";
          directory = Directory(newPath);
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
          testCompressAndGetFile(image!, "$newPath/${serial.text}.jpg")
              .then((value) async {
            await value.copy('$newPath/${serial.text}.jpg').then((value) {
              // showSnackBar('تم الحفظ بنجاح');
            });
          });
        }
      }

      print('done');
      return true;
    } catch (e) {
      print('skjdsldjsl' + e.toString());
      return false;
    }
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 50,
    ).onError((error, stackTrace) {
      print("sdjkdhjksd");
      print(error);
    });

    print(file.lengthSync());
    print(result!.lengthSync());

    return result;
  }

  int counter = AppStorage.getCounter;

  // int? newcount;
  void countPlus() {
    counter++;
    AppStorage.cacheCounter(counter);
    // newcount = counter;
    Timer.periodic(const Duration(hours: 24), (timer) {
      counter = 0;
    });
    print(counter);
    emit(ExtractInitial());
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;

      ///Created By mahmoud maray
    } else {
      var result = await CRFileSaver.requestWriteExternalStoragePermission();
      if (result == true) {
        return true;
      }
    }
    print("dkfldf");
    await permission.request();
    return false;
  }

  @override
  Future<void> close() {
    image!.delete();
    return super.close();
  }
}
