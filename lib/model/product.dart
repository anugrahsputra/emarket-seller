import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String? id;
  final String name;
  final String category;
  final String description;
  final String imageUrl;
  double price;
  int quantity;

  Product({
    this.id,
    this.name = '',
    required this.category,
    required this.description,
    required this.imageUrl,
    this.price = 0,
    this.quantity = 0,
  });

  factory Product.fromSnapshot(DocumentSnapshot snap) {
    return Product(
      id: snap.id,
      name: snap['name'],
      description: snap['description'],
      category: snap['category'],
      imageUrl: snap['imageUrl'],
      price: snap['price'],
      quantity: snap['quantity'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    String? imageUrl,
    double? price,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        description,
        imageUrl,
        price,
        quantity,
      ];

  String toJson() => json.encode(toMap());
}
