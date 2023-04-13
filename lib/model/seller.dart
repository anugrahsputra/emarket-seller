import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emarket_seller/model/model.dart';
import 'package:equatable/equatable.dart';

class SellerModel extends Equatable {
  final String? id;
  final String displayName;
  final String storeName;
  final String phoneNumber;
  final String address;
  final LocationModel location;
  final String email;
  final String photoUrl;
  const SellerModel({
    this.id,
    this.displayName = '',
    this.storeName = '',
    this.phoneNumber = '',
    this.address = '',
    this.location = const LocationModel(),
    this.email = '',
    this.photoUrl = '',
  });

  factory SellerModel.fromSnapshot(DocumentSnapshot snap) {
    return SellerModel(
      id: snap.id,
      displayName: snap['displayName'],
      storeName: snap['storeName'],
      phoneNumber: snap['phoneNumber'],
      address: snap['address'],
      location: LocationModel.fromMap(snap['location']),
      email: snap['email'],
      photoUrl: snap['photoUrl'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'displayName': displayName,
      'storeName': storeName,
      'phoneNumber': phoneNumber,
      'address': address,
      'location': location.toMap(),
      'email': email,
      'photoUrl': photoUrl,
    };
  }

  SellerModel copyWith({
    String? id,
    String? displayName,
    String? storeName,
    String? phoneNumber,
    String? address,
    LocationModel? location,
    String? email,
    String? photoUrl,
  }) {
    return SellerModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      storeName: storeName ?? this.storeName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      location: location ?? this.location,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        displayName,
        storeName,
        phoneNumber,
        address,
        location,
        email,
        photoUrl,
      ];
}
