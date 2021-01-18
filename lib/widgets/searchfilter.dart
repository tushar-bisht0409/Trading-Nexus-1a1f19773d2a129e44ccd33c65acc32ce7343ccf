import 'package:Nexus/main.dart';

//import '../screens/otheruserscreen.dart';
//import 'package:flutter/material.dart';
import '../providers/user.dart';
//import 'package:firebase_storage/firebase_storage.dart'
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:geodesy/geodesy.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:geocode/geocode.dart';

class SearchFilter {
  String frole;
  String fcity;
  String fproduct;
  double frange;
  Useri ouser = Useri();
  var uf = FirebaseFirestore.instance;

  SearchFilter(
      {this.frole = 'Select Role',
      this.fcity = '',
      this.fproduct = '',
      this.frange = 0});

  String tandl(String w) {
    if (w != null) {
      w = w.trim();
      w = w.toLowerCase();
    }
    return w;
  }

  Future<void> searchname(String fname) async {
    fname = tandl(fname);
    for (int i = 0; i < usersList.length; i++) {
      var ouid = usersList[i];
      getData() async {
        return await uf.collection('users').doc(ouid).get();
      }

      await getData().then((val) {
        ouser.userName = val.data()['user name'];
        ouser.corporationName = val.data()['corporation'];
      });
      ouser.userName = tandl(ouser.userName);
      ouser.corporationName = tandl(ouser.corporationName);
      if (ouser.userName == fname || ouser.corporationName == fname) {
        if (searchlist != null) {
          if (searchlist.contains(ouid) == false) {
            searchlist.add(ouid);
          }
        } else {
          searchlist.add(ouid);
        }
      }
    }
  }

  Future<void> sfiltering(sf) async {
    searchlist = [];

    sf.fcity = tandl(sf.fcity);
    sf.fproduct = tandl(sf.fproduct);

    if (sf.frole != 'Select Role' &&
        (sf.fcity != '' || sf.fcity != null) &&
        (sf.fproduct != '' || sf.fproduct != null)) {
      await sfilter1(sf);
    }
    if (sf.frole != 'Select Role' && (sf.fcity != '' || sf.fcity != null)) {
      await sfilter2(sf);
    }
    if (sf.frole != 'Select Role' &&
        (sf.fproduct != '' || sf.fproduct != null)) {
      await sfilter3(sf);
    }
    if (sf.fproduct != '' && (sf.fcity != '' || sf.fcity != null)) {
      await sfilter4(sf);
    }
    if (sf.frole != 'Select Role' &&
        sf.frange != 0 &&
        (sf.fproduct != '' || sf.fproduct != null)) {
      await sfilter5(sf);
    }
    if (sf.frole != 'Select Role' && sf.frange != 0) {
      await sfilter6(sf);
    }
    if ((sf.fproduct != '' || sf.fproduct != null) && sf.frange != 0) {
      await sfilter7(sf);
    }
    if (sf.frange != 0) {
      await sfilter8(sf);
    }
    if (sf.fproduct != '' || sf.fproduct != null) {
      await sfilter9(sf);
    }
    if (sf.fcity != '' || sf.fcity != null) {
      await sfilter10(sf);
    }
    if (sf.frole != 'Select Role') {
      await sfilter11(sf);
    }
    print('$searchlist in');
  }

  Future<void> sfilter1(SearchFilter sf) async {
    for (int i = 0; i < usersList.length; i++) {
      var ouid = usersList[i];
      getData() async {
        return await uf.collection('users').doc(ouid).get();
      }

      await getData().then((val) {
        ouser.role = val.data()['role'];
        ouser.city = val.data()['city'];
        ouser.products = val.data()['products'];
      });
      ouser.city = tandl(ouser.city);
      for (int i = 0; i < ouser.products.length; i++) {
        ouser.products[i] = tandl(ouser.products[i]);
      }
      if (ouser.products != null) {
        if (ouser.role == sf.frole &&
            ouser.city == sf.fcity &&
            ouser.products.contains(sf.fproduct)) {
          if (searchlist != null) {
            if (searchlist.contains(ouid) == false) {
              searchlist.add(ouid);
            }
          } else {
            searchlist.add(ouid);
          }
        }
      }
    }
  }

  Future<void> sfilter2(SearchFilter sf) async {
    if (sf.frole != 'Select Role' && sf.fcity != '' && sf.fproduct != '') {
      for (int i = 0; i < usersList.length; i++) {
        var ouid = usersList[i];
        getData() async {
          return await uf.collection('users').doc(ouid).get();
        }

        await getData().then((val) {
          ouser.role = val.data()['role'];
          ouser.city = val.data()['city'];
        });
        ouser.city = tandl(ouser.city);
        if (ouser.role == sf.frole && ouser.city == sf.fcity) {
          if (searchlist != null) {
            if (searchlist.contains(ouid) == false) {
              searchlist.add(ouid);
            }
          } else {
            searchlist.add(ouid);
          }
        }
      }
    }
  }

  Future<void> sfilter3(SearchFilter sf) async {
    for (int i = 0; i < usersList.length; i++) {
      var ouid = usersList[i];
      getData() async {
        return await uf.collection('users').doc(ouid).get();
      }

      await getData().then((val) {
        ouser.role = val.data()['role'];
        ouser.products = val.data()['products'];
      });
      for (int i = 0; i < ouser.products.length; i++) {
        ouser.products[i] = tandl(ouser.products[i]);
      }
      if (ouser.products != null) {
        if (ouser.role == sf.frole && ouser.products.contains(sf.fproduct)) {
          if (searchlist != null) {
            if (searchlist.contains(ouid) == false) {
              searchlist.add(ouid);
            }
          } else {
            searchlist.add(ouid);
          }
        }
      }
    }
  }

  Future<void> sfilter4(SearchFilter sf) async {
    for (int i = 0; i < usersList.length; i++) {
      var ouid = usersList[i];
      getData() async {
        return await uf.collection('users').doc(ouid).get();
      }

      await getData().then((val) {
        ouser.role = val.data()['role'];
        ouser.products = val.data()['products'];
      });
      for (int i = 0; i < ouser.products.length; i++) {
        ouser.products[i] = tandl(ouser.products[i]);
      }
      if (ouser.products != null) {
        if (ouser.city == sf.fcity && ouser.products.contains(sf.fproduct)) {
          if (searchlist != null) {
            if (searchlist.contains(ouid) == false) {
              searchlist.add(ouid);
            }
          } else {
            searchlist.add(ouid);
          }
        }
      }
    }
  }

  Future<void> sfilter5(SearchFilter sf) async {
    for (int i = 0; i < usersList.length; i++) {
      var ouid = usersList[i];
      getData() async {
        return await uf.collection('users').doc(ouid).get();
      }

      var x;
      var y;
      await getData().then((val) {
        ouser.role = val.data()['role'];
        ouser.products = val.data()['products'];
        y = val.data()['longitude'];
        x = val.data()['latitude'];
      });
      for (int i = 0; i < ouser.products.length; i++) {
        ouser.products[i] = tandl(ouser.products[i]);
      }
      if (x != null &&
          y != null &&
          loccoord.latitude != null &&
          loccoord.longitude != null) {
        double distance = Geolocator.distanceBetween(
            x, y, loccoord.latitude, loccoord.longitude);
        if (distance != 0) {
          distance = distance / 1000;
        }
        if (ouser.products != null) {
          if (ouser.role == sf.frole &&
              ouser.products.contains(sf.fproduct) &&
              distance <= sf.frange) {
            if (searchlist != null) {
              if (searchlist.contains(ouid) == false) {
                searchlist.add(ouid);
              }
            } else {
              searchlist.add(ouid);
            }
          }
        }
      }
    }
  }

  Future<void> sfilter6(SearchFilter sf) async {
    for (int i = 0; i < usersList.length; i++) {
      var ouid = usersList[i];
      getData() async {
        return await uf.collection('users').doc(ouid).get();
      }

      var x;
      var y;
      await getData().then((val) {
        ouser.role = val.data()['role'];
        y = val.data()['longitude'];
        x = val.data()['latitude'];
      });
      if (x != null &&
          y != null &&
          loccoord.latitude != null &&
          loccoord.longitude != null) {
        double distance = Geolocator.distanceBetween(
            x, y, loccoord.latitude, loccoord.longitude);
        if (distance != 0) {
          distance = distance / 1000;
        }
        print('distnace $distance');
        if (ouser.role == sf.frole && distance <= sf.frange) {
          if (searchlist != null) {
            if (searchlist.contains(ouid) == false) {
              searchlist.add(ouid);
            }
          } else {
            searchlist.add(ouid);
          }
        }
      }
    }
  }

  Future<void> sfilter7(SearchFilter sf) async {
    for (int i = 0; i < usersList.length; i++) {
      var ouid = usersList[i];
      getData() async {
        return await uf.collection('users').doc(ouid).get();
      }

      var x;
      var y;
      await getData().then((val) {
        ouser.products = val.data()['products'];
        y = val.data()['longitude'];
        x = val.data()['latitude'];
      });
      for (int i = 0; i < ouser.products.length; i++) {
        ouser.products[i] = tandl(ouser.products[i]);
      }
      if (x != null &&
          y != null &&
          loccoord.latitude != null &&
          loccoord.longitude != null) {
        double distance = Geolocator.distanceBetween(
            x, y, loccoord.latitude, loccoord.longitude);
        if (distance != 0) {
          distance = distance / 1000;
        }
        if (ouser.products != null) {
          if (ouser.products.contains(sf.fproduct) && distance <= sf.frange) {
            if (searchlist != null) {
              if (searchlist.contains(ouid) == false) {
                searchlist.add(ouid);
              }
            } else {
              searchlist.add(ouid);
            }
          }
        }
      }
    }
  }

  Future<void> sfilter8(SearchFilter sf) async {
    for (int i = 0; i < usersList.length; i++) {
      var ouid = usersList[i];
      getData() async {
        return await uf.collection('users').doc(ouid).get();
      }

      var x;
      var y;
      await getData().then((val) {
        y = val.data()['longitude'];
        x = val.data()['latitude'];
      });
      if (x != null &&
          y != null &&
          loccoord.latitude != null &&
          loccoord.longitude != null) {
        double distance = Geolocator.distanceBetween(
            x, y, loccoord.latitude, loccoord.longitude);
        if (distance != 0) {
          distance = distance / 1000;
        }
        if (distance <= sf.frange) {
          if (searchlist != null) {
            if (searchlist.contains(ouid) == false) {
              searchlist.add(ouid);
            }
          } else {
            searchlist.add(ouid);
          }
        }
      }
    }
  }

  Future<void> sfilter9(SearchFilter sf) async {
    for (int i = 0; i < usersList.length; i++) {
      var ouid = usersList[i];
      getData() async {
        return await uf.collection('users').doc(ouid).get();
      }

      await getData().then((val) {
        ouser.products = val.data()['products'];
      });
      for (int i = 0; i < ouser.products.length; i++) {
        ouser.products[i] = tandl(ouser.products[i]);
      }
      if (ouser.products != null) {
        if (ouser.products.contains(sf.fproduct)) {
          if (searchlist != null) {
            if (searchlist.contains(ouid) == false) {
              searchlist.add(ouid);
            }
          } else {
            searchlist.add(ouid);
          }
        }
      }
    }
  }

  Future<void> sfilter10(SearchFilter sf) async {
    for (int i = 0; i < usersList.length; i++) {
      var ouid = usersList[i];
      getData() async {
        return await uf.collection('users').doc(ouid).get();
      }

      await getData().then((val) {
        ouser.city = val.data()['city'];
      });
      ouser.city = tandl(ouser.city);
      if (ouser.city == sf.fcity) {
        if (searchlist != null) {
          if (searchlist.contains(ouid) == false) {
            searchlist.add(ouid);
          }
        } else {
          searchlist.add(ouid);
        }
      }
    }
  }

  Future<void> sfilter11(SearchFilter sf) async {
    for (int i = 0; i < usersList.length; i++) {
      var ouid = usersList[i];
      getData() async {
        return await uf.collection('users').doc(ouid).get();
      }

      await getData().then((val) {
        ouser.role = val.data()['role'];
      });
      if (ouser.role == sf.frole) {
        if (searchlist != null) {
          print(ouid);
          if (searchlist.contains(ouid) == false) {
            searchlist.add(ouid);
          }
        } else {
          print(ouid);
          searchlist.add(ouid);
        }
      }
    }
  }
}
