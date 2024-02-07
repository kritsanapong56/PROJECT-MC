import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/ModelTypeMedicine.dart';
import '../../tool/color.dart'; 
import '../../tool/loader.dart';
import '../../tool/url.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'LimitMedicinePerTime.dart';
class TypeMedicine extends StatefulWidget {
  TypeMedicine();
  @override
  _TypeMedicine createState() => _TypeMedicine();
}

class _TypeMedicine extends State<TypeMedicine> {
  var strEmpty = "";
  String typeMedicineId = "0";
  TextEditingController txtTypeMedicine = TextEditingController();

  int _selectedIndex = -1;
  List<ModelTypeMedicine> listTypeMedicine = [
    // ModelTypeMedicine(typeMedicineId: "1", typeMedicineName: 'ยาเม็ด', another: 'N'),
    // ModelTypeMedicine(typeMedicineId: "2", typeMedicineName: 'ยาน้ำ'),
    // ModelTypeMedicine(typeMedicineId: "3", typeMedicineName: 'ยาฉีด'),
    // ModelTypeMedicine(typeMedicineId: "4", typeMedicineName: 'ยาพ่น'),
    // ModelTypeMedicine(typeMedicineId: "5", typeMedicineName: 'อื่นๆ'),
  ];
  @override
  void initState() {
    loadDataTypeMedicine();
    super.initState();
  }
  void loadDataTypeMedicine() async {
    listTypeMedicine.clear();
    final list = await ModelTypeMedicine.getTypeMedicine();
    setState(() {
      listTypeMedicine = List<ModelTypeMedicine>.from(list?.map((i) => ModelTypeMedicine.fromMap(i)));
      if(listTypeMedicine.isEmpty){
        strEmpty = 'ไม่มีรายชื่อยา';
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
          backgroundColor: AppColors.colorMain,
          title: new Text("เลือกประเภทยา",style: TextStyle(
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
        margin: const EdgeInsets.only(top: 30.0,left: 20,right: 20),
        child: Expanded( // ส่วนของลิสรายการ
          child: listTypeMedicine.isNotEmpty // กำหนดเงื่อนไขตรงนี้
              ? ListView.separated( // กรณีมีรายการ แสดงปกติ
            itemCount: listTypeMedicine.length,
            itemBuilder: (context, index) {
              ModelTypeMedicine objType = listTypeMedicine[index];

              Widget card; // สร้างเป็นตัวแปร
              card = Card(
                margin: const EdgeInsets.only(left:10,right: 10,bottom: 20),
                color: AppColors.bgColor, // สี
                // shadowColor: Colors.red.withAlpha(100), // สีของเงา
                // elevation: 5.0, // การยกของเงา
                shape: RoundedRectangleBorder( // รูปแบบ
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  onTap: (){
                    if(listTypeMedicine.last.typeMedicineId == listTypeMedicine[index].typeMedicineId){
                      typeMedicineId = listTypeMedicine.last.typeMedicineId;
                      _showSheet();
                    }else{
                      Navigator.pop(context);
                      _pushPageLimitMedicinePerTime(context,false);
                    }

                    AppUrl.objAddItemMedicine.typeMedicineId = listTypeMedicine[index].typeMedicineId;
                    AppUrl.objAddItemMedicine.typeMedicineName = txtTypeMedicine.text;
                  },
                  child: ListTile(
                    title: Text(objType.typeMedicineName,
                      style: const TextStyle(
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
              style: const TextStyle(
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
          margin: const EdgeInsets.only(top: 50),
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
              if(txtTypeMedicine.text != "") {
                _pushPageLimitMedicinePerTime(context,false);
              }else{
                AppLoader.showError("กรุณากรอกประเภทยาที่ต้องการ");
              }

              AppUrl.objAddItemMedicine.typeMedicineId = typeMedicineId;
              AppUrl.objAddItemMedicine.typeMedicineName = txtTypeMedicine.text;
              txtTypeMedicine.text = "";
            },
            child: Container(
              width: 120,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(5),
              child: const Text(
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
                margin: const EdgeInsets.only(top: 20,left: 10,right: 10),
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                width: double.maxFinite,
                child: TextField(
                  controller: txtTypeMedicine,
                  enabled: true,
                  style: const TextStyle(
                      fontSize: 25.0,
                      fontFamily: 'SukhumvitSet-Bold',
                      color: Colors.black),
                  decoration: InputDecoration(
                    hintMaxLines: 3,
                      contentPadding:
                      const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15),
                      //ปรับตำแหน่งcursor เริ่มต้นในช่องข้อความ
                      border: const OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(
                          Radius.circular(20.0),
                          ),
                          borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none)),
                      filled: true,
                      hintText: "กรุณากรอกประเภทยาที่ต้องการ",
                      hintStyle: TextStyle(
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

void _pushPageLimitMedicinePerTime(BuildContext context, bool isHorizontalNavigation) {
  Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
    _buildAdaptivePageRoute(
      builder: (context) => LimitMedicinePerTime(),
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
