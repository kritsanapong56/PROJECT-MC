import 'dart:convert';
import 'dart:io';
import 'dart:io';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../tool/color.dart'; 
import '../../tool/loader.dart';
import '../../tool/screen.dart';
import '../../tool/url.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as Io;
import 'package:bottom_sheet/bottom_sheet.dart';

import 'PeriodMedicine.dart';
class AllAmountMedicine extends StatefulWidget {
  AllAmountMedicine();
  @override
  _AllAmountMedicine createState() => _AllAmountMedicine();
}

class _AllAmountMedicine extends State<AllAmountMedicine> {
  var strEmpty = "";
  bool _errorSelectZero = false;
  double _kItemExtent = 32.0;
  var _selectedNum = 1;
  var _selectedWeightDecimals = 0;
  var _selectedUnits = 'lbs';
  var units = ['มิลลิลิตร', 'เม็ด','แคปซูล','หลอด'];
  var num = [];
  TextEditingController txtMedicine = TextEditingController();

  @override
  void initState() {
    for (int j = 10; j <= 300; j += 10) {
      num.add(j);
      
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
          backgroundColor: AppColors.colorMain,
          title: new Text("จำนวนยาทั้งหมด",style: TextStyle(
            fontSize: 25,color: Colors.black,
              fontFamily: 'SukhumvitSet-Bold'),),
          leading: IconButton(
            icon: ImageIcon(
                AssetImage("assets/images/arrow_left.png"),
                  size:40,
                  color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
      ),
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        margin: EdgeInsets.only(top: 50.0,left: 20,right: 20),
        child: Column(
          children: [
            Container(
              color: AppColors.colorBlueLight,
              padding: EdgeInsets.only(left: 5,right: 5,top: 15,bottom: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: const Text(
                      "จำนวนยาทั้งหมด",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'SukhumvitSet-Bold'
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 150,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 45,
                      onSelectedItemChanged: (int index) {
                        setState(
                              () {
                            _selectedNum = num[index];
                            _errorSelectZero = false;
                          },
                        );
                      },
                      selectionOverlay: CupertinoPickerDefaultSelectionOverlay(capEndEdge: false, capStartEdge: false),
                      scrollController: FixedExtentScrollController(
                        initialItem: 0,
                      ),
                      children: List<Widget>.generate(
                        num.length,
                            (int index) {
                          return Center(
                            child: Text(num[index].toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'SukhumvitSet-Bold'
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 45,
                      onSelectedItemChanged: (int index) {
                        setState(() {
                            _selectedUnits = units[index];
                          },
                        );
                      },
                      selectionOverlay: CupertinoPickerDefaultSelectionOverlay(capEndEdge: false, capStartEdge: false),
                      scrollController: FixedExtentScrollController(
                        initialItem: 1,
                      ),
                      children: List<Widget>.generate(
                        units.length,
                            (int index) {
                          return Center(
                            child: Text(units[index],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'SukhumvitSet-Bold'
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _errorSelectZero ?
            const Text("กรุณาเลือกจำนวนยา",
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                  fontFamily: 'SukhumvitSet-Bold'
              ),
            ) : Container(),
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(top: 40),
              child: TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),),
                ),
                onPressed: () {
                  if(_selectedNum > 0) {
                    AppUrl.objAddItemMedicine.amountPerMedicineAll = _selectedNum.toString();
                    AppUrl.objAddItemMedicine.unitMedicineAllId = "2";
                    AppUrl.objAddItemMedicine.unitMedicineAllName = _selectedUnits;
                    _pushPagePeriodMedicine(context,false);
                  }else{
                    setState(() {
                      _errorSelectZero = true;
                    });
                  }
                },
                child: Container(
                  width: 120,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "ตกลง",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontFamily:
                        'SukhumvitSet-Bold'),
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
  void _showSheet() {
    showFlexibleBottomSheet<void>(
      minHeight: 0,
      initHeight: 0.4,
      maxHeight: 0.6,
      context: context,
      builder: _buildBottomSheet,
      anchors: [0, 0.4, 0.6],
    );
  }

  List<Widget> _getChildren(
      double bottomSheetOffset, {
        required bool isShowPosition,
      }) =>
      [
        Container(
          alignment: FractionalOffset.topRight,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.clear),
          ),
        ),
        _buildTextField(),

        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(top: 50),
          child: ElevatedButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),),
              shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0), )),
              backgroundColor: MaterialStateProperty.resolveWith((states) => AppColors.colorMain),
              elevation: MaterialStateProperty.resolveWith<double>(
                    (Set<MaterialState> states) {
                  return 2.0;
                },),
            ),
            onPressed: () {
              if(txtMedicine.text != "") {

              }else{
                Navigator.pop(context);
              }
            },
            child: Container(
              width: 120,
              alignment: Alignment.center,
              padding: EdgeInsets.all(5),
              child: Text(
                "ตกลง",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily:
                    'SukhumvitSet-Bold'),
              ),
            ),
          ),
        ),
      ];


  Widget _buildBottomSheet(
      BuildContext context,
      ScrollController scrollController,
      double bottomSheetOffset,
      ) {
    return SafeArea(
      child: Material(
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: ListView(
              padding: const EdgeInsets.all(0),
              controller: scrollController,
              children: _getChildren(bottomSheetOffset, isShowPosition: true)),
        ),
      ),
    );
  }

  Widget _buildTextField() =>
  Container(
    child: Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          flex: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                width: double.maxFinite,
                child: TextField(
                  controller: txtMedicine,
                  enabled: true,
                  style: TextStyle(
                      fontSize: 25.0,
                      fontFamily: 'SukhumvitSet-Bold',
                      color: Colors.black),
                  decoration: new InputDecoration(
                    hintMaxLines: 3,
                      contentPadding:
                      const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15),
                      //ปรับตำแหน่งcursor เริ่มต้นในช่องข้อความ
                      border: new OutlineInputBorder(
                          borderRadius:
                          const BorderRadius.all(
                            const Radius.circular(20.0),
                          ),
                          borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none)),
                      filled: true,
                      hintText: "กรุณากรอกประเภทยาที่ต้องการ",
                      hintStyle: new TextStyle(
                          fontFamily: 'SukhumvitSet-Medium',
                          color: Colors.grey[800]),
                      fillColor:AppColors.bgColor),
                  // fillColor: Colors.white70),
                ),
              ),

            ],
          ),
        )
      ],
    ),
  );

void _pushPagePeriodMedicine(BuildContext context, bool isHorizontalNavigation) {
  Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
    _buildAdaptivePageRoute(
      builder: (context) => PeriodMedicine(),
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
