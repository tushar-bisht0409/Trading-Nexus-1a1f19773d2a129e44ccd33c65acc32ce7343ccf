import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';

class Useri with ChangeNotifier {
  String imageUrl;
  String userID;
  String role;
  String corporationName;
  String userName;
  String city;
  String contactInfo;
  List<dynamic> products = [];
  String description;
  String policy;
  String payment;
  List<dynamic> nexusList = [];
  Coordinates loci;

  Useri(
      {this.imageUrl,
      this.userID,
      this.role,
      this.corporationName,
      this.userName,
      this.city,
      this.contactInfo,
      this.products,
      this.description,
      this.policy,
      this.payment,
      this.nexusList});
}
