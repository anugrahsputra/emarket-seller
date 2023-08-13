# E-Market Project
This is a Flutter project developed as a thesis to fulfill the graduation requirements for a Bachelor's degree in Informatics Engineering at Universitas Pasundan (Pasundan University). There are two applications in this project, namely the [E-Market Seller application](https://github.com/anugrahsputra/emarket-seller.git) and the [E-Market Buyer application.](https://github.com/anugrahsputra/emarket-buyer.git)

## E-Market Seller Application
The E-Market Seller mobile application is designed for sellers who want to sell their products online, specifically catering to the needs of UMKM (Micro, Small, and Medium Enterprises) located in Kecamatan Malingping.

![mokap](https://github.com/anugrahsputra/emarket-seller/assets/71306482/911c39fd-2dbc-438d-aee3-4c26fe64e634)

## Target Users: UMKM in Kecamatan Malingping
The E-Market Seller mobile application aims to provide a platform for UMKM sellers in Kecamatan Malingping, to effectively sell their products online. By focusing on this specific user group, the application takes into account the unique requirements and challenges faced by UMKM businesses in Kecamatan Malingping, offering tailored features and functionalities to meet their needs.

Through this targeted approach, the E-Market Seller application strives to contribute to the growth and success of UMKM businesses in Kecamatan Malingping, promoting digital transformation and providing opportunities for them to expand their customer base and increase sales.

## Features

- Authentication
    - [x] Login
    - [x] Register
    - [ ] Forgot Password

- Manage Product
    - [x] Add Product
    - [x] Edit Product
    - [x] Delete Product

- Manage Order
    - [x] Accept Order
    - [x] Decline Order
    - [x] Complete Order

- Manage Profile
    - [x] Edit Profile
    - [x] Change Password
    - [x] Logout

## Technologies

- [Firebase](https://firebase.google.com/)
    - [Authentication](https://firebase.google.com/docs/auth)
    - [Cloud Firestore](https://firebase.google.com/docs/firestore)
    - [Cloud Storage](https://firebase.google.com/docs/storage)

- [Google Maps](https://developers.google.com/maps/documentation)
    - [Geocoding API](https://developers.google.com/maps/documentation/geocoding/overview)
    - [Places API](https://developers.google.com/maps/documentation/places/web-service/overview)
    - [Maps SDK for Android](https://developers.google.com/maps/documentation/android-sdk/overview)
    - [Directions API](https://developers.google.com/maps/documentation/directions/overview)
    - [Distance Matrix API](https://developers.google.com/maps/documentation/distance-matrix/overview)

- [State Management](https://flutter.dev/docs/development/data-and-backend/state-mgmt)
    - [GetX](https://pub.dev/packages/get)

## Packages

You can see the packages used in this project in the file [pubspec.yaml](pubspec.yaml).

## Screenshots


<p>
  <img src="https://github.com/anugrahsputra/emarket-seller/assets/71306482/5c8735ba-b3bb-423a-a533-309add9f95d4" width=200 alt="login">
  <img src="https://github.com/anugrahsputra/emarket-seller/assets/71306482/a01b3fcc-8bce-4174-8043-0fcf66917950" width=200 alt="login">
  <img src="https://github.com/anugrahsputra/emarket-seller/assets/71306482/d4ba6730-531d-4a55-a86a-e06e5089a912" width=200 alt="login">
  <img src="https://github.com/anugrahsputra/emarket-seller/assets/71306482/acb6799e-ac39-41bd-bb39-8bb20573dc9b" width=200 alt="login">
  <img src="https://github.com/anugrahsputra/emarket-seller/assets/71306482/b151f611-ea2c-4f79-8d5e-c0f9e93a7f5c" width=200 alt="login">
  <img src="https://github.com/anugrahsputra/emarket-seller/assets/71306482/53b9d21f-94b7-4998-ab0f-b57b9788df24" width=200 alt="login">
  <img src="https://github.com/anugrahsputra/emarket-seller/assets/71306482/12cfe063-3222-470c-9339-ef33df8d96fa" width=200 alt="login">
  <img src="https://github.com/anugrahsputra/emarket-seller/assets/71306482/83175c81-7488-412f-be72-61bc64b839ee" width=200 alt="login">
</p>

## Installation and Usage

To try the app, you can clone this repository and run it on your local machine:
```
$ git clone https://github.com/anugrahsputra/emarket-seller.git
$ cd emarket-seller
```
Get all the dependencies:
```
$ flutter pub get
```


### Notes 🗒️
1. The E-Market Seller application does not have payment gateway integration. This decision is based on the understanding that most UMKM businesses in Kecamatan Malingping do not have the resources to support online payment transactions. Instead, the application allows sellers to accept orders and arrange payment and delivery details with their customers directly.

2. ##### All the technologies that are used in this project using the paid version. So, if you want to try this app, you need to create your own project in Firebase and Google Cloud Platform and replace the API keys with your own API keys.

