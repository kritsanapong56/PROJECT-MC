import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alarm_safealert/ui/menu/ReportEatMedicine.dart';
import '../../tool/color.dart'; 
import '../../tool/pref.dart';
import '../../tool/url.dart';
import '../../ui/medicine/AddMedicine.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddProfile.dart';
import 'ListMedicine.dart';

class MenuList extends StatefulWidget {
  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  int _counter = 10;


  @override
  initState() {
    super.initState();
    // new Timer(const Duration(seconds: 0), onClose);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.bdColor,
      appBar:AppBar(
        centerTitle: true,
        backgroundColor: AppColors.colorMain,
        title: new Text("คุณต้องการเพิ่มอะไร?",style: TextStyle(
            fontSize: 25,color: Colors.white,
            fontFamily: 'SukhumvitSet-Bold'),),
        actions: [
          // IconButton(
          //   icon: Icon(
          //     Icons.clear,
          //     color: Colors.black,
          //     size: 40,
          //   ),
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          // ),
        ],
      ),
     body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        margin: EdgeInsets.only(top: 30.0),
        child: ListView(
            children: [
              InkWell(
                onTap: (){
                  _pushPageAddProfile(context,false);
                },
                child:
                Container(
                  padding: EdgeInsets.only(left: 20,right: 20,top:10),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage('assets/images/profile.png'),
                        height: 80,
                        width: 80,
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        flex: 5,
                        child:  Text(
                            "เพิ่มข้อมูลโปรไฟล์",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25.0,
                                fontFamily: 'SukhumvitSet-Bold'),
                            textAlign: TextAlign.start
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              InkWell(
                  onTap: (){
                    _pushPageReport(context,false);
                  },
                  child:
                  Container(
                        padding: EdgeInsets.only(left: 20,right: 20,top:10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image(
                              image: AssetImage('assets/images/report_medicine.png'),
                              height: 80,
                              width: 80,
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              flex: 5,
                              child:  Text(
                                  "รายงานการทานยา",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25.0,
                                      fontFamily: 'SukhumvitSet-Bold'),
                                  textAlign: TextAlign.start
                              ),
                            ),

                          ],
                        ),
                      ),
              ),

              // InkWell(
              //     onTap: (){
              //       _pushPageListMedicine(context,false);
              //     },
              //     child:  Container(
              //           padding: EdgeInsets.only(left: 20,right: 20,top:10),
              //           child:  Row(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: <Widget>[
              //               Image(
              //                 image: AssetImage('assets/images/info_medicine.png'),
              //                 height: 80,
              //                 width: 80,
              //               ),
              //               SizedBox(width: 10,),
              //               Expanded(
              //                 flex: 5,
              //                 child:  Text(
              //                     "ข้อมูลยา",
              //                     style: TextStyle(
              //                         color: Colors.black,
              //                         fontSize: 25.0,
              //                         fontFamily: 'SukhumvitSet-Bold'),
              //                     textAlign: TextAlign.start
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              // )
            ]),
      ),
    );
  }

  void _pushPageReport(BuildContext context, bool isHorizontalNavigation) {
    Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
      _buildAdaptivePageRoute(
        builder: (context) => ReportEatMedicine(),
        fullscreenDialog: !isHorizontalNavigation,
      ),
    ).then((value) {
      const Duration(seconds: 2);
      // ReloadData();
    });
  }
  void _pushPageListMedicine(BuildContext context, bool isHorizontalNavigation) {
    Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
      _buildAdaptivePageRoute(
        builder: (context) => ListMedicine(),
        fullscreenDialog: !isHorizontalNavigation,
      ),
    ).then((value) {
      const Duration(seconds: 2);
      // ReloadData();
    });
  }
  // void _pushPageAddMedicine(BuildContext context, bool isHorizontalNavigation) {
  //   Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
  //     _buildAdaptivePageRoute(
  //       builder: (context) => AddMedicine("",""),
  //       fullscreenDialog: !isHorizontalNavigation,
  //     ),
  //   ).then((value) {
  //     const Duration(seconds: 2);
  //     // ReloadData();
  //   });
  // }
  void _pushPageAddProfile(BuildContext context, bool isHorizontalNavigation) {
    Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
      _buildAdaptivePageRoute(
        builder: (context) => AddProfile(),
        fullscreenDialog: !isHorizontalNavigation,
      ),
    ).then((value) {
      const Duration(seconds: 2);
      // ReloadData();
    });
  }

// Flutter will use the fullscreenDialog property to change the animation
// and the app bar's left icon to an X instead of an arrow.
  PageRoute<T> _buildAdaptivePageRoute<T>({
    required WidgetBuilder builder,
    bool fullscreenDialog = false,
  }) =>
      Platform.isAndroid
          ? MaterialPageRoute(
        builder: builder,
        fullscreenDialog: fullscreenDialog,
      )
          : CupertinoPageRoute(
        builder: builder,
        fullscreenDialog: fullscreenDialog,
      );
}

