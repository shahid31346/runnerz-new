class RateReviewCons {
  final String profielPic;
  final String name;
  final String stars;
  final String reviewDescription;

  RateReviewCons({
   required this.profielPic,
   required this.name,
   required this.stars,
   required this.reviewDescription,
  });

  factory RateReviewCons.fromJson(Map<String, dynamic> json) {
    return RateReviewCons(
      profielPic: json['photo'],
      name: json['name'],
      stars: json['rating'],
      reviewDescription: json['review'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo'] = this.profielPic;
    data['name'] = this.name;
    data['rating'] = this.stars;
    data['review'] = this.reviewDescription;

    return data;
  }
}
