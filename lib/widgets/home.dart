import 'package:Nexus/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/adduserdata.dart';
import 'package:provider/provider.dart';
import '../screens/searchscreen.dart';
import 'package:flutter/material.dart';
import './hometabs.dart';

class Home extends StatelessWidget {
  static const routeName = '/home';
  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser.uid);
    Provider.of<UserData>(context, listen: false).setusid();
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return SafeArea(
          child: Scaffold(
          drawer: NexusDrawer(),
          body: SingleChildScrollView(
              child: Column(children: <Widget>[
           //     SizedBox(height: 5,),
            Container(
              color: Colors.blue[900],
                height: queryData.orientation == Orientation.portrait
                    ? queryData.size.height * 0.1
                    : queryData.size.height * 0.15,
                child: Card(
                  color: Colors.blue[900],
                    elevation: 0,
                    child: Row(children: <Widget>[
                      Builder(
                          builder: (context) => IconButton(
                                icon: Icon(Icons.menu,color: Colors.white,),
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                              )),
                      Card(
                          elevation: 0,
                          color: Colors.grey[200],
                          child: Container(
                              width: queryData.size.width * 0.65,
                              child: Row(children: <Widget>[
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed(SearchScreen.routeName);
                                    },
                                    child: Row(children: <Widget>[
                                      Icon(Icons.search),
                                      SizedBox(width: 5,),
                                      Text('Search',style: TextStyle(color: Colors.grey[600]),),
                                      Padding(
                                          padding: EdgeInsets.only(
                                        right: queryData.size.width * 0.65 * 0.4,
                                      ))
                                    ]))
                              ]))),
                      
                      Padding(
                        padding: const EdgeInsets.only(left:8),
                        child: Card(
                            elevation: 0,
                            color: Colors.blue[900],
                            child: IconButton(
                              icon: Icon(Icons.message,
                              size: 30,
                              color: Colors.white,),
                              onPressed: () {
                                //    ChatScreen();
                              },
                            )),
                      )
                    ])
                    ),
                    ),
                  HomeTab()
          ]))),
    );
  }
}
