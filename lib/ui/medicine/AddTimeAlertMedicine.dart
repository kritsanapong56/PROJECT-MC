import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alarm_safealert/tool/color.dart';
import '../../tool/url.dart';
import '../../widget/CustomCupertinoTimerPicker.dart';
import 'dart:io' as Io;
import 'package:bottom_sheet/bottom_sheet.dart';

import 'AddImageMedicine.dart';

class AddTimeAlertMedicine extends StatefulWidget {
  final typeTime;
  AddTimeAlertMedicine(this.typeTime);
  @override
  _AddTimeAlertMedicine createState() => _AddTimeAlertMedicine();
}

class _AddTimeAlertMedicine extends State<AddTimeAlertMedicine> {
  var initialtimer = Duration();
  // กำนหดตัวแปรข้อมูล articles
  List<String> listTimeLine = [
    "08:00","12:00","20:00"
  ];
  var statusAdd = false;
  var indexEdit = 0;
  @override
  void initState() {
    if(int.parse(widget.typeTime) == 1){
      listTimeLine = [
        "08:00"
      ];
    }else if(int.parse(widget.typeTime) == 2){
      listTimeLine = [
        "08:00","12:00"
      ];
    }else{
      listTimeLine = [
        "08:00","12:00","20:00"
      ];
    }
    super.initState(); 
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
        backgroundColor: AppColors.colorMain,
        title: const Text("คุณต้องการรับแจ้งเตือนกี่โมง",style: TextStyle(
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
        margin: const EdgeInsets.only(left:20,top: 20,right: 20,bottom: 170),
        child:
        Expanded( // ส่วนของลิสรายการ
          child: listTimeLine.isNotEmpty // กำหนดเงื่อนไขตรงนี้
              ? ListView.builder( // กรณีมีรายการ แสดงปกติ
            itemCount: listTimeLine.length ,
            itemBuilder: (context, index) {
              return
                Card(
                  margin: const EdgeInsets.only(top: 10,bottom: 10),
              color: AppColors.bgColor, // สี
              // shadowColor: Colors.red.withAlpha(100), // สีของเงา
              // elevation: 5.0, // การยกของเงา
              shape: RoundedRectangleBorder( // รูปแบบ
              borderRadius: BorderRadius.circular(20),
              ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0),
                        width: 200,
                        child: TextField(
                          enabled: false,
                          style: const TextStyle(
                              fontSize: 25.0,
                              fontFamily: 'SukhumvitSet-Medium',
                              color: Colors.black),
                          decoration: InputDecoration(
                              contentPadding:
                              const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 15),
                              //ปรับตำแหน่งcursor เริ่มต้นในช่องข้อความ
                              border: const OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(
                                    Radius.circular(
                                        20.0),
                                  ),
                                  borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle
                                          .none)),
                              filled: true,
                              hintText: listTimeLine[index],
                              hintStyle: TextStyle(
                                  fontFamily: 'SukhumvitSet-Medium',
                                  color: Colors
                                      .grey[800]),
                              fillColor: AppColors
                                  .bgColor),
                          // fillColor: Colors.white70),
                        ),
                      ),

                        Container(
                        padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0),
                              child: InkWell(
                                onTap: (){
                                  indexEdit = index;
                                  _showSheetTime();
                                },
                                child:  const Text("แก้ไขเวลา", style: TextStyle(
                                    fontSize: 25, color: Colors.black,
                                    fontFamily: 'SukhumvitSet-Medium')),
                              )
                      )
                    ],
                  ),
                );
            },
          )
              : const Center(child: Text('No items')), // กรณีไม่มีรายการ
        ),
      ),
      // floatingActionButton: FloatingActionButton( // ปุ่มทดสอบสำหรับดึงข้อมูลซ้ำ
      //   onPressed: (){},
      //   child: const Icon(Icons.add),
      // ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: widget.typeTime == "4" ? 120 : 70,
        margin: const EdgeInsets.all(20),
        child:  Column(
          children: [
            widget.typeTime == "4" ?
            Container(
              child: TextButton(
                  onPressed: (){
                    initialtimer =  Duration(
                        hours: DateTime
                            .now()
                            .hour, minutes: DateTime
                        .now()
                        .minute);
                    statusAdd = true;
                    _showSheetTime();
                  },
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle_outline),
                      SizedBox(width: 10,),
                      Text("เพิ่มเวลาทานยา",style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'SukhumvitSet-Medium'))
                    ],
                  )

              ),
            ) : Container(),
            Container(
              width: 120,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 5,top: 10),
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
                  AppUrl.objAddItemMedicine.timeNum = listTimeLine;
                  _pushPageAddImageMedicine(context,false);
                },
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text(
                        "ตกลง",
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
          ],
        ),
      ),
    );
  }
  void _showSheetTime() {
    showFlexibleBottomSheet<void>(
      minHeight: 0,
      initHeight: 0.4,
      maxHeight: 0.4,
      context: context,
      builder: _buildBottomSheet,
      anchors: [0, 0.4, 0.4],
    );
  }

  Widget _buildBottomSheet(
      BuildContext context,
      ScrollController scrollController,
      double bottomSheetOffset,
      ) {
    return SafeArea(
      child: Material(
        child: Column(
          children: [
            Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: CustomCupertinoTimerPicker(
                  mode: CustomCupertinoTimerPickerMode.hm,
                  minuteInterval: 1,
                  secondInterval: 1,
                  initialTimerDuration: Duration(
                      hours: DateTime
                          .now()
                          .hour, minutes: DateTime
                      .now()
                      .minute),
                  onTimerDurationChanged: (
                      Duration changedtimer) {
                    initialtimer = changedtimer;
                  },
                )
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(top: 20,bottom: 20),
              child: TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.only(left: 5,right: 5,top: 10,bottom: 10),),
                  // shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(20.0), )),
                  // backgroundColor: MaterialStateProperty.resolveWith((states) => AppColors.colorMain),
                  // elevation: MaterialStateProperty.resolveWith<double>(
                  //       (Set<MaterialState> states) {
                  //     return 2.0;
                  //   },),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  final HH = (initialtimer.inHours).toString().padLeft(2, '0');
                  final mm = (initialtimer.inMinutes % 60).toString().padLeft(2, '0');
                  final ss = (initialtimer.inSeconds % 60).toString().padLeft(2, '0');

                  setState(() {
                    if(statusAdd){
                      listTimeLine.add('$HH:$mm');
                      statusAdd = false;
                    }else{
                      listTimeLine[indexEdit] = '$HH:$mm';
                    }
                  });
                },
                child: Container(
                  width: 120,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                  child: const Text(
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
        ),
      ),
    );
  }

  void _pushPageAddImageMedicine(BuildContext context, bool isHorizontalNavigation) {
    Navigator.of(context, rootNavigator: !isHorizontalNavigation).push(
      _buildAdaptivePageRoute(
        builder: (context) => AddImageMedicine(),
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
