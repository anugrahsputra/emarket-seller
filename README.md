# E-Market Project
This is a Flutter project developed as a thesis to fulfill the graduation requirements for a Bachelor's degree in Informatics Engineering at Universitas Pasundan (Pasundan University). There are two applications in this project, namely the [E-Market Seller application](https://github.com/anugrahsputra/emarket-seller.git) and the [E-Market Buyer application.](https://github.com/anugrahsputra/emarket-buyer.git)

## E-Market Seller Application
The E-Market Seller mobile application is designed for sellers who want to sell their products online, specifically catering to the needs of UMKM (Micro, Small, and Medium Enterprises) located in Kecamatan Malingping.

![mokap](https://github.com/anugrahsputra/emarket-seller/assets/71306482/e9a17337-d66a-465c-8f94-acaaa1d9394c)

## Target Users: UMKM in Kecamatan Malingping
The E-Market Seller mobile application aims to provide a platform for UMKM sellers in Kecamatan Malingping, to effectively sell their products online. By focusing on this specific user group, the application takes into account the unique requirements and challenges faced by UMKM businesses in Kecamatan Malingping, offering tailored features and functionalities to meet their needs.

Through this targeted approach, the E-Market Seller application strives to contribute to the growth and success of UMKM businesses in Kecamatan Malingping, promoting digital transformation and providing opportunities for them to expand their customer base and increase sales.

## Demo
<img src="https://github.com/anugrahsputra/emarket-seller/assets/71306482/85fa10a8-d2e6-45db-85ad-96bb4d869a4d" width=400 alt="screenrecord">

## Screenshots
<p>
  <img src="https://github.com/anugrahsputra/emarket-seller/assets/71306482/c1ab52c7-099c-4f5b-94ca-4e31b69eb296" width=200 alt="login">
  <img src="https://github.com/anugrahsputra/emarket-seller/assets/71306482/545c0082-7e55-471d-85d4-1fd0e63a3485" width=200 alt="login">
  <img src="https://github.com/anugrahsputra/emarket-seller/assets/71306482/de4e1108-267d-4b87-a9b9-57c3804a4ff2" width=200 alt="login">
  <img src="https://github.com/anugrahsputra/emarket-seller/assets/71306482/b5679fe8-0f30-495b-95bb-db0bde61d8f9" width=200 alt="login">
  <img src="https://github.com/anugrahsputra/emarket-seller/assets/71306482/64c9e7fb-e736-4115-89ff-8c6852cb9683" width=200 alt="login">
  <img src="https://github.com/anugrahsputra/emarket-seller/assets/71306482/72f7d029-86a6-48a8-bd7e-13584d289289" width=200 alt="login">
  <img src="https://github.com/anugrahsputra/emarket-seller/assets/71306482/b8145b46-3b56-48ef-ac31-4aac02be8523" width=200 alt="login">
  <img src="https://github.com/anugrahsputra/emarket-seller/assets/71306482/9cff6c93-d62e-4e8c-97dd-68471c272c32" width=200 alt="login">
</p>




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

