import 'package:flutter/material.dart';

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color? color;
  final double size;

  StarRating(
      {this.starCount = 5,
     required this.size,
      this.rating = .0,
    required  this.onRatingChanged,
      this.color});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        color: Theme.of(context).colorScheme.secondary ,
        size: size ?? 25.0,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        Icons.star_half,
        color: color ?? Colors.yellow[200],
        size: size ?? 25.0,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: color ?? Colors.yellow[600],
        size: size ?? 25.0,
      );
    }
    return new InkResponse(
      onTap:
          onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
        children:
            new List.generate(starCount, (index) => buildStar(context, index)));
  }
}
