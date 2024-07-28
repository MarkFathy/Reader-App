class ScanModel {
  int? status;
  String? massage;
  Data? data;

  ScanModel({this.status, this.massage, this.data});

  ScanModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    massage = json['massage'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['massage'] = this.massage;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? pin;
  String? serial;
  int? userId;
  String? phoneType;
  String? categoryId;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.pin,
        this.serial,
        this.userId,
        this.phoneType,
        this.categoryId,
        this.updatedAt,
        this.createdAt,
        this.id});

  Data.fromJson(Map<String, dynamic> json) {
    pin = json['pin'];
    serial = json['serial'];
    userId = json['user_id'];
    phoneType = json['phone_type'];
    categoryId = json['category_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pin'] = this.pin;
    data['serial'] = this.serial;
    data['user_id'] = this.userId;
    data['phone_type'] = this.phoneType;
    data['category_id'] = this.categoryId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
