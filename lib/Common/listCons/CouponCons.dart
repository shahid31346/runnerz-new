class CouponCons {
  final String id;
  final String coupon;
  final String fromDate;
  final String toDate;
  final String amount;
  final String usedUpto;
  final String couponStatus;

  CouponCons({
   required this.id,
   required this.coupon,
   required this.fromDate,
   required this.toDate,
   required this.amount,
   required this.usedUpto,
   required this.couponStatus,
  });

  factory CouponCons.fromJson(Map<String, dynamic> json) {
    return CouponCons(
      id: json['id'],
      coupon: json['coupon'],
      fromDate: json['from'],
      toDate: json['to'],
      amount: json['amount'],
      usedUpto: json['used_upto'],
      couponStatus: json['coupon_status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['coupon'] = this.coupon;
    data['from'] = this.fromDate;
    data['to'] = this.toDate;
    data['amount'] = this.amount;
    data['used_upto'] = this.usedUpto;
    data['coupon_status'] = this.couponStatus;

    return data;
  }
}
