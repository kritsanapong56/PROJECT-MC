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

import 'AllAmountMedicine.dart';
import 'PeriodMedicine.dart';
class LimitMedicinePerTime extends StatefulWidget {
  LimitMedicinePerTime();
  @override
  _LimitMedicinePerTime createState() => _LimitMedicinePerTime();
}

class _LimitMedicinePerTime extends State<LimitMedicinePerTime> {
  bool _errorSelectZero = false;
  double _kItemExtent = 32.0;
  var _selectedNum = 1;
  var _selectedWeightDecimals = 0;
  var _selectedUnits = 'เม็ด';
  var units = ['ออนซ์', 'เม็ด','ช้อนชา','ช้อนโต๊ะ'];
  var num = [];
  TextEditingController txtMedicine = TextEditingController();

  @override
  void initState() {
    for (int j = 1; j <= 10; j++) {
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
          title: new Text("ปริมาณการใช้ยาต่อครั้ง",style: TextStyle(
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
                      "ปริมาณการใช้ยาต่อครั้ง",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'SukhumvitSet-Bold'
                      ),
                    ),
                  ),
                  Expanded(
                    child: const Text(
                      "ปริมาณยา",
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
                    AppUrl.objAddItemMedicine.amountPerMedicine = _selectedNum.toString();
                    AppUrl.objAddItemMedicine.unitSubMedicineId = "2";
                    AppUrl.objAddItemMedicine.unitSubMedicineName = _selectedUnits;
                    _pushPageAllAmountMedicine(context,false);
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
void _pushPageAllAmountMedicine(BuildContext context, bool isHorizontalNavigation) {
  Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
    _buildAdaptivePageRoute(
      builder: (context) => AllAmountMedicine(),
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
