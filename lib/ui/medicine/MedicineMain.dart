import 'dart:convert';
import 'dart:io';
import 'dart:io';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../model/ModelAlarmMedicine.dart';
import '../../model/ModelMedicine.dart';
import '../../model/ModelMedicineAlarmNext.dart';
import '../../model/ModelRegister.dart';
import '../../tool/color.dart';
import '../../tool/loader.dart';
import '../../tool/screen.dart';
import '../../tool/url.dart';
import '../../ui/medicine/DetailMedicine.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as Io;
import 'package:bottom_sheet/bottom_sheet.dart';

import '../MainMenu.dart';
import 'AddMedicine.dart';
import 'TimeDayMedicine.dart';
class MedicineMain extends StatefulWidget {
  MedicineMain();
  @override
  _MedicineMain createState() => _MedicineMain();
}

class _MedicineMain extends State<MedicineMain> {

  int _counter = 0;
  var fDate = new DateFormat('yyyy-MM-dd');

  TextEditingController txtMedicine = TextEditingController();
  Map<String, List<ModelMedicineAlarmNext>> resultAlarmMedicine = {};
  List<ModelMedicineAlarmNext> listAlarmMedicineNext = [];
  List<ModelAlarmMedicine> listAlarmMedicine = [];
  List<ModelMedicine> listMedicine = [
    ModelMedicine(id: 1, name: 'ยาลดไข้',dateTime: DateTime.now(),messageDateTime: "แจ้งเตือนครั้งต่อไป วันพรุ่งนี้เวลา 19.00 น."),
  ];
  var strEmpty = "";
  @override
  void initState() {
    loadDataMedicineAlarmNext();
    loadDataMedicineToDay(selectedDate);
    loadDataRegister();
    super.initState();
  }
  void loadDataMedicineAlarmNext() async {
    AppLoader.show();
    listAlarmMedicineNext.clear();
    final list = await ModelMedicineAlarmNext.getMedicineAlarmNext();
    setState(() {
      listAlarmMedicineNext = List<ModelMedicineAlarmNext>.from(list?.map((i) => ModelMedicineAlarmNext.fromMap(i)));
      if(listAlarmMedicineNext.isEmpty){
        strEmpty = 'ไม่มีรายชื่อยา';
      }
      AppLoader.hide();
    });
  }

  void loadDataMedicineToDay(selectedDate) async {
    listAlarmMedicine.clear();
    final list = await ModelAlarmMedicine.getMedicineToDay(selectedDate);
    setState(() {
      listAlarmMedicine = List<ModelAlarmMedicine>.from(list?.map((i) => ModelAlarmMedicine.fromMap(i)));
      _counter = listAlarmMedicine.length;
    });
  }
  void loadDataRegister() async {
    final list = await ModelRegister.getData();
    setState((){
      AppUrl.objRegister = ModelRegister.fromJson(list);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.bdColor,
      appBar: AppBar(
        backgroundColor: AppColors.colorMain,
        title: new Text(AppUrl.objRegister.name.toString().isNotEmpty ? AppUrl.objRegister.name : "กรุณาเพิ่ม ชื่อ - นามสุกล",style: TextStyle(
            fontFamily: 'SukhumvitSet-Bold'),),
        leading: new Padding(
            padding: const EdgeInsets.all(8.0),
            child:  AppUrl.objRegister.img_profile.toString().isNotEmpty ?
            Image.network(AppUrl.objRegister.img_profile) :
            Image.asset("assets/images/profile.png")
        ),
        actions: [
          Container(
            width: 40,
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ImageIcon(
                      AssetImage("assets/images/notification.png"),
                      size:30,
                      color: Colors.black,
                    ),
                  ],
                ),
                _counter != 0 ? new Positioned(
                  right: 2,
                  top: 10,
                  child: new Container(
                    padding: EdgeInsets.all(2),
                    decoration: new BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      '$_counter',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ) : new Container()
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              tooltip: 'add',
              icon: const Icon(
                Icons.add,
                color: Colors.black,
                size: 40,
              ),
              onPressed: () {
                _pushPageAddMedicine(context, false);
              },
            ),
          )
        ],
      ) ,
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Expanded( // ส่วนของลิสรายการ
          child: listAlarmMedicineNext.length > 0 // กำหนดเงื่อนไขตรงนี้
              ? ListView.separated( // กรณีมีรายการ แสดงปกติ
            itemCount: listAlarmMedicineNext.length,
            itemBuilder: (context, index) {
              ModelMedicineAlarmNext objType = listAlarmMedicineNext[index];

              Widget card; // สร้างเป็นตัวแปร
              card =
                  Column(
                    children: [
                      index == 0 ?
                  Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.centerLeft,
                  child: Text("รายการยา",style: TextStyle(
                      fontFamily: 'SukhumvitSet-Bold',
                      fontSize: 20),textAlign: TextAlign.start,),
              ) : Container(),
                  Card(
                  margin: EdgeInsets.only(left:10,right: 10,bottom: 20),
                  color: Colors.white, // สี
                  // shadowColor: Colors.red.withAlpha(100), // สีของเงา
                  // elevation: 5.0, // การยกของเงา
                  shape: RoundedRectangleBorder( // รูปแบบ
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: (){
                      _pushPageDetailMedicine(context,false,objType);
                    },
                    child: ListTile(
                      trailing:Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 40,
                      ),
                      title: Text(objType.medicine_name,
                        style: TextStyle(
                            fontSize: 22.0,
                            fontFamily: 'SukhumvitSet-Medium',
                            color: Colors.black),),
                      subtitle: Text(objType.msg_alarm,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontFamily: 'SukhumvitSet-Medium',
                            color: Colors.grey),),
                    ),
                  )
              )]);
              return card;
            },
            separatorBuilder: (BuildContext context, int index) => const SizedBox(),
          )
              : Center(child: Text(strEmpty,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'SukhumvitSet-Bold'),
              textAlign: TextAlign.center),), // กรณีไม่มีรายการ
        ),
      ),
    );
  }

  void _pushPageAddMedicine(BuildContext context, bool isHorizontalNavigation) {
    Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
      _buildAdaptivePageRoute(
        builder: (context) => AddMedicine("",""),
        fullscreenDialog: !isHorizontalNavigation,
      ),
    ).then((value) {
      const Duration(seconds: 2);
      // ReloadData();
    });
  }
  void _pushPageDetailMedicine(BuildContext context, bool isHorizontalNavigation,ModelMedicineAlarmNext medicine) {
    Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
      _buildAdaptivePageRoute(
        builder: (context) => DetailMedicine(medicine),
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
