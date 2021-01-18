import 'package:Nexus/main.dart';

import '../screens/otheruserscreen.dart';
import 'package:flutter/material.dart';
import '../providers/user.dart';
//import 'package:firebase_storage/firebase_storage.dart'
import 'package:cloud_firestore/cloud_firestore.dart';
//import '../providers/user.dart';

//ignore: must_be_immutable
class NexusScreen extends StatefulWidget {
  static const routeName = '/nexus';
//  List<dynamic> nexususer;
  // NexusScreen(this.nexususer);
  @override
  _NexusScreenState createState() => _NexusScreenState();
}

class _NexusScreenState extends State<NexusScreen> {
  List<Useri> nlist = [];
  var uf = FirebaseFirestore.instance; //= nexlist;
  List<dynamic> nexususer;
  bool _isLoading = true;

  void makinglist(Useri nu) {
    if (nu.userName == null) {
      nu.userName = 'Unknown';
    }
    if (nu.role == null) {
      nu.role = 'Unknown';
    }
    if (nu.corporationName == null) {
      nu.corporationName = 'Unknown';
    }
    if (nu.imageUrl == null) {
      nu.imageUrl = 'Unknown';
    }
    nlist.add(Useri(
        userName: nu.userName,
        imageUrl: nu.imageUrl,
        corporationName: nu.corporationName,
        role: nu.role));
    //   print('');
  }

  Future<void> nuserdata() async {
    Useri ouser = Useri();
    int i;
    String ouid;
    if (nlist.length != nexususer.length) {
      for (i = 0; i < nexususer.length; i++) {
        ouid = nexususer[i];
        getData() async {
          return await uf.collection('users').doc(ouid).get();
        }

        await getData().then((val) {
          ouser.role = val.data()['role'];
          ouser.userName = val.data()['user name'];
          ouser.corporationName = val.data()['corporation'];
          ouser.imageUrl = val.data()['image url'];
          ouser.userID = val.data()['uid'];
        });
        makinglist(ouser);
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    nexususer = nexlist;
    // nexususer = widget.nexususer;
    final deviceSize = MediaQuery.of(context).size;
    if (nexususer != null && nexususer.length > 0) {
      if (mounted) {
        setState(() {
          nuserdata();
        });
      }
      return _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              key: Key(nexususer.length.toString()),
              children: List.generate(nlist.length, (index) {
                return GestureDetector(
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                            width: deviceSize.width,
                            height: 100,
                            child: Center(
                                child: Card(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100.0)),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(children: <Widget>[
                                        //   Padding(
                                        //     padding: EdgeInsets.all(20),
                                        //  child:
                                        nlist[index].imageUrl == 'Unknown'
                                            ? Icon(
                                                Icons.account_circle,
                                                size: 100,
                                                color: Colors.yellow[400],
                                              )
                                            : CircleAvatar(
                                                radius: 50,
                                                backgroundImage: NetworkImage(
                                                  nlist[index].imageUrl,
                                                ),
                                              ),
                                        //   ),
                                        Card(
                                            margin: EdgeInsets.only(
                                                left: 25,
                                                right: 10,
                                                top: 15,
                                                bottom: 5),
                                            elevation: 0,
                                            child: Padding(
                                                padding: EdgeInsets.all(10),
                                                child:
                                                    Column(children: <Widget>[
                                                  Text(
                                                      nlist[index]
                                                          .corporationName,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          color: Colors
                                                              .green[500])),
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.all(5)),
                                                  Text(nlist[index].userName,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w100,
                                                          color:
                                                              Colors.green[300],
                                                          fontStyle:
                                                              FontStyle.italic))
                                                ]))),
                                        Card(
                                          margin: EdgeInsets.all(20),
                                          elevation: 0,
                                          child: Text(nlist[index].role,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.green[700])),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.message,
                                            size: 30,
                                            color: Colors.green[300],
                                          ),
                                          onPressed: () {},
                                        )
                                      ]),
                                    ))))),
                    onTap: () {
                      if (mounted) {
                        setState(() {
                          ouserindex = index;
                        });
                      }
                      // print(index);
                      Navigator.of(context)
                          .pushNamed(OtherUserScreen.routeName);
                    });
              }).toList(),
            );
    } else {
      return Center(child: Text('Nothing Here ....Find Some'));
    }
  }
}
