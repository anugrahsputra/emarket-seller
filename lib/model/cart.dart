import 'package:equatable/equatable.dart';

class Cart extends Equatable {
  final String name;
  final String productId;
  final String sellerId;
  final int price;
  final String imageUrl;
  final String storeName;
  final int quantity;
  const Cart({
    required this.name,
    required this.productId,
    required this.sellerId,
    required this.price,
    required this.imageUrl,
    required this.storeName,
    required this.quantity,
  });

  Cart copyWith({
    String? name,
    String? productId,
    String? sellerId,
    int? price,
    String? imageUrl,
    String? storeName,
    int? quantity,
  }) {
    return Cart(
      name: name ?? this.name,
      productId: productId ?? this.productId,
      sellerId: sellerId ?? this.sellerId,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      storeName: storeName ?? this.storeName,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'productId': productId,
      'sellerId': sellerId,
      'price': price,
      'imageUrl': imageUrl,
      'storeName': storeName,
      'quantity': quantity,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      name: map['name'] ?? '',
      productId: map['productId'] ?? '',
      sellerId: map['sellerId'] ?? '',
      price: map['price']?.toInt() ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      storeName: map['storeName'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
    );
  }

  @override
  List<Object> get props {
    return [
      name,
      productId,
      sellerId,
      price,
      imageUrl,
      storeName,
      quantity,
    ];
  }
}
