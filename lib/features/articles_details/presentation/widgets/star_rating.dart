import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  const StarRating({super.key});

  @override
  State<StarRating> createState() => _TestStarState();
}

class _TestStarState extends State<StarRating> {
  int rating = 0; // 0 à 5 étoiles

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            return IconButton(
              onPressed: () {
                setState(() {
                  rating = index + 1;
                });
              },
              icon: Icon(
                index < rating
                    ? Icons.star
                    : Icons
                          .star_border, //  rempli si l'index est avant le rating
                color: Colors.amber,
                size: 32,
              ),
            );
          }),
        ),
      ),
    );
  }
}
