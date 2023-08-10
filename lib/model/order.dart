import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emarket_seller/model/model.dart';
import 'package:equatable/equatable.dart';

class Orders extends Equatable {
  final String id;
  final String buyerId;
  final String sellerId;
  final String displayName;
  final bool isProcessing;
  final bool isDelivered;
  final bool isCancelled;
  final bool isShipping;
  final List<Cart> cart;
  final String address;
  final LocationModel location;
  final int total;
  final String date;
  final Timestamp timestamp;
  final String note;
  const Orders({
    this.id = '',
    required this.buyerId,
    required this.sellerId,
    required this.displayName,
    required this.isProcessing,
    required this.isDelivered,
    required this.isCancelled,
    required this.isShipping,
    required this.cart,
    required this.address,
    required this.location,
    required this.total,
    required this.date,
    required this.timestamp,
    required this.note,
  });

  Orders copyWith({
    String? id,
    String? buyerId,
    String? sellerId,
    String? displayName,
    bool? isProcessing,
    bool? isDelivered,
    bool? isCancelled,
    bool? isShipping,
    List<Cart>? cart,
    String? address,
    LocationModel? location,
    int? total,
    String? date,
    Timestamp? timestamp,
    String? note,
  }) {
    return Orders(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      sellerId: sellerId ?? this.sellerId,
      displayName: displayName ?? this.displayName,
      isProcessing: isProcessing ?? this.isProcessing,
      isCancelled: isCancelled ?? this.isCancelled,
      isDelivered: isDelivered ?? this.isDelivered,
      isShipping: isShipping ?? this.isShipping,
      cart: cart ?? this.cart,
      address: address ?? this.address,
      location: location ?? this.location,
      total: total ?? this.total,
      date: date ?? this.date,
      timestamp: timestamp ?? this.timestamp,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'displayName': displayName,
      'isProcessing': isProcessing,
      'isDelivered': isDelivered,
      'isCancelled': isCancelled,
      'isShipping': isShipping,
      'cart': cart.map((x) => x.toMap()).toList(),
      'address': address,
      'location': location.toMap(),
      'total': total,
      'date': date,
      'timestamp': timestamp,
      'note': note,
    };
  }

  factory Orders.fromSnapshot(DocumentSnapshot map) {
    return Orders(
      id: map['id'],
      buyerId: map['buyerId'],
      sellerId: map['sellerId'],
      note: map['note'] ?? '',
      displayName: map['displayName'] ?? '',
      isProcessing: map['isProcessing'] ?? false,
      isDelivered: map['isDelivered'] ?? false,
      isCancelled: map['isCancelled'] ?? false,
      isShipping: map['isShipping'] ?? false,
      cart: List<Cart>.from(map['cart']?.map((x) => Cart.fromMap(x))),
      address: map['address'] ?? '',
      location: LocationModel.fromMap(map['location']),
      total: map['total']?.toInt() ?? 0,
      date: map['date'],
      timestamp: Timestamp.now(),
    );
  }

  @override
  List<Object> get props {
    return [
      buyerId,
      sellerId,
      displayName,
      isProcessing,
      isDelivered,
      isCancelled,
      isShipping,
      cart,
      address,
      location,
      total,
      date,
      timestamp,
      note,
    ];
  }
}
