import 'package:flutter/material.dart';

class CategoryCard {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;
  final String collectionName;

  CategoryCard(
      {required this.title,
      required this.imageUrl,
      required this.onTap,
      required this.collectionName});
}
