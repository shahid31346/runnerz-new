class LaterCons {
  final String pickTime;
  final String pickDate;
  final String amount;
  final String pickUpLocation;
  final String dropLocation;
  final String couponCode;
  final String packageId;

  LaterCons({
  required  this.pickTime,
  required  this.pickDate,
  required  this.amount,
  required  this.pickUpLocation,
  required  this.dropLocation,
  required  this.couponCode,
  required  this.packageId,
  });

  factory LaterCons.fromJson(Map<String, dynamic> json) {
    return LaterCons(
      pickTime: json['pick_time_new'],
      pickDate: json['pick_date'],
      amount: json['amount'],
      pickUpLocation: json['pickup_location'],
      dropLocation: json['drop_location'],
      couponCode: json['coupon_code'],
      packageId: json['package_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['pick_time_new'] = this.pickTime;
    data['pick_date'] = this.pickDate;
    data['amount'] = this.amount;
    data['pickup_location'] = this.pickUpLocation;
    data['drop_location'] = this.dropLocation;
    data['coupon_code'] = this.couponCode;
    data['package_id'] = this.packageId;

    return data;
  }
}
