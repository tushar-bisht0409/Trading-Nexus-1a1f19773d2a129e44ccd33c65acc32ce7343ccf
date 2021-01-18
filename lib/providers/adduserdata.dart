import 'dart:async';
import 'dart:io';

//import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/services.dart';
import 'package:Nexus/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocode/geocode.dart';
import './user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_storage/firebase_storage.dart';

class UserData with ChangeNotifier {
  String uid;
  String ro;
  Useri user = Useri();
  int othuserviewindx;
  var uf = FirebaseFirestore.instance;

  void getimageUrl([File newValue, bool del = false]) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('user_image')
        .child(user.userID + '.jpg');
    if (del == false) {
      await ref.putFile(newValue);
      String url = await ref.getDownloadURL();
      setimageurl(url);
    } else {
      user.imageUrl = null;
      await uf.collection('users').doc(uid).update({
        'image url': null,
      });
      await ref.delete();
    }
  }

  Future<void> setcity(String newValue) async {
    user.city = newValue;
    await uf.collection('users').doc(uid).update({
      'city': user.city,
    });
    notifyListeners();
  }

  Future<void> setcontactInfo(String newValue) async {
    user.contactInfo = newValue;
    await uf.collection('users').doc(uid).update({
      'contact info': user.contactInfo,
    });
    notifyListeners();
  }

  Future<void> setcorporationName(String newValue) async {
    user.corporationName = newValue;
    await uf.collection('users').doc(uid).update({
      'corporation': user.corporationName,
    });
    notifyListeners();
  }

  Future<void> setdescription(String newValue) async {
    user.description = newValue;
    await uf.collection('users').doc(uid).update({
      'description': user.description,
    });
    notifyListeners();
  }

  Future<void> setimageurl(String newValue) async {
    user.imageUrl = newValue;
    await uf.collection('users').doc(uid).update({
      'image url': user.imageUrl,
    });

    notifyListeners();
  }

  Future<void> setloci(Coordinates newValue) async {
    user.loci = newValue;
    await uf
        .collection('users')
        .doc(uid)
        .update({'latitude': user.loci.latitude});
    await uf
        .collection('users')
        .doc(uid)
        .update({'longitude': user.loci.longitude});

    notifyListeners();
  }

  Future<void> setpayment(String newValue) async {
    user.payment = newValue;
    await uf.collection('users').doc(uid).update({'payment': user.payment});

    notifyListeners();
  }

  Future<void> setpolicy(String newValue) async {
    user.policy = newValue;
    await uf.collection('users').doc(uid).update({
      'policy': user.policy,
    });

    notifyListeners();
  }

  Future<void> setproducts(String newValue, bool del) async {
    if (user.products == null) {
      user.products = [];
    }
    if (del == false && prodlist.contains(newValue) == false) {
      user.products.add(newValue);
      await uf.collection('users').doc(uid).update({
        'products': user.products,
      });
    }
    if (del == true) {
      user.products.remove(newValue);
      await uf.collection('users').doc(uid).update({
        'products': user.products,
      });
    }
    prodlist = user.products;

    notifyListeners();
  }

  Future<void> setrole(String newValue) async {
    user.role = newValue;
    await uf.collection('users').doc(uid).update({
      'role': user.role,
    });
    notifyListeners();
  }

  Future<void> setuserName(String newValue) async {
    user.userName = newValue;
    await uf.collection('users').doc(uid).update({
      'user name': user.userName,
    });

    notifyListeners();
  }

  Future<void> setusid() async {
    user.userID = FirebaseAuth.instance.currentUser.uid;
    uid = user.userID;
    print(uid);
    await uf.collection('users').doc(uid).update({
      'uid': user.userID,
    });

    notifyListeners();
  }

  Future<void> setnexuslist(String newValue, bool del) async {
    if (del == false) {
      if (user.nexusList == null) {
        user.nexusList = [];
      }
      user.nexusList.add(newValue);
      await uf.collection('users').doc(uid).update({
        'nexus list': user.nexusList,
      });
    } else {
      user.nexusList.remove(newValue);
      await uf.collection('users').doc(uid).update({
        'nexus list': user.nexusList,
      });
    }
    nexlist = user.nexusList;

    notifyListeners();
  }

  Future<void> getdata() async {
    getData() async {
      //   uid = FirebaseAuth.instance.currentUser.uid;
      print(uid);
      // await setusid(uid);
      return await uf.collection('users').doc(uid).get();
    }

    await getData().then((val) {
      user.city = val.data()['city'];
      user.contactInfo = val.data()['contact info'];
      user.corporationName = val.data()['corporation'];
      user.description = val.data()['description'];
      user.payment = val.data()['payment'];
      user.policy = val.data()['policy'];
      user.products = val.data()['products'];
      user.role = val.data()['role'];
      user.userID = val.data()['uid'];
      user.userName = val.data()['user name'];
      user.imageUrl = val.data()['image url'];
      //   if (val.data()['latitude'] != null && val.data()['longitude'] != null) {
      //   user.loci.latitude = val.data()['latitude'];
      //   user.loci.longitude = val.data()['longitude'];
      // }
      user.nexusList = val.data()['nexus list'];
    });
    nexlist = user.nexusList;
    prodlist = user.products;
    //  loccoord = user.loci;
    //if (user.loci != null) {
    // loccoord.latitude = user.loci.latitude;
    // loccoord.longitude = user.loci.longitude;
    //}
  }
}
