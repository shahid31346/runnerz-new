class NewForDriverCons {
  final String profielPic;
  final String customerName;
  final String pickDate;
  final String amount;
  final String pickUpLocation;
  final String dropLocation;
  final String rideId;
  final String packageId;

  NewForDriverCons({
  required  this.profielPic,
  required  this.customerName,
  required  this.pickDate,
  required  this.amount,
  required  this.pickUpLocation,
  required  this.dropLocation,
  required  this.rideId,
  required  this.packageId,
  });

  factory NewForDriverCons.fromJson(Map<String, dynamic> json) {
    return NewForDriverCons(
      profielPic: json['user_image'],
      customerName: json['user_name'],
      pickDate: json['pick_time'],
      amount: json['amount'],
      pickUpLocation: json['pickup_location'],
      dropLocation: json['drop_location'],
      rideId: json['ride_id'],
      packageId: json['package_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_image'] = this.profielPic;
    data['user_name'] = this.customerName;

    data['pick_time'] = this.pickDate;
    data['amount'] = this.amount;
    data['pickup_location'] = this.pickUpLocation;
    data['drop_location'] = this.dropLocation;
    data['ride_id'] = this.rideId;
    data['package_id'] = this.rideId;

    return data;
  }
}
