import 'dart:math';

import 'package:get_storage/get_storage.dart';
import 'package:qrscanner/core/appStorage/user_model.dart';
import 'package:qrscanner/core/router/router.dart';
import 'package:qrscanner/features/login/login_view.dart';

abstract class AppStorage {
  static final GetStorage _box = GetStorage();

  static Future<void> init() async => await GetStorage.init();

  static UserModel? get getUserInfo {
    UserModel? profileModel;
    if (_box.hasData('user')) {
      profileModel = UserModel.fromJson(_box.read('user'));
    }
    return profileModel;
  }

  static bool get isLogged => getUserInfo != null;

  static Future<void> cacheUserInfo(UserModel userModel) =>
      _box.write('user', userModel.toJson());

  static Future<void> cacheImagePath(String imagePath) =>
      _box.write('image', imagePath);

  static Future<void> cacheCounter(int counter) =>
      _box.write('counter', counter);

  static int get getCounter => _box.read('counter') ?? 0;

  static String? get getImagePath => _box.read('image');

  static int? get getUserId => getUserInfo?.data?.user!.id;

  static String? get getToken => getUserInfo?.data!.token;

  static User? get getUserData => getUserInfo!.data!.user!;

  static final excelData = <Map>[];

  static Future<void> cacheCartItem({
    int? id,
    String? pin,
    String? serial,
  }) async {
    excelData.removeWhere((element) => element['pin'] == pin);
    // excelData.removeWhere((element) => element['id'] == id);
    excelData.removeWhere((element) => element['pin'].isEmpty);
    excelData.add({
      'id':id,
      'pin': pin,
      'serial': serial,
    });
    _box.write('exelData', excelData);
  }

  static Future<void> signOut() async {
    await _box.erase();
    MagicRouter.navigateAndPopAll(const LogInView());
  }
}
