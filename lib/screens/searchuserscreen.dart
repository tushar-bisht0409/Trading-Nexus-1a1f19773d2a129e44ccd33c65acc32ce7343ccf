import 'package:Nexus/main.dart';
import '../widgets/drawer.dart';
import 'package:flutter/material.dart';
import '../providers/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../providers/adduserdata.dart';

class SearchUserScreen extends StatefulWidget {
  static const routeName = '/search_user';
  @override
  _SearchUserScreenState createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  var _isLoading = true;
  List<dynamic> nexususer = searchlist;
  Useri ouser = Useri();
  var uf = FirebaseFirestore.instance;
  String ouid;

  Future<void> otherdata(String ouid) async {
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
      ouser.nexusList = val.data()['nexus list'];
    });
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ouid = nexususer[ouserindex];
    final deviceSize = MediaQuery.of(context).size;
    otherdata(ouid);
    // Provider.of<UserData>(context, listen: false).getdata();
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('Name'),
            ),
            drawer: NexusDrawer(),
            body: SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                    child: Container(
                        child: SingleChildScrollView(
                            child: Column(children: <Widget>[
                  SingleChildScrollView(
                      child: Row(children: <Widget>[
                    SingleChildScrollView(
                        child: Container(
                            padding: EdgeInsets.all(deviceSize.height * 0.014),
                            height: deviceSize.height * 0.2,
                            width: deviceSize.height * 0.2,
                            child: Card(
                              elevation: 10,
                              shadowColor: Colors.green[900],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      deviceSize.height * 0.18)),
                              child: ouser.imageUrl == null
                                  ? Icon(
                                      Icons.account_circle,
                                      size: 100,
                                      color: Colors.yellow[400],
                                    )
                                  : CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        ouser.imageUrl,
                                      ),
                                    ),
                            ))),
                    SingleChildScrollView(
                        child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Container(
                              color: Colors.green[400],
                              padding: EdgeInsets.all(12),
                              height: deviceSize.height * 0.085,
                              child: Card(
                                  elevation: 0,
                                  color: Colors.green[400],
                                  child: ouser.role != null
                                      ? Center(
                                          child: Text(ouser.role,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16)),
                                        )
                                      : Center(
                                          child: Text(
                                          'Unknown',
                                          style: TextStyle(color: Colors.white),
                                        )))),
                          Row(
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.all(13),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.connect_without_contact,
                                      size: 30,
                                      color: nexlist.contains(ouser.userID)
                                          ? Colors.green[300]
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      if (mounted) {
                                        setState(() {
                                          if (nexlist.contains(ouser.userID)) {
                                            Provider.of<UserData>(context,
                                                    listen: false)
                                                .setnexuslist(
                                                    ouser.userID, true);
                                          } else {
                                            Provider.of<UserData>(context,
                                                    listen: false)
                                                .setnexuslist(
                                                    ouser.userID, false);
                                          }
                                        });
                                      }
                                    },
                                  )),
                              Padding(
                                  padding: EdgeInsets.all(13),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.message,
                                      size: 30,
                                      color: Colors.green[300],
                                    ),
                                    onPressed: () {},
                                  ))
                            ],
                          )
                        ],
                      ),
                    ))
                  ])),
                  SingleChildScrollView(
                    child: SingleChildScrollView(
                        child: Container(
                            padding: EdgeInsets.all(deviceSize.height * 0.014),
                            //        height: deviceSize.height * 0.1,
                            width: deviceSize.width * 0.9,
                            child: Card(
                                elevation: 10,
                                shadowColor: Colors.green[900],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        deviceSize.height * 0.18)),
                                child: Padding(
                                    padding: EdgeInsets.all(
                                        deviceSize.height * 0.03),
                                    child: Center(
                                      child: ouser.corporationName == null
                                          ? Center(
                                              child: Text(
                                              'Unknown',
                                              style: TextStyle(
                                                  color: Colors.green[700]),
                                            ))
                                          : Text(
                                              'Corporation : ' +
                                                  ouser.corporationName,
                                              style: TextStyle(
                                                  color: Colors.green[700])),
                                    ))))),
                  ),
                  SingleChildScrollView(
                    child: SingleChildScrollView(
                        child: Container(
                            padding: EdgeInsets.all(deviceSize.height * 0.014),
                            //         height: deviceSize.height * 0.1,
                            width: deviceSize.width * 0.9,
                            child: Card(
                                elevation: 10,
                                shadowColor: Colors.green[900],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        deviceSize.height * 0.18)),
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(deviceSize.height * 0.03),
                                  child: Center(
                                      child: ouser.userName == null
                                          ? Center(
                                              child: Text('Enter Your Name !',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.green[700])))
                                          : Text(
                                              'Owner/Agent : ' + ouser.userName,
                                              style: TextStyle(
                                                  color: Colors.green[700]))),
                                )))),
                  ),
                  SingleChildScrollView(
                    child: SingleChildScrollView(
                        child: Container(
                            padding: EdgeInsets.all(deviceSize.height * 0.014),
                            //        height: deviceSize.height * 0.1,
                            width: deviceSize.width * 0.9,
                            child: Card(
                                elevation: 10,
                                shadowColor: Colors.green[900],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        deviceSize.height * 0.18)),
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(deviceSize.height * 0.03),
                                  child: Center(
                                      child: ouser.city == 'null' ||
                                              ouser.city == null
                                          ? Center(
                                              child: Text('Enter City !',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.green[700])))
                                          : Text('City : ' + ouser.city,
                                              style: TextStyle(
                                                  color: Colors.green[700]))),
                                )))),
                  ),
                  SingleChildScrollView(
                    child: SingleChildScrollView(
                        child: Container(
                            padding: EdgeInsets.all(deviceSize.height * 0.014),
                            //      height: deviceSize.height * 0.15,
                            width: deviceSize.width * 0.9,
                            child: Card(
                                elevation: 10,
                                shadowColor: Colors.green[900],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        deviceSize.height * 0.18)),
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(deviceSize.height * 0.03),
                                  child: Center(
                                      child: ouser.contactInfo == 'null' ||
                                              ouser.contactInfo == null
                                          ? Center(
                                              child: Text(
                                                  'Enter Contact information !',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.green[700])))
                                          : Text(
                                              'Contact Us On : ' +
                                                  ouser.contactInfo,
                                              style: TextStyle(
                                                  color: Colors.green[700]))),
                                )))),
                  ),
                  GestureDetector(
                    child: SingleChildScrollView(
                        child: Container(
                            padding: EdgeInsets.all(deviceSize.height * 0.014),
                            //  height: deviceSize.height * 0.1,
                            width: deviceSize.width * 0.9,
                            child: Card(
                                elevation: 10,
                                shadowColor: Colors.green[900],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        deviceSize.height * 0.18)),
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(deviceSize.height * 0.03),
                                  child: Center(
                                      child: Text('View Products List',
                                          style: TextStyle(
                                              color: Colors.green[700]))),
                                )))),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder:
                              (_) =>
                                  StatefulBuilder(builder: (context, setState) {
                                    return AlertDialog(
                                      content: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Container(
                                            height: deviceSize.height * 0.3,
                                            //          child: SingleChildScrollView(
                                            child: Column(children: <Widget>[
                                              ouser.products != null &&
                                                      ouser.products.length > 0
                                                  ? Expanded(
                                                      child: SizedBox(
                                                          // height: deviceSize.height * 0.3,
                                                          width:
                                                              deviceSize.width *
                                                                  0.4,
                                                          child: ListView(
                                                              shrinkWrap: true,
                                                              children: ouser
                                                                  .products
                                                                  .map(
                                                                      (product) {
                                                                return Card(
                                                                  elevation: 0,
                                                                  child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        Text(
                                                                          product,
                                                                          style: TextStyle(
                                                                              color: Colors.green[600],
                                                                              fontSize: 24),
                                                                        ),
                                                                      ]),
                                                                );
                                                              }).toList())))
                                                  : Center(
                                                      child: Text(
                                                          'No Product added'),
                                                    ),
                                            ]),
                                            //  )
                                          )),
                                      actions: <Widget>[
                                        Center(
                                            child: FlatButton(
                                          child: Text('Ok'),
                                          textColor: Colors.green[800],
                                          onPressed: () {
                                            setState(() {
                                              Navigator.pop(context);
                                            });
                                          },
                                        )),
                                      ],
                                      elevation: 24,
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30))),
                                    );
                                  }));
                    },
                  ),
                  SingleChildScrollView(
                      child: Column(children: <Widget>[
                    SingleChildScrollView(
                        child: Container(
                            padding: EdgeInsets.all(deviceSize.height * 0.014),
                            //        height: deviceSize.height * 0.25,
                            width: deviceSize.width * 0.9,
                            child: Card(
                                elevation: 10,
                                shadowColor: Colors.green[900],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        deviceSize.height * 0.18)),
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(deviceSize.height * 0.03),
                                  child: ouser.description == 'null' ||
                                          ouser.description == null
                                      ? Center(
                                          child: Text('Add Description !',
                                              style: TextStyle(
                                                  color: Colors.green[700])))
                                      : Center(
                                          child: Text(
                                              'Description : ' +
                                                  ouser.description,
                                              style: TextStyle(
                                                  color: Colors.green[700]))),
                                )))),
                    SingleChildScrollView(
                        child: Container(
                            padding: EdgeInsets.all(deviceSize.height * 0.014),
                            //    height: deviceSize.height * 0.25,
                            width: deviceSize.width * 0.9,
                            child: Card(
                                elevation: 10,
                                shadowColor: Colors.green[900],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        deviceSize.height * 0.18)),
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(deviceSize.height * 0.03),
                                  child: ouser.policy == 'null' ||
                                          ouser.policy == null
                                      ? Center(
                                          child: Text(
                                              'Policy and rules of Trade',
                                              style: TextStyle(
                                                  color: Colors.green[700])))
                                      : Center(
                                          child: Text(
                                              'Policy/Rules : ' + ouser.policy,
                                              style: TextStyle(
                                                  color: Colors.green[700]))),
                                )))),
                    SingleChildScrollView(
                        child: Container(
                            padding: EdgeInsets.all(deviceSize.height * 0.014),
                            //  height: deviceSize.height * 0.25,
                            width: deviceSize.width * 0.9,
                            child: Card(
                                elevation: 10,
                                shadowColor: Colors.green[900],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        deviceSize.height * 0.18)),
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(deviceSize.height * 0.03),
                                  child: ouser.payment == 'null' ||
                                          ouser.payment == null
                                      ? Center(
                                          child: Text('Your Payment Methods',
                                              style: TextStyle(
                                                  color: Colors.green[700])))
                                      : Center(
                                          child: Text(
                                              'About Payments : ' +
                                                  ouser.payment,
                                              style: TextStyle(
                                                  color: Colors.green[700]))),
                                )))),
                  ]))
                ]))))));
  }
}
