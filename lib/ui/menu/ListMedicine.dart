import 'dart:convert';
import 'dart:io';
import 'dart:io';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alarm_safealert/model/ModelDetailMedicine.dart';
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
import '../medicine/AddMedicine.dart';
class ListMedicine extends StatefulWidget {
  ListMedicine();
  @override
  _ListMedicine createState() => _ListMedicine();
}

class _ListMedicine extends State<ListMedicine> {

  int _counter = 0;
  var fDate = new DateFormat('yyyy-MM-dd');

  TextEditingController txtMedicine = TextEditingController();
  Map<String, List<ModelMedicineAlarmNext>> resultAlarmMedicine = {};
  List<ModelDetailMedicine> listDetailMedicine = [];
  List<ModelAlarmMedicine> listAlarmMedicine = [];
  List<ModelMedicine> listMedicine = [
    ModelMedicine(id: 1, name: 'ยาลดไข้',dateTime: DateTime.now(),messageDateTime: "แจ้งเตือนครั้งต่อไป วันพรุ่งนี้เวลา 19.00 น."),
  ];
  var strEmpty = "";
  @override
  void initState() {
    loadDataMedicineAll();
    super.initState();
  }
  void loadDataMedicineAll() async {
    AppLoader.show();
    listDetailMedicine.clear();
    final list = await ModelDetailMedicine.getMedicineAll();
    setState(() {
      listDetailMedicine = List<ModelDetailMedicine>.from(list?.map((i) => ModelDetailMedicine.fromMap(i)));
      if(listDetailMedicine.isEmpty){
        strEmpty = 'ไม่มีรายชื่อยา';
      }
      AppLoader.hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.bdColor,
      appBar:AppBar(
        centerTitle: true,
        leadingWidth: 0,
        title: Text('ข้อมูลยา',
            style: TextStyle(fontFamily: 'SukhumvitSet-Bold',
                fontSize: 22,fontWeight: FontWeight.w500
            )
        ),
        leading: Container(),
        actions: [
          IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.black,
              size: 40,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Expanded( // ส่วนของลิสรายการ
          child: listDetailMedicine.length > 0 // กำหนดเงื่อนไขตรงนี้
              ? ListView.separated( // กรณีมีรายการ แสดงปกติ
            itemCount: listDetailMedicine.length,
            itemBuilder: (context, index) {
              ModelDetailMedicine objType = listDetailMedicine[index];

              Widget card; // สร้างเป็นตัวแปร
              card = Card(
                  margin: EdgeInsets.only(
                      left: 10, right: 10, bottom: 5),
                  color: Colors.white,
                  // สี
                  // shadowColor: Colors.red.withAlpha(100), // สีของเงา
                  // elevation: 5.0, // การยกของเงา
                  shape: RoundedRectangleBorder( // รูปแบบ
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading: objType.img_medicine.isNotEmpty ?
                      Image.network(objType.img_medicine) :
                      ImageIcon(
                        AssetImage("assets/images/pills.png"),
                        size: 40,
                        color: Colors.black,),
                      title: Text(
                        "${objType.medicine_name}\n${objType.amount_unit_sub} ${objType.unit_sub_name}",
                        style: TextStyle(
                            fontSize: 22.0,
                            fontFamily: 'SukhumvitSet-Medium',
                            color: Colors.black),),
                      // subtitle: Text(
                      //   objType.time_take_name,
                      //   style: TextStyle(
                      //       fontSize: 16.0,
                      //       fontFamily: 'SukhumvitSet-Medium',
                      //       color: Colors.black),),
                    ),
                  )
              );
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

  void _pushPageAddMedicine(BuildContext context, bool isHorizontalNavigation,String medicine_id,String medicine_name) {
    Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
      _buildAdaptivePageRoute(
        builder: (context) => AddMedicine(medicine_id,medicine_name),
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
