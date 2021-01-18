import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../providers/user.dart';

class OtherUser with ChangeNotifier {
  Useri ouser = Useri();
  String ouid;
  var uf = FirebaseFirestore.instance;

  Future<void> getdata() async {
    getData() async {
      return await uf.collection('users').doc(ouid).get();
    }

    await getData().then((val) {
      ouser.city = val.data()['city'];
      ouser.contactInfo = val.data()['contact info'];
      ouser.corporationName = val.data()['corporation'];
      ouser.description = val.data()['description'];
      ouser.payment = val.data()['payment'];
      ouser.policy = val.data()['policy'];
      ouser.products = val.data()['products'];
      ouser.role = val.data()['role'];
      ouser.userID = val.data()['uid'];
      ouser.userName = val.data()['user name'];
      ouser.imageUrl = val.data()['image url'];
    });
  }
}
