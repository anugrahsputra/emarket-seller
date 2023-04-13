import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emarket_seller/model/model.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Orders extends Equatable {
  final String id;
  final String buyerId;
  final String sellerId;
  final String displayName;
  final bool isProcessing;
  final bool isDelivered;
  final bool isCancelled;
  final List<Cart> cart;
  final int total;
  final String date;
  final String note;
  const Orders({
    this.id = '',
    required this.buyerId,
    required this.sellerId,
    required this.displayName,
    required this.isProcessing,
    required this.isDelivered,
    required this.isCancelled,
    required this.cart,
    required this.total,
    required this.date,
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
    List<Cart>? cart,
    int? total,
    String? date,
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
      cart: cart ?? this.cart,
      total: total ?? this.total,
      date: date ?? this.date,
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
      'cart': cart.map((x) => x.toMap()).toList(),
      'total': total,
      'date': date,
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
      cart: List<Cart>.from(map['cart']?.map((x) => Cart.fromMap(x))),
      total: map['total']?.toInt() ?? 0,
      date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
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
      cart,
      total,
      date,
      note,
    ];
  }
}
