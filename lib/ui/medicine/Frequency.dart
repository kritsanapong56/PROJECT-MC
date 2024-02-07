import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alarm_safealert/ui/medicine/AddTimeAlertMedicine.dart';
import 'package:flutter_alarm_safealert/ui/medicine/Addtime.dart';
import 'package:flutter_alarm_safealert/ui/medicine/TimeDayMedicine.dart';
import '../../tool/color.dart'; 

class Frequency extends StatefulWidget {
  const Frequency({super.key});

  @override
  State<Frequency> createState() => _FrequencyState();
}

class _FrequencyState extends State<Frequency> {
  int selectedNumber = 1;
  
  get listTimeDay => null;
  
  get index => null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.colorMain,
          title: new Text("ความถี่การทานยา",style: TextStyle(
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'เลือกข้อมูล: $selectedNumber',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildNumberButton(1),
                buildNumberButton(2),
                buildNumberButton(3),
                buildNumberButton(4),
                buildNumberButton(5),
              ],
            ),
            SizedBox(height: 20),
            
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => TimeDayMedicine(),
            //     ),
            //     );
            //     // ทำอะไรก็ตามที่คุณต้องการเมื่อกดปุ่ม "หน้าถัดไป"
            //     // ในตัวอย่างนี้เราจะแสดงข้อมูลที่ถูกเลือก
    
            //   },
            //   child: Text('หน้าถัดไป'),
            // ),
          ],
        ),
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
                  // onPressed: () {
                  //   if(txtMedicine.text.isNotEmpty && _selectedIndex > -1) {
                  //     AppUrl.objAddItemMedicine.nameMedicine = txtMedicine.text.toString();
                  //     AppUrl.objAddItemMedicine.timeTakeId = _selectedTimeTakeId;
                  //     _pushPagetest(context,false);
                  //    }else {
                  //     _openPopupInvalidate(context,"กรุณากรอกข้อมูลให้ครบถ้วน");
                  //   }
                  // },

                   onPressed: () {
            // นำทางไปยังหน้าที่ต้องการ
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Addtime()),
                    );
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

  Widget buildNumberButton(int number) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedNumber = number;
        });
      },
      child: Text('$number'),
    );
  }
    void _pushPageAddTime(BuildContext context, bool isHorizontalNavigation, String timeLineId) {
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

