class UnDeliveredCons {
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
  final String status;

  UnDeliveredCons({
    required this.packageId,
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
    required this.status,
  });

  factory UnDeliveredCons.fromJson(Map<String, dynamic> json) {
    return UnDeliveredCons(
      packageId: json['identifier'],
      profielPic: json['driver_image'],
      driverName: json['driver_name'],
      vechileName: json['vehicle_name'],
      email: json['email'],
      phone: json['phone'],
      pickTime: json['pick_time_new'],
      pickDate: json['pick_date'],
      amount: json['fare_price'],
      pickUpLocation: json['pickup_address'],
      dropLocation: json['drop_address'],
      couponCode: json['coupon_code'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['identifier'] = this.packageId;
    data['driver_image'] = this.profielPic;
    data['driver_name'] = this.driverName;
    data['vehicle_name'] = this.vechileName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['pick_time_new'] = this.pickTime;
    data['pick_date'] = this.pickDate;
    data['fare_price'] = this.amount;
    data['pickup_address'] = this.pickUpLocation;
    data['drop_address'] = this.dropLocation;
    data['coupon_code'] = this.couponCode;
    data['status'] = this.status;

    return data;
  }
}
