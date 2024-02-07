
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/ModelDayMedicine.dart';
import '../../tool/color.dart'; 
import '../../tool/url.dart';
import 'dart:io' as Io;
import 'package:bottom_sheet/bottom_sheet.dart';
import 'AddTimeAlertMedicine.dart';

class TimeDayMedicine extends StatefulWidget {
  TimeDayMedicine();
  @override
  _TimeDayMedicine createState() => _TimeDayMedicine();
}

class _TimeDayMedicine extends State<TimeDayMedicine> {
  var strEmpty = '';
  TextEditingController txtMedicine = TextEditingController();

  List<ModelDayMedicine> listTimeDay = [
    // ModelDayMedicine(timeDayId: "1", timeDayName: '1 ครั้ง/วัน'),
    // ModelDayMedicine(timeDayId: "2", timeDayName: '2 ครั้ง/วัน'),
    // ModelDayMedicine(timeDayId: "3", timeDayName: '3 ครั้ง/วัน'),
    // ModelDayMedicine(timeDayId: "4", timeDayName: 'มากกว่า 3 ครั้ง/วัน'),
  ];
  @override
  void initState() {
    loadDataTimeDay();
    super.initState();
  }

  void loadDataTimeDay() async {
    listTimeDay.clear();
    final list = await ModelDayMedicine.getTimeDay();
    setState(() {
      list.forEach((v) {
        listTimeDay = List<ModelDayMedicine>.from(list?.map((i) => ModelDayMedicine.fromMap(i)));
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
          backgroundColor: AppColors.colorMain,
          title: new Text("ระยะเวลาในการทานยา",style: TextStyle(
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
        margin: EdgeInsets.only(top: 30.0,left: 20,right: 20),
        child: Expanded( // ส่วนของลิสรายการ
          child: listTimeDay.length > 0 // กำหนดเงื่อนไขตรงนี้
              ? ListView.separated( // กรณีมีรายการ แสดงปกติ
            itemCount: listTimeDay.length,
            itemBuilder: (context, index) {
              ModelDayMedicine objType = listTimeDay[index];

              Widget card; // สร้างเป็นตัวแปร
              card = Card(
                margin: EdgeInsets.only(left:10,right: 10,bottom: 20),
                color: AppColors.bgColor, // สี
                // shadowColor: Colors.red.withAlpha(100), // สีของเงา
                // elevation: 5.0, // การยกของเงา
                shape: RoundedRectangleBorder( // รูปแบบ
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  onTap: (){
                    AppUrl.objAddItemMedicine.timeDayId = listTimeDay[index].timeDayId;
                    _pushPageAddTimeAlert(context,false,listTimeDay[index].timeDayId);
                  },
                  child: ListTile(
                    title: Text(objType.timeDayName,
                      style: TextStyle(
                          fontSize: 25.0,
                          fontFamily: 'SukhumvitSet-Medium',
                          color: Colors.black),),
                  ),
                )
              );
              return card;
            },
            separatorBuilder: (BuildContext context, int index) => const SizedBox(),
          )
              :   Center(child: Text(strEmpty,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'SukhumvitSet-Bold'),
              textAlign: TextAlign.center),)
        ),
      ),
    );
  }
  void _showSheet() {
    showFlexibleBottomSheet<void>(
      minHeight: 0,
      initHeight: 0.5,
      maxHeight: 1,
      context: context,
      builder: _buildBottomSheet,
      anchors: [0, 0.5, 1],
    );
  }

  List<Widget> _getChildren(
      double bottomSheetOffset, {
        required bool isShowPosition,
      }) =>
      [
        _buildTextField(),
      ];

  Widget _testContainer(Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        color: color,
      ),
    );
  }

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

  Widget _buildTextField() => const TextField(
    decoration: InputDecoration(
      border: InputBorder.none,
      hintText: 'Enter a search term',
    ),
  );

  void _pushPageAddTimeAlert(BuildContext context, bool isHorizontalNavigation, String timeLineId) {
    Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
      _buildAdaptivePageRoute(
        builder: (context) => AddTimeAlertMedicine(timeLineId),
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
