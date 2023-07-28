class RatingCons {
  final String? stars;
  final String? total;

  RatingCons({
    this.stars,
    this.total,
  });

  factory RatingCons.fromJson(Map<String, dynamic> json) {
    return RatingCons(
      stars: json['average_rating'],
      total: json['rating_num'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['average_rating'] = this.stars;
    data['rating_num'] = this.total;

    return data;
  }
}
