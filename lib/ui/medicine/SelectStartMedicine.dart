import 'dart:convert';
import 'dart:io';
import 'dart:io';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../../tool/color.dart'; 
import '../../tool/url.dart';
import '../../ui/medicine/TimeDayMedicine.dart';
import '../../widget/CustomCupertinoDatePicker.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as Io;
import 'package:bottom_sheet/bottom_sheet.dart';

import 'AllAmountMedicine.dart';
import 'PeriodMedicine.dart';
class SelectStartMedicine extends StatefulWidget {
  SelectStartMedicine();
  @override
  _SelectStartMedicine createState() => _SelectStartMedicine();
}

class _SelectStartMedicine extends State<SelectStartMedicine> {
  bool _errorSelectZero = false;
  double _kItemExtent = 32.0;
  var _selectedNum = 150;
  var _selectedWeightDecimals = 0;
  var _selectedUnits = 'lbs';
  var units = ['มิลลิลิตร', 'เม็ด','แคปซูล','หลอด'];
  var num = [];
  TextEditingController txtMedicine = TextEditingController();

  late final DateTime _minDate;
  late final DateTime _maxDate;
  late final DateTime _currentDate;
  late DateTime _selecteDate;
  @override
  void initState() {
    super.initState();
    for (int j = 0; j <= 1000; j++) {
      num.add(j);
    }
    final currentDate = DateTime.now();
    _minDate = DateTime(
      currentDate.year - 100,
      currentDate.month,
      currentDate.day,
    );
    _maxDate = DateTime(
      currentDate.year+100,
      currentDate.month+100,
      currentDate.day+100,
    );
    _currentDate = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
    );
    _selecteDate = _currentDate;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
          backgroundColor: AppColors.colorMain,
          title: new Text("เลือกวันที่เริ่มทาน",style: const TextStyle(
            fontSize: 25,color: Colors.black,
              fontFamily: 'SukhumvitSet-Bold'),),
          leading: IconButton(
            icon: const ImageIcon(
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
        margin: const EdgeInsets.only(top: 50.0,left: 20,right: 20),
        child: Column(
          children: [
            Container(
              color: AppColors.colorBlueLight,
              padding: const EdgeInsets.only(left: 5,right: 5,top: 15,bottom: 15),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "เลือกวันที่เริ่มทานยา",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'SukhumvitSet-Bold'
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "ตกลง",
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
                    child:
                    SizedBox(
                      height: 150,
                      child: CustomCupertinoDatePicker(
                        itemExtent: 50,
                        minDate: _minDate,
                        maxDate: _maxDate,
                        selectedDate: _selecteDate,
                        // selectionOverlay: Container(
                        //   width: double.infinity,
                        //   height: 50,
                        //   decoration: const BoxDecoration(
                        //     border: Border.symmetric(
                        //       horizontal:BorderSide(color:Colors.grey,width:1),
                        //     ),
                        //   ),
                        // ),
                        selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(capStartEdge: false, capEndEdge: false),
                        selectedStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          fontFamily: 'SukhumvitSet-Bold',
                        ),
                        unselectedStyle: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 18,
                          fontFamily: 'SukhumvitSet-Bold',
                        ),
                        disabledStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 18,
                        ),
                        onSelectedItemChanged: (date) => _selecteDate = date,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 60,
        margin: const EdgeInsets.all(20),
        child:  Row(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.only(right: 5),
                width: double.maxFinite,
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),),
                    shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), )),
                    backgroundColor: MaterialStateProperty.resolveWith((states) => AppColors.colorMain),
                    elevation: MaterialStateProperty.resolveWith<double>(
                          (Set<MaterialState> states) {
                        return 2.0;
                      },),
                  ),
                  onPressed: () {
                    // Navigator.push(context,
                    //     CupertinoPageRoute(builder: (context) {
                    //       return MainMenu();
                    //     }));
                    if(txtMedicine.text != "") {

                    }else{
                      Navigator.pop(context);
                    }
                  },
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Container(
                        child: const Text(
                          "ย้อนกลับ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontFamily:
                              'SukhumvitSet-Bold'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.only(left: 5),
                width: double.maxFinite,
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),),
                    shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), )),
                    backgroundColor: MaterialStateProperty.resolveWith((states) => AppColors.colorMain),
                    elevation: MaterialStateProperty.resolveWith<double>(
                          (Set<MaterialState> states) {
                        return 2.0;
                      },),
                  ),
                  onPressed: () {
                    String datetimeMedicine =
                        DateFormat('yyyy-MM-dd')
                            .format(_selecteDate);
                    AppUrl.objAddItemMedicine.startDateMedicine = datetimeMedicine;
                    _pushPageTimeDayMedicine(context,false);
                  },
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Container(
                        child: const Text(
                          "ถัดไป",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontFamily:
                              'SukhumvitSet-Bold'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
void _pushPageTimeDayMedicine(BuildContext context, bool isHorizontalNavigation) {
  Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
    _buildAdaptivePageRoute(
      builder: (context) => TimeDayMedicine(),
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
