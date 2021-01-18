import 'package:Nexus/providers/adduserdata.dart';
import './screens/searchscreen.dart';
import './screens/nexuscreen.dart';
import './screens/otheruserscreen.dart';
import './screens/searchuserscreen.dart';
import './widgets/profilescreen.dart';
import './widgets/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './screens/zeroscreen.dart';
import './screens/searchresultscreen.dart';
import './screens/loadingscreen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geocode/geocode.dart';

int ouserindex; // TO GET OTHER USERS ID FROM NEXUS LIST
List<dynamic> nexlist; //USERS NEXUS LIST
List<dynamic> prodlist; //USERS PRODUCT LIST
Coordinates loccoord; //USERS LOCATION COORDINATES
List<dynamic> usersList = [];
List<dynamic> searchlist;
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, appSnapshot) {
          return ChangeNotifierProvider(
              create: (context) => (UserData()),
              child: MaterialApp(
                  theme: ThemeData(
                      brightness: Brightness.light,
                      primaryColor: Colors.blue,
                      accentColor: Colors.blue[800],
                      textTheme: GoogleFonts.montserratTextTheme(
                      //GoogleFonts.fredokaOneTextTheme(
                          Theme.of(context).textTheme)),
                  home: appSnapshot.connectionState != ConnectionState.done
                      ? LoadingScreen()
                      : StreamBuilder(
                          stream: FirebaseAuth.instance.authStateChanges(),
                          builder: (ctx, userSnapshot) {
                            if (userSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return LoadingScreen();
                            }
                            if (userSnapshot.hasData) {
                              return Home();
                            }
                            return ZeroScreen();
                          }),
                  routes: {
                    ProfileScreen.routeName: (context) => ProfileScreen(),
                    NexusScreen.routeName: (context) => NexusScreen(),
                    OtherUserScreen.routeName: (context) => OtherUserScreen(),
                    SearchUserScreen.routeName: (context) => SearchUserScreen(),
                    ZeroScreen.routeName: (context) => ZeroScreen(),
                    SearchScreen.routeName: (context) => SearchScreen(),
                    Home.routeName: (context) => Home(),
                    SearchResultScreen.routeName: (context) =>
                        SearchResultScreen(),
                  }));
        });
  }
}
