import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alarm_safealert/ui/medicine/Frequency.dart';
import '../../model/ModelTimeTakeMedicine.dart';
import '../../tool/color.dart'; 

import '../../tool/screen.dart';
import '../../tool/url.dart';


class AddMedicine extends StatefulWidget {
  final medicine_id;
  final medicine_name;
  AddMedicine(this.medicine_id,this.medicine_name);
  @override
  _AddMedicine createState() => _AddMedicine();
}

class _AddMedicine extends State<AddMedicine> {


  TextEditingController txtMedicine = TextEditingController();

  int _selectedIndex = -1;
  var _selectedTimeTakeId = "0";
  // List<String> _options = ['ก่อนอาหาร', 'หลังอาหาร', 'ทานพร้อมอาหาร','ทานตามอาการ'];
  List<ModelTimeTakeMedicine> listTimeTake = [
    // ModelTimeTakeMedicine(timeTakeId: "1", timeTakeName: 'ก่อนอาหาร'),
    // ModelTimeTakeMedicine(timeTakeId: "2", timeTakeName: 'หลังอาหาร'),
    // ModelTimeTakeMedicine(timeTakeId: "3", timeTakeName: 'ทานพร้อมอาหาร'),
    // ModelTimeTakeMedicine(timeTakeId: "4", timeTakeName: 'ทานตามอาการ'),
  ];
  @override
  void initState() {
    if(widget.medicine_id.toString().isNotEmpty){
      AppUrl.objAddItemMedicine.medicineId = widget.medicine_id;
    }
    if(widget.medicine_name.toString().isNotEmpty){
      txtMedicine.text = widget.medicine_name;
    }
    // loadDataTimeTake();
    super.initState(); 
  }
  // void loadDataTimeTake() async {
  //   listTimeTake.clear();
  //   final list = await ModelTimeTakeMedicine.getTimeTake();
  //   setState(() {
  //     list.forEach((v) {
  //       listTimeTake = List<ModelTimeTakeMedicine>.from(list?.map((i) => ModelTimeTakeMedicine.fromJson(i)));
  //     });
  //   });
  // }
  Widget _buildChipsTypeTime() {
    List<Widget> chips = [];

    for (int i = 0; i < listTimeTake.length; i++) {
      ChoiceChip choiceChip = ChoiceChip(
        selected: _selectedIndex == i,
        label: Text(listTimeTake[i].timeTakeName, style: TextStyle(color: Colors.black,fontFamily: 'SukhumvitSet-SemiBold',fontSize: 25)),
        elevation: 3,
        pressElevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: Color(0xffC2C2C3),
        selectedColor: AppColors.colorMain,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedIndex = i;
              _selectedTimeTakeId = listTimeTake[i].timeTakeId;
            }
          });
        },
      );
      chips.add(choiceChip);
    }
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: chips,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
          backgroundColor: AppColors.colorMain,
          title: const Text("กรุณาเพิ่มยา",style: TextStyle(
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
        margin: const EdgeInsets.only(top: 30.0),
        child: ListView(
          children: [
            Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                                        controller: txtMedicine,
                                        enabled: true,
                                        style: const TextStyle(
                                          fontSize: 25.0,
                                            fontFamily: 'SukhumvitSet-Bold',
                                            color: Colors.black),
                                        decoration: new InputDecoration(
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
                                            hintText: "ชื่อยา",
                                            hintStyle: new TextStyle(
                                                fontFamily: 'SukhumvitSet-Medium',
                                                color: Colors.grey[800]),
                                            fillColor:AppColors.bgColor),
                                        // fillColor: Colors.white70),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 20),
                                      alignment: Alignment.center,
                                      child:
                                    _buildChipsTypeTime())
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ]),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 70,
        margin: const EdgeInsets.all(20),
        child:  Row(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(right: 5),
                width: double.maxFinite,
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
                    // Navigator.push(context,
                    //     CupertinoPageRoute(builder: (context) {
                    //       return MainMenu();
                    //     }));
                    Navigator.pop(context);
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
                    if(txtMedicine.text.isNotEmpty) {
                      AppUrl.objAddItemMedicine.nameMedicine = txtMedicine.text.toString();
                     
                      _pushPageFrequency(context,false);
                     }else {
                      _openPopupInvalidate(context,"กรุณากรอกข้อมูลให้ครบถ้วน");
                    }
                  },

              //     onPressed: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => Frequency(),
              //   ),
              //   );
              //   // ทำอะไรก็ตามที่คุณต้องการเมื่อกดปุ่ม "หน้าถัดไป"
              //   // ในตัวอย่างนี้เราจะแสดงข้อมูลที่ถูกเลือก
                
              // },
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

  _openPopupInvalidate(context,title) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  mediaQuery(context, 'h', 50),
                ),
              ),
            ),

            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'SukhumvitSet-Bold',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: mediaQuery(context, 'h', 20),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ButtonTheme(
                        // minWidth: mediaQuery(context, 'h', 320),
                        // height: mediaQuery(context, 'h', 120),
                        child:  ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(
                                  mediaQuery(context, 'h', 50),
                                ),
                                side: BorderSide(
                                  color: AppColors.color.withOpacity(0.51),
                                ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'ตกลง',
                            style: TextStyle(
                              fontFamily: 'SukhumvitSet-Bold',
                              color: AppColors.color,
                              fontSize: mediaQuery(context, 'h', 46),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  void _pushPageFrequency(BuildContext context, bool isHorizontalNavigation) {
    Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
      _buildAdaptivePageRoute(
        builder: (context) => const Frequency(),
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
