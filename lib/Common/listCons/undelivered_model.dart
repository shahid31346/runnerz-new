// To parse this JSON data, do
//
//     final unDeliveredModel = unDeliveredModelFromJson(jsonString);

import 'dart:convert';

UnDeliveredModel unDeliveredModelFromJson(String str) =>
    UnDeliveredModel.fromJson(json.decode(str));

String unDeliveredModelToJson(UnDeliveredModel data) =>
    json.encode(data.toJson());

class UnDeliveredModel {
  String status;
  List<UndeliveredData> data;

  UnDeliveredModel({
    required this.status,
    required this.data,
  });

  factory UnDeliveredModel.fromJson(Map<dynamic, dynamic> json) =>
      UnDeliveredModel(
        status: json["status"],
        data: List<UndeliveredData>.from(
            json["data"].map((x) => UndeliveredData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class UndeliveredData {
  String id;
  String identifier;
  String? name;
  String? mobile;
  String userId;
  String? paymentType;
  String status;
  String pickDate;
  String pickTime;
  String pickupLat;
  String pickupLon;
  String pickupAddress;
  String dropAddress;
  String dropLat;
  String dropLon;
  String vehicleTypeId;
  String farePrice;
  String driverName;
  String vehicleName;
  String email;
  String phone;
  String driverImage;

  UndeliveredData({
    required this.id,
    required this.identifier,
    this.name,
    this.mobile,
    required this.userId,
    this.paymentType,
    required this.status,
    required this.pickDate,
    required this.pickTime,
    required this.pickupLat,
    required this.pickupLon,
    required this.pickupAddress,
    required this.dropAddress,
    required this.dropLat,
    required this.dropLon,
    required this.vehicleTypeId,
    required this.farePrice,
    required this.driverName,
    required this.vehicleName,
    required this.email,
    required this.phone,
    required this.driverImage,
  });

  factory UndeliveredData.fromJson(Map<String, dynamic> json) =>
      UndeliveredData(
        id: json["id"],
        identifier: json["identifier"],
        name: json["name"],
        mobile: json["mobile"],
        userId: json["user_id"],
        paymentType: json["payment_type"],
        status: json["status"],
        pickDate: json["pick_date"],
        pickTime: json["pick_time"],
        pickupLat: json["pickup_lat"],
        pickupLon: json["pickup_lon"],
        pickupAddress: json["pickup_address"],
        dropAddress: json["drop_address"],
        dropLat: json["drop_lat"],
        dropLon: json["drop_lon"],
        vehicleTypeId: json["vehicle_type_id"],
        farePrice: json["fare_price"],
        driverName: json["driver_name"],
        vehicleName: json["vehicle_name"],
        email: json["email"],
        phone: json["phone"],
        driverImage: json["driver_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "identifier": identifier,
        "name": name,
        "mobile": mobile,
        "user_id": userId,
        "payment_type": paymentType,
        "status": status,
        "pick_date": pickDate,
        "pick_time": pickTime,
        "pickup_lat": pickupLat,
        "pickup_lon": pickupLon,
        "pickup_address": pickupAddress,
        "drop_address": dropAddress,
        "drop_lat": dropLat,
        "drop_lon": dropLon,
        "vehicle_type_id": vehicleTypeId,
        "fare_price": farePrice,
        "driver_name": driverName,
        "vehicle_name": vehicleName,
        "email": email,
        "phone": phone,
        "driver_image": driverImage,
      };
}
