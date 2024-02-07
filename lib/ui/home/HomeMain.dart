import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alarm_safealert/tool/loader.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:intl/intl.dart';
import '../../alarm_notification.dart';
import '../../model/ModelItemMedicine.dart';
import '../../model/ModelMedicine.dart';
import '../../model/ModelRegister.dart';
import '../../model/ModelTimeTakeMedicine.dart';
import '../../model/ModelAlarmMedicine.dart';
import '../../tool/color.dart';
import '../../tool/pref.dart';
import '../../tool/url.dart';
import '../../ui/dialog/alert_alarm_medicine.dart';
import '../../ui/dialog/another_remark_select.dart';
import '../../ui/dialog/remark_select.dart';
import '../../ui/dialog/time_alarm_next.dart';
import '../../ui/medicine/AddMedicine.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:collection/collection.dart";

import '../MainMenu.dart';

class HomeMain extends StatefulWidget {
  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  int _counter = 0;
  var fDate = new DateFormat('yyyy-MM-dd');
  var dateOutputDate = DateTime.now();
  Map<String, List<ModelAlarmMedicine>> resultAlarmMedicine = {};
  List<ModelAlarmMedicine> listAlarmMedicine = [];
  List<ModelMedicine> listMedicine = [
    ModelMedicine(
        id: 1, name: 'แก้ภูมแพ้', dateTime: DateTime.now(), messageDateTime: "ไม่ได้ทานยา"),
  ];
  Map<String, List<ModelMedicine>> _elements = {
    '08:00': [
      ModelMedicine(
          id: 1, name: 'แก้ภูมแพ้', dateTime: DateTime.now(), messageDateTime: "ไม่ได้ทานยา"),
    ],
    '12:00': [
      ModelMedicine(
          id: 1, name: 'แก้ภูมแพ้', dateTime: DateTime.now(), messageDateTime: "ไม่ได้ทานยา"),
    ],
  };
  var strEmpty = "";
  @override
  initState() {
    super.initState();
    selectedDate = fDate.format(DateTime.now());
    loadDataMedicineToDay(selectedDate);
    // new Timer(const Duration(seconds: 0), onClose);
    loadDataRegister();
    super.initState();
  }

  void loadDataMedicineToDay(selectedDate) async {
    AppLoader.show();
    listAlarmMedicine.clear();
    final list = await ModelAlarmMedicine.getMedicineToDay(selectedDate);
    setState(() {
      listAlarmMedicine =
          List<ModelAlarmMedicine>.from(list?.map((i) => ModelAlarmMedicine.fromMap(i)));
      resultAlarmMedicine = listAlarmMedicine.groupListsBy((student) => student.set_time_alarm);
      if (listAlarmMedicine.isEmpty) {
        strEmpty = 'ไม่มีรายชื่อยา';
      }
      _counter = listAlarmMedicine.length;
      AppLoader.hide();

      setAlarms();
    });
  }

  setAlarms() async {
    final AlarmNotification alarmNotification = AlarmNotification.instance;
    await alarmNotification.init();

    final FlutterLocalNotificationsPlugin localNotif = alarmNotification.localNotif;
    localNotif.cancelAll();

    final now = DateTime.now();

    for (final med in listAlarmMedicine) {
      final times = med.set_time_alarm.split(':');
      final hr = times[0];
      final min = times[1];

      AlarmNotification.instance.scheduleAlarmNotif(
        id: int.parse(med.alarm_id),
        title: med.medicine_name,
        body: med.msg_num_medicine,
        dateTime: DateTime(now.year, now.month, now.day, int.parse(hr), int.parse(min)),
        payload: json.encode(med.toJson()),
      );
    }
  }

  void loadDataRegister() async {
    final list = await ModelRegister.getData();
    setState(() {
      AppUrl.objRegister = ModelRegister.fromJson(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.bdColor,
        appBar: AppBar(
          backgroundColor: AppColors.colorMain,
          title: new Text(
            AppUrl.objRegister.name.toString().isNotEmpty
                ? AppUrl.objRegister.name
                : "กรุณาเพิ่ม ชื่อ - นามสุกล",
            style: TextStyle(fontFamily: 'SukhumvitSet-Bold'),
          ),
          leading: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppUrl.objRegister.img_profile.toString().isNotEmpty
                  ? Image.network(AppUrl.objRegister.img_profile)
                  : Image.asset("assets/images/profile.png")),
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
                        size: 30,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  _counter != 0
                      ? new Positioned(
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
                                  color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : new Container()
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
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                height: 150,
                child: EventCalendar(
                    dateTime: CalendarDateTime(
                      year: dateOutputDate.year,
                      month: dateOutputDate.month,
                      day: dateOutputDate.day,
                      calendarType: CalendarType.GREGORIAN,
                    ),
                    calendarOptions:
                        CalendarOptions(toggleViewType: false, viewType: ViewType.DAILY),
                    dayOptions: DayOptions(
                      compactMode: false,
                      dayFontSize: 16.0,
                      disableFadeEffect: true,
                      weekDaySelectedColor: Colors.black,
                      selectedTextColor: Colors.black,
                      selectedBackgroundColor: AppColors.colorBlueLight,
                    ),
                    headerOptions: HeaderOptions(
                        weekDayStringType: WeekDayStringTypes.SHORT,
                        monthStringType: MonthStringTypes.FULL,
                        headerTextColor: Colors.black),
                    // headerOptions: HeaderOptions(weekDayStringType: WeekDayStringTypes.SHORT),
                    calendarType: CalendarType.GREGORIAN,
                    calendarLanguage: 'en',
                    onInit: () {
                      DateTime dateTemp = DateTime(
                          dateOutputDate.year, dateOutputDate.month, dateOutputDate.day, 0, 0);

                      var sDate = DateFormat('yyyy-MM-dd').format(dateTemp).toString();
                      selectedDate = sDate;
                      var inputFormat = DateFormat('yyyy-MM-dd');
                      dateOutputDate = inputFormat.parse(selectedDate); // <-- dd/MM 24H format
                      loadDataMedicineToDay(selectedDate);
                    },
                    onDateTimeReset: (date) {
                      DateTime dateTemp = DateTime(date.year, date.month, date.day, 0, 0);

                      var sDate = DateFormat('yyyy-MM-dd').format(dateTemp).toString();
                      selectedDate = sDate;
                      var inputFormat = DateFormat('yyyy-MM-dd');
                      dateOutputDate = inputFormat.parse(selectedDate); // <-- dd/MM 24H format
                      loadDataMedicineToDay(selectedDate);
                    },
                    onChangeDateTime: (date) {
                      DateTime dateTemp = DateTime(date.year, date.month, date.day, 0, 0);
                      var sDate = DateFormat('yyyy-MM-dd').format(dateTemp).toString();
                      selectedDate = sDate;
                      var inputFormat = DateFormat('yyyy-MM-dd');
                      dateOutputDate = inputFormat.parse(selectedDate); // <-- dd/MM 24H format
                      loadDataMedicineToDay(selectedDate);
                    }
                    // onChangeDateTime: (date){
                    //     setState(() {
                    //       DateTime dateTemp = DateTime(
                    //           date.year,
                    //           date.month,
                    //           date.day,
                    //           0,
                    //           0);
                    //      var sDate = DateFormat('yyyy-MM-dd')
                    //           .format(dateTemp).toString();
                    //       selectedDate = sDate;
                    //       var inputFormat = DateFormat('yyyy-MM-dd');
                    //       dateOutputDate = inputFormat.parse(selectedDate); // <-- dd/MM 24H format
                    //       loadDataMedicineToDay(selectedDate);
                    //       // var outputFormat = DateFormat('dd/MMM/yyyy hh:mm a');
                    //       // dateOutputDate = outputFormat.format(inputDate);
                    //     });
                    //   }
                    ),

                // AnimatedHorizontalCalendar(
                //     tableCalenderIcon: Icon(Icons.calendar_today, color: Colors.white,),
                //     date: DateTime.now(),
                //     textColor: Colors.black45,
                //     backgroundColor: Colors.white,
                //     tableCalenderThemeData:  ThemeData.light().copyWith(
                //       primaryColor: Colors.green,
                //       hintColor: Colors.red,
                //       colorScheme: ColorScheme.light(primary: Colors.green),
                //       buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                //     ),
                //     selectedColor: Colors.redAccent,
                //     onDateSelected: (date){
                //       setState(() {
                //         selectedDate = date;
                //         var inputFormat = DateFormat('yyyy-MM-dd');
                //         dateOutputDate = inputFormat.parse(selectedDate); // <-- dd/MM 24H format
                //         loadDataMedicineToDay(selectedDate);
                //         // var outputFormat = DateFormat('dd/MMM/yyyy hh:mm a');
                //         // dateOutputDate = outputFormat.format(inputDate);
                //       });
                //     }
                // ),
              ),

              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: AppColors.colorMain, borderRadius: BorderRadius.circular(25.0)),
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text(DateFormat.yMMMd().format(dateOutputDate).toString(),
                    style: TextStyle(
                        color: Colors.black, fontSize: 20.0, fontFamily: 'SukhumvitSet-Bold'),
                    textAlign: TextAlign.center),
              ),

              // listMedicine.length > 0 // กำหนดเงื่อนไขตรงนี้
              //     ?
              //
              //     :
              resultAlarmMedicine.length == 0
                  ? Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: Image(
                              image: AssetImage('assets/images/bell.png'),
                              height: 190,
                              width: 190,
                            ),
                          ),
                          Center(
                            child: Text("คุณยังไม่มีรายการแจ้งเตือน",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 25.0,
                                    fontFamily: 'SukhumvitSet-Bold'),
                                textAlign: TextAlign.center),
                          ),
                          Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.only(top: 20.0, bottom: 20, left: 10, right: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    margin: EdgeInsets.only(right: 5),
                                    width: double.maxFinite,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.only(
                                            top: 10, bottom: 10.0, left: 20, right: 20),
                                        backgroundColor: AppColors.colorMain,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0)),
                                        elevation: 15.0,
                                      ),
                                      onPressed: () {
                                        // _showTimeAlarmNext();
                                        // _showAlertAlarmMedicine();
                                        // _showRemarkSelect();
                                        _pushPageAddMedicine(context, false);
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Text(
                                              "เพิ่มยา",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 35,
                                                  fontFamily: 'SukhumvitSet-Bold'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Expanded(
                      child: GroupListView(
                      sectionsCount: resultAlarmMedicine.keys.toList().length,
                      countOfItemInSection: (int section) {
                        return resultAlarmMedicine.values.toList()[section].length;
                      },
                      itemBuilder: (BuildContext context, IndexPath index) {
                        var num_eat = resultAlarmMedicine.values
                            .toList()[index.section][index.index]
                            .msg_skip;
                        return Card(
                            margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                            color: Colors.white,
                            // สี
                            // shadowColor: Colors.red.withAlpha(100), // สีของเงา
                            // elevation: 5.0, // การยกของเงา
                            shape: RoundedRectangleBorder(
                              // รูปแบบ
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: InkWell(
                              onTap: () {},
                              child: ListTile(
                                leading: resultAlarmMedicine.values
                                        .toList()[index.section][index.index]
                                        .img_medicine
                                        .isNotEmpty
                                    ? Image.network(resultAlarmMedicine.values
                                        .toList()[index.section][index.index]
                                        .img_medicine)
                                    : ImageIcon(
                                        AssetImage("assets/images/pills.png"),
                                        size: 40,
                                        color: Colors.black,
                                      ),
                                title: Text(
                                  "${resultAlarmMedicine.values.toList()[index.section][index.index].medicine_name}\n${resultAlarmMedicine.values.toList()[index.section][index.index].msg_num_medicine}",
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      fontFamily: 'SukhumvitSet-Medium',
                                      color: Colors.black),
                                ),
                                subtitle: Text(
                                  int.parse(num_eat) > 0 ? "ทานยาแล้ว" : "ไม่ได้ทานยา",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontFamily: 'SukhumvitSet-Bold',
                                      color: int.parse(num_eat) > 0 ? Colors.green : Colors.red),
                                ),
                              ),
                            ));
                      },
                      groupHeaderBuilder: (BuildContext context, int section) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  resultAlarmMedicine.keys.toList()[section],
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'SukhumvitSet-Bold',
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "ยาทั้งหมด",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'SukhumvitSet-Bold',
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ));
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 10),
                      sectionSeparatorBuilder: (context, section) => SizedBox(height: 10),
                    )

                      //---------//
                      //   ListView.builder( // กรณีมีรายการ แสดงปกติ
                      //   itemCount: 10,
                      //   itemBuilder: (context, index) {
                      //     ModelMedicine objType = listMedicine[0];
                      //     Widget card; // สร้างเป็นตัวแปร
                      //     card =
                      //         Column(
                      //             children: [
                      //               index == 0 ?
                      //               Container(
                      //                 padding: EdgeInsets.all(10),
                      //                 alignment: Alignment.centerLeft,
                      //                 child:
                      //                 Row(
                      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                   children: [
                      //                     Container(
                      //                       child: Text(
                      //                         "08:00",
                      //                         style: TextStyle(
                      //                             color: Colors.black,
                      //                             fontSize: 20,
                      //                             fontFamily: 'SukhumvitSet-Bold'),
                      //                       ),
                      //                     ),
                      //                     Container(
                      //                       child: Text(
                      //                         "ยาทั้งหมด",
                      //                         style: TextStyle(
                      //                             color: Colors.black,
                      //                             fontSize: 20,
                      //                             fontFamily: 'SukhumvitSet-Bold'),
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ) : Container(),
                      //               Card(
                      //                   margin: EdgeInsets.only(left:10,right: 10,bottom: 20),
                      //                   color: Colors.white, // สี
                      //                   // shadowColor: Colors.red.withAlpha(100), // สีของเงา
                      //                   // elevation: 5.0, // การยกของเงา
                      //                   shape: RoundedRectangleBorder( // รูปแบบ
                      //                     borderRadius: BorderRadius.circular(20),
                      //                   ),
                      //                   child: InkWell(
                      //                     onTap: (){
                      //                     },
                      //                     child: ListTile(
                      //                       leading:ImageIcon(
                      //                         AssetImage("assets/images/pills.png"),
                      //                         size:40,
                      //                         color: Colors.black,),
                      //                       title: Text("${objType.name}\nจำนวนยาที่ต้อทาน 1 เม็ด",
                      //                         style: TextStyle(
                      //                             fontSize: 22.0,
                      //                             fontFamily: 'SukhumvitSet-Medium',
                      //                             color: Colors.black),),
                      //                       subtitle: Text(objType.messageDateTime,
                      //                         style: TextStyle(
                      //                             fontSize: 16.0,
                      //                             fontFamily: 'SukhumvitSet-Medium',
                      //                             color: Colors.grey),),
                      //                     ),
                      //                   )
                      //               )]);
                      //     return card;
                      //   },
                      // )
                      ),
              // Container(
              //   width: double.maxFinite,
              //   margin: EdgeInsets.only(top: 20.0,bottom: 20,left: 10,right: 10),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         flex: 5,
              //         child: Container(
              //           margin: EdgeInsets.only(right: 5),
              //           width: double.maxFinite,
              //           child: RaisedButton(
              //             padding: EdgeInsets.only(
              //                 top: 10, bottom: 10.0, left: 20, right: 20),
              //             color: AppColors.colorMain,
              //             shape: RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.circular(25.0)),
              //             onPressed: () {
              //               // _showTimeAlarmNext();
              //               // _showAlertAlarmMedicine();
              //               // _showRemarkSelect();
              //               _pushPageAddMedicine(context,false);
              //             },
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 Container(
              //                   child: Text(
              //                     "เพิ่มยา",
              //                     style: TextStyle(
              //                         color: Colors.white,
              //                         fontSize: 35,
              //                         fontFamily: 'SukhumvitSet-Bold'),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ));
  }

  void _pushPageAddMedicine(BuildContext context, bool isHorizontalNavigation) {
    Navigator.of(context, rootNavigator: !isHorizontalNavigation)
        .push(
      _buildAdaptivePageRoute(
        builder: (context) => AddMedicine("", ""),
        fullscreenDialog: !isHorizontalNavigation,
      ),
    )
        .then((value) {
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

Future<void> onClose() async {
  // Navigator.push(this.context, CupertinoPageRoute(builder: (context) {
  //   return ButtonRegister();
  // }));
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    String? register_id = prefs.getString('register_id');
    AppUrl.RegisterID = register_id!;
  } catch (e) {
    print(e);
  }
}

class Item {
  final String name;
  final String category;
  Item({required this.name, required this.category});
}
