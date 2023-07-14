import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emarket_seller/model/model.dart';
import 'package:equatable/equatable.dart';

class Buyer extends Equatable {
  final String id;
  final String displayName;
  final String email;
  final String phoneNumber;
  final LocationModel location;
  final String address;
  final String photoUrl;
  const Buyer({
    this.id = '',
    this.displayName = '',
    this.location = const LocationModel(),
    this.address = '',
    this.phoneNumber = '',
    this.email = '',
    this.photoUrl = '',
  });

  factory Buyer.fromDocument(DocumentSnapshot snapshot) {
    return Buyer(
      id: snapshot.id,
      location: LocationModel.fromMap(snapshot['location']),
      address: snapshot['address'],
      displayName: snapshot['displayName'],
      phoneNumber: snapshot['phoneNumber'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'displayName': displayName,
      'address': address,
      'phoneNumber': phoneNumber,
      'email': email,
      'photoUrl': photoUrl,
      'location': location.toMap(),
    };
  }

  Buyer copyWith({
    String? id,
    String? displayName,
    String? address,
    LocationModel? location,
    String? phoneNumber,
    String? email,
    String? photoUrl,
  }) {
    return Buyer(
      id: id ?? this.id,
      location: location ?? this.location,
      address: address ?? this.address,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  List<Object?> get props =>
      [id, displayName, location, phoneNumber, address, email, photoUrl];
}
