class MyScansModel {
  int? status;
  String? massage;
  List<SavedData>? data;

  MyScansModel({this.status, this.massage, this.data});

  MyScansModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    massage = json['massage'];
    if (json['data'] != null) {
      data = <SavedData>[];
      json['data'].forEach((v) {
        data!.add(new SavedData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['massage'] = this.massage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SavedData {
  int? id;
  String? pin;
  String? serial;
  String? image;
  String? phoneType;
  String? userId;
  String? categoryId;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  SavedData(
      {this.id,
        this.pin,
        this.serial,
        this.image,
        this.phoneType,
        this.userId,
        this.categoryId,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  SavedData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pin = json['pin'];
    serial = json['serial'];
    image = json['image'];
    phoneType = json['phone_type'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pin'] = this.pin;
    data['serial'] = this.serial;
    data['image'] = this.image;
    data['phone_type'] = this.phoneType;
    data['user_id'] = this.userId;
    data['category_id'] = this.categoryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}




// class MyScansModel {
//   int? status;
//   String? massage;
//   List<SavedData>? data;
//
//   MyScansModel({this.status, this.massage, this.data});
//
//   MyScansModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     massage = json['massage'];
//     if (json['data'] != null) {
//       data = <SavedData>[];
//       json['data'].forEach((v) {
//         data!.add(new SavedData.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['massage'] = this.massage;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class SavedData {
//   int? id;
//   String? pin;
//   String? serial;
//   String? image;
//   String? phoneType;
//   String? userId;
//   String? categoryId;
//   String? createdAt;
//   String? updatedAt;
//
//   SavedData(
//       {this.id,
//         this.pin,
//         this.serial,
//         this.image,
//         this.phoneType,
//         this.userId,
//         this.categoryId,
//         this.createdAt,
//         this.updatedAt});
//
//   SavedData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     pin = json['pin'];
//     serial = json['serial'];
//     image = json['image'];
//     phoneType = json['phone_type'];
//     userId = json['user_id'];
//     categoryId = json['category_id'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['pin'] = this.pin;
//     data['serial'] = this.serial;
//     data['image'] = this.image;
//     data['phone_type'] = this.phoneType;
//     data['user_id'] = this.userId;
//     data['category_id'] = this.categoryId;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }
