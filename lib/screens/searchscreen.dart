import 'package:Nexus/main.dart';
import '../screens/searchresultscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/adduserdata.dart';
import '../widgets/searchfilter.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    SearchFilter sf = SearchFilter();
    var _currentSliderValue = 0.0;
    String role = 'Select Role';
    print(role);
    final searchfor = TextEditingController();
    final city = TextEditingController();
    final product = TextEditingController();
    final deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          body: Container(
              padding: EdgeInsets.all(8),
              height: deviceSize.height * 0.12,
              child: Card(
                elevation: 3,
                //  shadowColor: Colors.green[900],
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(deviceSize.height * 0.18)),
                // color: Colors.green[50],
                child: Row(children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      searchlist = [];
                      await sf.searchname(searchfor.text);
                      //   Navigator.pop(context);
                      Navigator.of(context)
                          .pushNamed(SearchResultScreen.routeName);
                    },
                    child: Icon(
                      Icons.search,
                      color: Colors.blue[900],
                    ),
                  ),
                  Container(
                      width: deviceSize.width * 0.5,
                      child: TextFormField(
                        controller: searchfor,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Search';
                          }
                          return searchfor.text;
                        },
                      )),
                  FlatButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) =>
                              StatefulBuilder(builder: (context, setState) {
                                return AlertDialog(
                                  content: Container(
                                      child: SingleChildScrollView(
                                    child: Column(children: <Widget>[
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Container(
                                            padding: EdgeInsets.all(
                                                deviceSize.height * 0.014),
                                            height: deviceSize.height * 0.1,
                                            width: deviceSize.width -
                                                deviceSize.height * 0.25,
                                            child: Card(
                                                color: Colors.blue[900],
                                                elevation: 0,
                                                shadowColor: Colors.blue[900],
                                                // shape: RoundedRectangleBorder(
                                                //   borderRadius: BorderRadius.circular(
                                                //     deviceSize.height * 0.18)),
                                                child: Padding(
                                                  padding: role !=
                                                          'Raw Material Supplier'
                                                      ? EdgeInsets.only(
                                                          left: (deviceSize
                                                                      .width -
                                                                  deviceSize
                                                                          .height *
                                                                      0.25) *
                                                              0.25)
                                                      : EdgeInsets.only(
                                                          left: (deviceSize
                                                                      .width -
                                                                  deviceSize
                                                                          .height *
                                                                      0.25) *
                                                              0.1),
                                                  child: Container(
                                                      width: deviceSize.width -
                                                          deviceSize.height *
                                                              0.25,
                                                      child:
                                                          SingleChildScrollView(
                                                              scrollDirection:
                                                                  Axis
                                                                      .horizontal,
                                                              child:
                                                                  DropdownButton<
                                                                      String>(
                                                                value: role,
                                                                elevation: 0,
                                                                underline:
                                                                    Container(
                                                                  color: Colors
                                                                          .blue[
                                                                      900],
                                                                  height: 0,
                                                                ),
                                                                dropdownColor:
                                                                    Colors.blue[
                                                                        900],
                                                                iconEnabledColor:
                                                                    Colors.blue[
                                                                        900],
                                                                iconDisabledColor:
                                                                    Colors.blue[
                                                                        900],
                                                                onChanged:
                                                                    (String
                                                                        value) {
                                                                  if (mounted) {
                                                                    setState(
                                                                        () {
                                                                      role =
                                                                          value;
                                                                      print(
                                                                          role);
                                                                    });
                                                                  }
                                                                },
                                                                items: <String>[
                                                                  'Raw Material Supplier',
                                                                  'Manufacturer',
                                                                  'Distributor',
                                                                  'Wholesalers',
                                                                  'Retailers',
                                                                  'Transportation',
                                                                  'Select Role'
                                                                ].map<
                                                                    DropdownMenuItem<
                                                                        String>>((String
                                                                    value) {
                                                                  return DropdownMenuItem<
                                                                      String>(
                                                                    value:
                                                                        value,
                                                                    child: Consumer<
                                                                            UserData>(
                                                                        builder: (context,
                                                                                role,
                                                                                child) =>
                                                                            Center(
                                                                              child: Text(value, style: TextStyle(color: Colors.white)),
                                                                            )),
                                                                  );
                                                                }).toList(),
                                                              ))),
                                                ))),
                                      ),
                                      Container(
                                          padding: EdgeInsets.all(
                                              deviceSize.height * 0.014),
                                          height: deviceSize.height * 0.1,
                                          width: deviceSize.width -
                                              deviceSize.height * 0.25,
                                          child: TextField(
                                              decoration: InputDecoration(
                                                  labelText: 'City'),
                                              controller: city)),
                                      Container(
                                          padding: EdgeInsets.all(
                                              deviceSize.height * 0.014),
                                          height: deviceSize.height * 0.1,
                                          width: deviceSize.width -
                                              deviceSize.height * 0.25,
                                          child: TextField(
                                              decoration: InputDecoration(
                                                  labelText: 'Product'),
                                              controller: product)),
                                      Padding(
                                        padding: EdgeInsets.all(15),
                                      ),
                                      Center(
                                        child: Text(
                                            'Select the range to search in :'),
                                      ),
                                      Slider(
                                        value: _currentSliderValue,
                                        min: 0,
                                        max: 1000,
                                        divisions: 10,
                                        activeColor: Colors.blue[900],
                                        inactiveColor: Colors.blue[500],
                                        label: _currentSliderValue
                                                .round()
                                                .toString() +
                                            ' km',
                                        onChanged: (double value) {
                                          setState(() {
                                            _currentSliderValue = value;
                                          });
                                        },
                                      )
                                    ]),
                                  )),
                                  actions: <Widget>[
                                    Center(
                                        child: FlatButton(
                                      child: Text('Search'),
                                      textColor: Colors.blue[900],
                                      onPressed: () async {
                                        searchlist = [];
                                        print(city.text);
                                        sf.fcity = city.text;
                                        sf.fproduct = product.text;
                                        sf.frole = role;
                                        sf.frange = _currentSliderValue;
                                        await sf.sfiltering(sf);
                                        print('after f $searchlist');
                                        Navigator.pop(context);
                                        Navigator.of(context).pushNamed(
                                            SearchResultScreen.routeName);
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
                    child: Icon(
                      Icons.filter_alt_rounded,
                      color: Colors.blue[900],
                    ),
                  )
                ]),
              ))),
    );
  }
}
