class DeliveredCons {
  final String packageId;
  final String profielPic;
  final String driverName;
  final String vechileName;
  final String email;
  final String phone;
  final String pickTime;
  final String pickDate;
  final String amount;
  final String pickUpLocation;
  final String dropLocation;
  final String couponCode;
  final String driverId;
  final String rideId;

  DeliveredCons(
      {required this.packageId,
      required this.profielPic,
      required this.driverName,
      required this.vechileName,
      required this.email,
      required this.phone,
      required this.pickTime,
      required this.pickDate,
      required this.amount,
      required this.pickUpLocation,
      required this.dropLocation,
      required this.couponCode,
      required this.driverId,
      required this.rideId});

  factory DeliveredCons.fromJson(Map<String, dynamic> json) {
    return DeliveredCons(
      packageId: json['package_id'],
      profielPic: json['driver_image'],
      driverName: json['driver_name'],
      vechileName: json['vehicle_name'],
      email: json['email'],
      phone: json['phone'],
      pickTime: json['pick_time_new'],
      pickDate: json['pick_date'],
      amount: json['amount'],
      pickUpLocation: json['pickup_location'],
      dropLocation: json['drop_location'],
      couponCode: json['coupon_code'],
      driverId: json['driver_id'],
      rideId: json['ride_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['package_id'] = this.packageId;
    data['driver_image'] = this.profielPic;
    data['driver_name'] = this.driverName;
    data['vehicle_name'] = this.vechileName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['pick_time_new'] = this.pickTime;
    data['pick_date'] = this.pickDate;
    data['amount'] = this.amount;
    data['pickup_location'] = this.pickUpLocation;
    data['drop_location'] = this.dropLocation;
    data['coupon_code'] = this.couponCode;
    data['driver_id'] = this.driverId;
    data['ride_id'] = this.rideId;

    return data;
  }
}
