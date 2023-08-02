// To parse this JSON data, do
//
//     final newTripsDriverModel = newTripsDriverModelFromJson(jsonString);

import 'dart:convert';

NewTripsDriverModel newTripsDriverModelFromJson(String str) =>
    NewTripsDriverModel.fromJson(json.decode(str));

String newTripsDriverModelToJson(NewTripsDriverModel data) =>
    json.encode(data.toJson());

class NewTripsDriverModel {
  String status;
  List<NewTripData> data;

  NewTripsDriverModel({
    required this.status,
    required this.data,
  });

  factory NewTripsDriverModel.fromJson(Map<dynamic, dynamic> json) =>
      NewTripsDriverModel(
        status: json["status"],
        data: List<NewTripData>.from(json["data"].map((x) => NewTripData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class NewTripData {
  String userName;
  String email;
  String phone;
  String userImage;
  String pickTime;
  dynamic amount;
  String pickupLocation;
  String dropLocation;
  String status;
  String rideId;
  String userId;
  String packageId;

  NewTripData({
    required this.userName,
    required this.email,
    required this.phone,
    required this.userImage,
    required this.pickTime,
    this.amount,
    required this.pickupLocation,
    required this.dropLocation,
    required this.status,
    required this.rideId,
    required this.userId,
    required this.packageId,
  });

  factory NewTripData.fromJson(Map<String, dynamic> json) => NewTripData(
        userName: json["user_name"],
        email: json["email"],
        phone: json["phone"],
        userImage: json["user_image"],
        pickTime: json["pick_time"],
        amount: json["amount"],
        pickupLocation: json["pickup_location"],
        dropLocation: json["drop_location"],
        status: json["status"],
        rideId: json["ride_id"],
        userId: json["user_id"],
        packageId: json["package_id"],
      );

  Map<String, dynamic> toJson() => {
        "user_name": userName,
        "email": email,
        "phone": phone,
        "user_image": userImage,
        "pick_time": pickTime,
        "amount": amount,
        "pickup_location": pickupLocation,
        "drop_location": dropLocation,
        "status": status,
        "ride_id": rideId,
        "user_id": userId,
        "package_id": packageId,
      };
}
