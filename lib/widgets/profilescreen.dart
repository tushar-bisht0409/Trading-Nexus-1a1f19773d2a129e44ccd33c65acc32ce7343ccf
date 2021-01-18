import 'package:Nexus/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../providers/user.dart';
import '../providers/adduserdata.dart';
import 'package:geocode/geocode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile_screen';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File _image;
  var picker = ImagePicker();
  final corporation = TextEditingController();
  final city = TextEditingController();
  final product = TextEditingController();
  final userna = TextEditingController();
  final desc = TextEditingController();
  final pay = TextEditingController();
  final poli = TextEditingController();
  final contact = TextEditingController();
  var _isInit = true;
  var _isLoading = false;

  Future<void> getusersList() async {
    getData() async {
      return await FirebaseFirestore.instance
          .collection('usersList')
          .doc('usersList')
          .get();
    }

    await getData().then((val) {
      usersList = val.data()['usersList'];
    });
    print(usersList);
  }

  @override
  void didChangeDependencies() {
    if (mounted) {
      if (_isInit) {
        setState(() {
          _isLoading = true;
        });
      }
      Provider.of<UserData>(context, listen: false).getdata().then((_) {
        if (mounted) {
          setState(() {
            getusersList();
            _isLoading = false;
          });
        }
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    final profile = Provider.of<UserData>(context, listen: false);
    final deviceSize = MediaQuery.of(context).size;
    Useri user = profile.user;
    void coord(String addr) async {
      GeoCode geoCode = GeoCode();

      try {
        Coordinates coordinates =
            await geoCode.forwardGeocoding(address: '$addr');
        user.loci = coordinates;
        loccoord = coordinates;
        profile.setloci(coordinates);

        print("Latitude: ${coordinates.latitude}");
        print("Longitude: ${coordinates.longitude}");
      } catch (e) {
        print(e);
      }
      print(loccoord.latitude);
    }

    if (mounted && user.city == null && user.loci == null) {
      setState(() {
        coord('Delhi');
      });
    } else {
      coord(user.city);
    }

    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SafeArea(
            child: Scaffold(
                body: SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                        child: Container(
                            child: SingleChildScrollView(
                                child: Column(children: <Widget>[
                      SingleChildScrollView(
                          child: Row(children: <Widget>[
                        GestureDetector(
                          child: SingleChildScrollView(
                              child: Container(
                                  padding:
                                      EdgeInsets.all(deviceSize.height * 0.014),
                                  height: deviceSize.height * 0.2,
                                  width: deviceSize.height * 0.2,
                                  child: Card(
                                    elevation: 10,
                                    shadowColor: Colors.blue[900],
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            deviceSize.height * 0.18)),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: ClipOval(
                                          child: SizedBox(
                                            width: 100,
                                            height: 100,
                                            child:((user.imageUrl == null)
                                                    ? (Image.network(
                                                        'https://www.seekpng.com/png/full/297-2978586_rono-daniel-empty-profile-picture-icon.png',
                                                        fit: BoxFit.fill,
                                                      ))
                                                    : Image.network(
                                                        user.imageUrl,
                                                        fit: BoxFit.fill,
                                                      ))),
                                      ),
                                      // backgroundImage: AssetImage('assets/download.png'),
                                      radius: 70,
                                    ),
                                    //?CircleAvatar(
                                    //   child:(Image.network(
                                    //   'https://www.seekpng.com/png/full/297-2978586_rono-daniel-empty-profile-picture-icon.png',
                                    //   fit: BoxFit.fill,
                                    // ))
                                    // )
                                    // : CircleAvatar(
                                    //     backgroundImage: NetworkImage(
                                    //       user.imageUrl,
                                    //     ),
                                    //   ),
                                  ))),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) => 

                                Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child: Container(
                height: 350.0,
                width: 200.0,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30.0)),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(height: 150.0),
                        Container(
                          height: 100.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                              ),
                              color: Colors.blue[900]),
                        ),
                        Positioned(
                            top: 50.0,
                            left: 94.0,
                            child: CircleAvatar(
                              radius: 45,
                              backgroundColor: Colors.white,
                                child: Container(
                                height: 90.0,
                                width: 90.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(45.0),
                                    border: Border.all(
                                        color: Colors.white,
                                        style: BorderStyle.solid,
                                        width: 2.0),
                                   image: DecorationImage(
                                        image:
                                            NetworkImage(user.imageUrl==null?'https://www.seekpng.com/png/full/297-2978586_rono-daniel-empty-profile-picture-icon.png':null),
                                        fit: BoxFit.cover) 
                                    ),
                              ),
                            ))
                      ],
                    ),
                    SizedBox(height: 30.0),
                               SimpleDialogOption(
                                          onPressed: () async {
                                            var image = await picker.getImage(
                                                source: ImageSource.camera);
                                            if (mounted) {
                                              setState(() {
                                                _image = File(image.path);
                                                profile.getimageUrl(_image);
                                              });
                                            }
                                            Navigator.pop(context);
                                          },
                                          child: Row(
                                            children: [
                                              Icon(Icons.camera),
                                              SizedBox(width: 8),
                                              Text('Take Photo',
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                            ],
                                          ),
                                        ),
                                        SimpleDialogOption(
                                          onPressed: () async {
                                            var image = await picker.getImage(
                                                source: ImageSource.gallery);
                                            if (mounted) {
                                              setState(() {
                                                _image = File(image.path);
                                                //     profile.getimageUrl(_image);
                                              });
                                            }
                                            Navigator.pop(context);
                                          },
                                          child: Row(
                                            children: [
                                              Icon(Icons.arrow_upward_sharp),
                                              SizedBox(width: 8),
                                              Text('Upload Photo',
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                            ],
                                          ),
                                        ),
                                        SimpleDialogOption(
                                          onPressed: () {
                                            if (mounted) {
                                              setState(() {
                                                profile.getimageUrl(null, true);
                                                Navigator.pop(context);
                                              });
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              Icon(Icons.cancel),
                                              SizedBox(width: 8),
                                              Text('Remove Photo',
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                            ],
                                          ),
                                        ),
                    // FlatButton(
                    //   child: Center(
                    //     child: Text(
                    //       'OKAY',
                    //       style: TextStyle(
                    //           fontFamily: 'Montserrat',
                    //           fontSize: 14.0,
                    //           color: Colors.teal),
                    //     ),
                    //   ),
                    //   onPressed: () {
                    //     Navigator.of(context).pop();
                    //   },
                    //   color: Colors.transparent
                    // )
                  ],
                )))

                                // SimpleDialog(
                                //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                //       title: Text('Profile Photo',style: TextStyle(color: Colors.blue[900]),),
                                //       elevation: 5.0,
                                //       children: <Widget>[
                                //         SimpleDialogOption(
                                //           onPressed: () async {
                                //             var image = await picker.getImage(
                                //                 source: ImageSource.camera);
                                //             if (mounted) {
                                //               setState(() {
                                //                 _image = File(image.path);
                                //                 profile.getimageUrl(_image);
                                //               });
                                //             }
                                //             Navigator.pop(context);
                                //           },
                                //           child: Row(
                                //             children: [
                                //               Icon(Icons.camera),
                                //               SizedBox(width: 8),
                                //               Text('Take Photo',
                                //                   style: TextStyle(
                                //                       color: Colors.black)),
                                //             ],
                                //           ),
                                //         ),
                                //         SimpleDialogOption(
                                //           onPressed: () async {
                                //             var image = await picker.getImage(
                                //                 source: ImageSource.gallery);
                                //             if (mounted) {
                                //               setState(() {
                                //                 _image = File(image.path);
                                //                 //     profile.getimageUrl(_image);
                                //               });
                                //             }
                                //             Navigator.pop(context);
                                //           },
                                //           child: Row(
                                //             children: [
                                //               Icon(Icons.arrow_upward_sharp),
                                //               SizedBox(width: 8),
                                //               Text('Upload Photo',
                                //                   style: TextStyle(
                                //                       color: Colors.black)),
                                //             ],
                                //           ),
                                //         ),
                                //         SimpleDialogOption(
                                //           onPressed: () {
                                //             if (mounted) {
                                //               setState(() {
                                //                 profile.getimageUrl(null, true);
                                //                 Navigator.pop(context);
                                //               });
                                //             }
                                //           },
                                //           child: Row(
                                //             children: [
                                //               Icon(Icons.cancel),
                                //               SizedBox(width: 8),
                                //               Text('Remove Photo',
                                //                   style: TextStyle(
                                //                       color: Colors.black)),
                                //             ],
                                //           ),
                                //         ),
                                //       ],
                                //     )
                              );
                          },
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                              padding:
                                  EdgeInsets.all(deviceSize.height * 0.014),
                              height: deviceSize.height * 0.1,
                              width:
                                  deviceSize.width - deviceSize.height * 0.25,
                              child: Card(
                                  color: Colors.blue[900],
                                  elevation: 10,
                                  shadowColor: Colors.blue[900],
                                  shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                    padding: user.role !=
                                            'Raw Material Supplier'
                                        ? EdgeInsets.only(
                                            left: (deviceSize.width -
                                                    deviceSize.height * 0.25) *
                                                0.25)
                                        : EdgeInsets.only(
                                            left: (deviceSize.width -
                                                    deviceSize.height * 0.25) *
                                                0.1),
                                    child: Container(
                                        width: deviceSize.width -
                                            deviceSize.height * 0.25,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                            child: DropdownButton<String>(
                                              value: user.role,
                                              elevation: 0,
                                              underline: Container(
                                                color: Colors.blue[900],
                                                height: 0,
                                              ),
                                              dropdownColor: Colors.white,
                                              iconEnabledColor:
                                                  Colors.blue[900],
                                              iconDisabledColor:
                                                  Colors.blue[900],
                                              onChanged: (String value) {
                                                if (mounted) {
                                                  setState(() {
                                                    profile.setrole(value);
                                                  });
                                                }
                                              },
                                              items: <String>[
                                                'Raw Material Supplier',
                                                'Manufacturer',
                                                'Distributor',
                                                'Wholesalers',
                                                'Retailers',
                                                'Transportation'
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: value != null
                                                      ? Center(
                                                          child: Text(value,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue[900])),
                                                        )
                                                      : Center(
                                                          child: Text(
                                                          'Enter Role',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                );
                                              }).toList(),
                                            ))),
                                  ))),
                        )
                      ])),
                      SingleChildScrollView(
                          child: GestureDetector(
                        child: SingleChildScrollView(
                            child: Container(
                                padding:
                                    EdgeInsets.all(deviceSize.height * 0.014),
                                //  height: deviceSize.height * 0.1,
                                width: deviceSize.width * 0.9,
                                child: Card(
                                    elevation: 10,
                                    shadowColor: Colors.blue[900],
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            deviceSize.height * 0.18)),
                                    child: Padding(
                                        padding: EdgeInsets.all(
                                            deviceSize.height * 0.03),
                                        child: Center(
                                          child: user.corporationName == null
                                              ? Center(
                                                  child: Text(
                                                      'Enter Corporation Name!',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .blue[900])))
                                              : Text(
                                                  'Corporation : ' +
                                                      user.corporationName,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.blue[900])),
                                        ))))),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    content: TextField(
                                        decoration: InputDecoration(
                                            labelText: 'Corporation Name'),
                                        controller: corporation),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Cancel'),
                                        color: Colors.blue[50],
                                        textColor: Colors.blue[900],
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      FlatButton(
                                          child: Text('Save'),
                                           color: Colors.blue[50],
                                           textColor: Colors.blue[900],
                                          onPressed: () {
                                            //  setState(() {
                                            user.corporationName =
                                                corporation.text;
                                            profile.setcorporationName(
                                                corporation.text);
                                            Navigator.pop(context);
                                          })
                                      //},
                                    ],
                                    elevation: 24,
                                    backgroundColor: Colors.white,
                                    // shape: CircularBorder(),
                                  ));
                        },
                      )),
                      SingleChildScrollView(
                          child: GestureDetector(
                        child: SingleChildScrollView(
                            child: Container(
                                padding:
                                    EdgeInsets.all(deviceSize.height * 0.014),
                                //  height: deviceSize.height * 0.1,
                                width: deviceSize.width * 0.9,
                                child: Card(
                                    elevation: 10,
                                    shadowColor: Colors.blue[900],
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            deviceSize.height * 0.18)),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          deviceSize.height * 0.03),
                                      child: Center(
                                          child: user.userName == null
                                              ? Center(
                                                  child: Text(
                                                      'Enter Your Name !',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .blue[900])))
                                              : Text(
                                                  'Owner/Agent : ' +
                                                      user.userName,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.blue[900]))),
                                    )))),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    content: TextField(
                                        decoration: InputDecoration(
                                            labelText: 'User Name'),
                                        controller: userna),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Cancel'),
                                         color: Colors.blue[50],
                                        textColor: Colors.blue[900],
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      FlatButton(
                                        child: Text('Save'),
                                         color: Colors.blue[50],
                                        textColor: Colors.blue[900],
                                        onPressed: () {
                                          //  setState(() {
                                          user.userName = userna.text;
                                          profile.setuserName(userna.text);
                                          Navigator.pop(context);
                                          // });
                                        },
                                      )
                                    ],
                                    elevation: 24,
                                    backgroundColor: Colors.white,
                                    // shape: CircularBorder(),
                                  ));
                        },
                      )),
                      SingleChildScrollView(
                          child: GestureDetector(
                        child: SingleChildScrollView(
                            child: Container(
                                padding:
                                    EdgeInsets.all(deviceSize.height * 0.014),
                                // height: deviceSize.height * 0.1,
                                width: deviceSize.width * 0.9,
                                child: Card(
                                    elevation: 10,
                                    shadowColor: Colors.blue[900],
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            deviceSize.height * 0.18)),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          deviceSize.height * 0.03),
                                      child: Center(
                                          child: user.city == 'null' ||
                                                  user.city == null
                                              ? Center(
                                                  child: Text('Enter City !',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .blue[900])))
                                              : Text('City : ' + user.city,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.blue[900]))),
                                    )))),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    content: TextField(
                                        decoration: InputDecoration(
                                            labelText: 'City of Working'),
                                        controller: city),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Cancel'),
                                         color: Colors.blue[50],
                                        textColor: Colors.blue[900],
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      FlatButton(
                                        child: Text('Save'),
                                         color: Colors.blue[50],
                                        textColor: Colors.blue[900],
                                        onPressed: () {
                                          if (city.text != null &&
                                              city.text.length > 1) {
                                            user.city = city.text;
                                            coord(city.text);
                                            profile.setcity(city.text);
                                            Navigator.pop(context);
                                          }
                                        },
                                      )
                                    ],
                                    elevation: 24,
                                    backgroundColor: Colors.white,
                                    // shape: CircularBorder(),
                                  ));
                        },
                      )),
                      SingleChildScrollView(
                          child: GestureDetector(
                        child: SingleChildScrollView(
                            child: Container(
                                padding:
                                    EdgeInsets.all(deviceSize.height * 0.014),
                                //   height: deviceSize.height * 0.15,
                                width: deviceSize.width * 0.9,
                                child: Card(
                                    elevation: 10,
                                    shadowColor: Colors.blue[900],
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            deviceSize.height * 0.18)),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          deviceSize.height * 0.03),
                                      child: Center(
                                          child: user.contactInfo == 'null' ||
                                                  user.contactInfo == null
                                              ? Center(
                                                  child: Text(
                                                      'Enter Contact information !',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .blue[900])))
                                              : Text(
                                                  'Contact Us On : ' +
                                                      user.contactInfo,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.blue[900]))),
                                    )))),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    content: TextField(
                                        decoration: InputDecoration(
                                            labelText: 'Phone no./Email'),
                                        controller: contact),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Cancel'),
                                         color: Colors.blue[50],
                                        textColor: Colors.blue[900],
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      FlatButton(
                                        child: Text('Save'),
                                         color: Colors.blue[50],
                                        textColor: Colors.blue[900],
                                        onPressed: () {
                                          // setState(() {
                                          user.contactInfo = contact.text;
                                          profile.setcontactInfo(contact.text);
                                          Navigator.pop(context);
                                          // });
                                        },
                                      )
                                    ],
                                    elevation: 24,
                                    backgroundColor: Colors.white,
                                    // shape: CircularBorder(),
                                  ));
                        },
                      )),
                      SingleChildScrollView(
                          child: GestureDetector(
                        child: SingleChildScrollView(
                            child: Container(
                                padding:
                                    EdgeInsets.all(deviceSize.height * 0.014),
                                //  height: deviceSize.height * 0.1,
                                width: deviceSize.width * 0.9,
                                child: Card(
                                    elevation: 10,
                                    shadowColor: Colors.blue[900],
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            deviceSize.height * 0.18)),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          deviceSize.height * 0.03),
                                      child: Center(
                                          child: user.imageUrl == 'null' ||
                                                  user.imageUrl == null
                                              ? Center(
                                                  child: Text(
                                                      'Your Products List',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .blue[900])))
                                              : Text(
                                                  'View or Edit Products List',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.blue[900]))),
                                    )))),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => SimpleDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    title: const Text('Products List'),
                                    children: <Widget>[
                                      SimpleDialogOption(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (_) => StatefulBuilder(
                                                      builder:
                                                          (context, setState) {
                                                    return AlertDialog(
                                                      content:
                                                          SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              child: Container(
                                                                height: deviceSize
                                                                        .height *
                                                                    0.3,
                                                                //          child: SingleChildScrollView(
                                                                child: Column(
                                                                    children: <
                                                                        Widget>[
                                                                      prodlist != null &&
                                                                              prodlist.length > 0
                                                                          ? Expanded(
                                                                              child: SizedBox(
                                                                                  // height: deviceSize.height * 0.3,
                                                                                  width: deviceSize.width * 0.4,
                                                                                  child: ListView(
                                                                                      shrinkWrap: true,
                                                                                      children: user.products.map((product) {
                                                                                        return Card(
                                                                                          elevation: 0,
                                                                                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                                                                                            Text(
                                                                                              product,
                                                                                              style: TextStyle(color: Colors.blue[900], fontSize: 24),
                                                                                            ),
                                                                                          ]),
                                                                                        );
                                                                                      }).toList())))
                                                                          : Center(
                                                                              child: Text('No Product added'),
                                                                            ),
                                                                    ]),
                                                                //  )
                                                              )),
                                                      actions: <Widget>[
                                                        Center(
                                                            child: FlatButton(
                                                          child: Text('Ok'),
                                                          textColor:
                                                              Colors.blue[900],
                                                          onPressed: () {
                                                            setState(() {
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          },
                                                        )),
                                                      ],
                                                      elevation: 24,
                                                      backgroundColor:
                                                          Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          30))),
                                                    );
                                                  }));
                                        },
                                        child: Text('View List',
                                            style: TextStyle(
                                                color: Colors.blue[900])),
                                      ),
                                      SimpleDialogOption(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder:
                                                  (_) =>
                                                      StatefulBuilder(builder:
                                                          (context, setState) {
                                                        return AlertDialog(
                                                          content:
                                                              SingleChildScrollView(
                                                                  scrollDirection:
                                                                      Axis
                                                                          .horizontal,
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        deviceSize.height *
                                                                            0.3,
                                                                    //          child: SingleChildScrollView(
                                                                    child: Column(
                                                                        children: <
                                                                            Widget>[
                                                                          prodlist != null && prodlist.length > 0
                                                                              ? Expanded(
                                                                                  child: SizedBox(
                                                                                      // height: deviceSize.height * 0.3,
                                                                                      width: deviceSize.width * 0.4,
                                                                                      child: ListView(
                                                                                          shrinkWrap: true,
                                                                                          children: List.generate(user.products.length, (index) {
                                                                                            return Card(
                                                                                              elevation: 0,
                                                                                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                                                                                                Text(
                                                                                                  user.products[index],
                                                                                                  style: TextStyle(color: Colors.blue[900]),
                                                                                                ),
                                                                                                // textColor: Colors.green[800] ,
                                                                                                Card(
                                                                                                    margin: EdgeInsets.all(10),
                                                                                                    elevation: 0,
                                                                                                    child: IconButton(
                                                                                                      icon: Icon(
                                                                                                        Icons.delete,
                                                                                                        color: Colors.yellow[800],
                                                                                                      ),
                                                                                                      onPressed: () {
                                                                                                        setState(() {
                                                                                                          profile.setproducts(user.products[index], true);
                                                                                                        });
                                                                                                      },
                                                                                                    )),
                                                                                              ]),
                                                                                            );
                                                                                          }).toList())))
                                                                              : Center(
                                                                                  child: Text('No Product added'),
                                                                                ),
                                                                          Container(
                                                                              padding: EdgeInsets.all(deviceSize.height * 0.014),
                                                                              height: deviceSize.height * 0.1,
                                                                              width: deviceSize.width - deviceSize.height * 0.25,
                                                                              child: TextField(decoration: InputDecoration(labelText: 'Prodcut'), controller: product))
                                                                        ]),
                                                                    //  )
                                                                  )),
                                                          actions: <Widget>[
                                                            Center(
                                                                child:
                                                                    FlatButton(
                                                              child: Text(
                                                                  'Add to list'),
                                                              textColor: Colors
                                                                  .blue[900],
                                                              onPressed: () {
                                                                //      setState(() {
                                                                profile
                                                                    .setproducts(
                                                                        product
                                                                            .text,
                                                                        false);
                                                                //      });
                                                              },
                                                            )),
                                                          ],
                                                          elevation: 24,
                                                          backgroundColor:
                                                              Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          30))),
                                                        );
                                                      }));
                                        },
                                        child: Text('Edit List',
                                            style: TextStyle(
                                                color: Colors.blue[900])),
                                      ),
                                    ],
                                  ));
                        },
                      )),
                      SingleChildScrollView(
                          child: Column(children: <Widget>[
                        GestureDetector(
                          child: SingleChildScrollView(
                              child: Container(
                                  padding:
                                      EdgeInsets.all(deviceSize.height * 0.014),
                                  //  height: deviceSize.height * 0.25,
                                  width: deviceSize.width * 0.9,
                                  child: Card(
                                      elevation: 10,
                                      shadowColor: Colors.blue[900],
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              deviceSize.height * 0.18)),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            deviceSize.height * 0.03),
                                        child: user.description == 'null' ||
                                                user.description == null
                                            ? Center(
                                                child: Text('Add Description !',
                                                    style: TextStyle(
                                                        color:
                                                            Colors.blue[900])))
                                            : Center(
                                                child: Text(
                                                    'Description : ' +
                                                        user.description,
                                                    style: TextStyle(
                                                        color: Colors
                                                            .blue[900]))),
                                      )))),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      content: TextField(
                                          decoration: InputDecoration(
                                              labelText: 'Description'),
                                          controller: desc),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Cancel'),
                                          textColor: Colors.blue[900],
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        FlatButton(
                                          child: Text('Save'),
                                          textColor: Colors.blue[900],
                                          onPressed: () {
                                            //   setState(() {
                                            user.description = desc.text;
                                            profile.setdescription(desc.text);
                                            Navigator.pop(context);
                                            //   });
                                          },
                                        )
                                      ],
                                      elevation: 24,
                                      backgroundColor: Colors.white,
                                      // shape: CircularBorder(),
                                    ));
                          },
                        ),
                        SingleChildScrollView(
                            child: GestureDetector(
                          child: SingleChildScrollView(
                              child: Container(
                                  padding:
                                      EdgeInsets.all(deviceSize.height * 0.014),
                                  //     height: deviceSize.height * 0.25,
                                  width: deviceSize.width * 0.9,
                                  child: Card(
                                      elevation: 10,
                                      shadowColor: Colors.blue[900],
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              deviceSize.height * 0.18)),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            deviceSize.height * 0.03),
                                        child: user.policy == 'null' ||
                                                user.policy == null
                                            ? Center(
                                                child: Text(
                                                    'Policy and rules of Trade',
                                                    style: TextStyle(
                                                        color:
                                                            Colors.blue[900])))
                                            : Center(
                                                child: Text(
                                                    'Policy/Rules : ' +
                                                        user.policy,
                                                    style: TextStyle(
                                                        color: Colors
                                                            .blue[900]))),
                                      )))),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      content: TextField(
                                          decoration: InputDecoration(
                                              labelText: 'Policy And Rules'),
                                          controller: poli),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Cancel'),
                                          textColor: Colors.blue[900],
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        FlatButton(
                                          child: Text('Save'),
                                          textColor: Colors.blue[900],
                                          onPressed: () {
                                            //     setState(() {
                                            user.policy = poli.text;
                                            profile.setpolicy(poli.text);
                                            Navigator.pop(context);
                                            //    });
                                          },
                                        )
                                      ],
                                      elevation: 24,
                                      backgroundColor: Colors.white,
                                      // shape: CircularBorder(),
                                    ));
                          },
                        )),
                        SingleChildScrollView(
                            child: GestureDetector(
                          child: SingleChildScrollView(
                              child: Container(
                                  padding:
                                      EdgeInsets.all(deviceSize.height * 0.014),
                                  //  height: deviceSize.height * 0.25,
                                  width: deviceSize.width * 0.9,
                                  child: Card(
                                      elevation: 10,
                                      shadowColor: Colors.blue[900],
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              deviceSize.height * 0.18)),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            deviceSize.height * 0.03),
                                        child: user.payment == 'null' ||
                                                user.payment == null
                                            ? Center(
                                                child: Text(
                                                    'Your Payment Methods',
                                                    style: TextStyle(
                                                        color:
                                                            Colors.blue[900])))
                                            : Center(
                                                child: Text(
                                                    '#About Payments# : ' +
                                                        user.payment,
                                                    style: TextStyle(
                                                        color: Colors
                                                            .blue[900]))),
                                      )))),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      content: TextField(
                                          decoration: InputDecoration(
                                              labelText: 'Payment System'),
                                          controller: pay),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Cancel'),
                                          textColor: Colors.blue[900],
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        FlatButton(
                                          child: Text('Save'),
                                          textColor: Colors.blue[900],
                                          onPressed: () {
                                            //     setState(() {
                                            user.payment = pay.text;
                                            profile.setpayment(pay.text);
                                            Navigator.pop(context);
                                            // });
                                          },
                                        )
                                      ],
                                      elevation: 24,
                                      backgroundColor: Colors.white,
                                      // shape: CircularBorder(),
                                    ));
                          },
                        ))
                      ]))
                    ])))))),
          );
  }
}
