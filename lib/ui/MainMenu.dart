import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alarm_safealert/model/ModelItemMedicine.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:just_audio/just_audio.dart';
import '../../tool/color.dart';
import '../../ui/dialog/remark_select.dart';

import '../alarm_notification.dart';
import '../alarm_storage.dart';
import '../model/ModeReport.dart';
import '../model/ModelAlarmMedicine.dart';
import '../model/ModelRegister.dart';
import '../tool/api.dart';
import '../tool/url.dart';
import 'dialog/alert_alarm_medicine.dart';
import 'dialog/another_remark_select.dart';
import 'dialog/time_alarm_next.dart';
import 'home/HomeMain.dart';
import 'medicine/AddMedicine.dart';
import 'medicine/MedicineMain.dart';
import 'menu/MenuList.dart';

var selectedDate = "";

class MainMenu extends StatefulWidget {
  static const routeName = '/';
  @override
  _MainMenu createState() => _MainMenu();
}

class _MainMenu extends State<MainMenu> {
  final player = AudioPlayer(
    // Handle audio_session events ourselves for the purpose of this demo.
    handleInterruptions: false,
    androidApplyAudioAttributes: false,
    handleAudioSessionActivation: false,
  );
  StreamSubscription? _notificationSubscription;
  int _currentIndex = 1;
  int _counter = 10;
  final tabs = [
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('th')],
      home: MedicineMain(),
    ),
    MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('th')],
      home: HomeMain(),
    ),
    MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('th')],
      home: MenuList(),
    ),
  ];
  @override
  void initState() {
    _notificationSubscription = AlarmNotification.selectNotificationStream.stream.listen((data) {
      print('recieve data');
      print('data: $data');
      final med = ModelAlarmMedicine.fromMap(json.decode(data ?? ''));

      _showAlertAlarmMedicine(med.alarm_id, 0, med.img_medicine, med.set_time_alarm,
          med.msg_num_medicine, med.medicine_name, 0);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('TERMINATED');
        final redirectRoute = message.data['route'];
        print('redirectRoute $redirectRoute');
        //remove redirect route here, so the unknownRoute will trigger the default route
      }
    });
    FirebaseMessaging.onMessage.listen((message) {
      print('message $message');
      try {
        var alert_id = message.data['alert_id'];
        var medicine_id = message.data['medicine_id'];
        var medicine_name = message.data['medicine_name'];
        var msg_time_alarm = message.data['msg_time_alarm'];
        var msg_num_medicine = message.data['msg_num_medicine'];
        var time_eat_real = message.data['time_eat_real'];
        var img_medicine = message.data['img_medicine'];
        Future.delayed(const Duration(milliseconds: 4000), () {
          FlutterRingtonePlayer.stop();
        });
        _showAlertAlarmMedicine(alert_id, medicine_id, img_medicine, msg_time_alarm,
            msg_num_medicine, medicine_name, time_eat_real);
      } catch (e) {}
    });

    //onclick notif system tray only works if app in background but not termi
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      var alert_id = message.data['alert_id'];
      var medicine_id = message.data['medicine_id'];
      var medicine_name = message.data['medicine_name'];
      var msg_time_alarm = message.data['msg_time_alarm'];
      var msg_num_medicine = message.data['msg_num_medicine'];
      var time_eat_real = message.data['time_eat_real'];
      var img_medicine = message.data['img_medicine'];
      Future.delayed(const Duration(milliseconds: 4000), () {
        FlutterRingtonePlayer.stop();
      });
      _showAlertAlarmMedicine(alert_id, medicine_id, img_medicine, msg_time_alarm, msg_num_medicine,
          medicine_name, time_eat_real);
    });

    FirebaseMessaging.onBackgroundMessage(_messageHandler);
    super.initState();
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _messageHandler(RemoteMessage message) async {
    print('background message ${message.notification!.body}');
    // FlutterRingtonePlayer.play(
    //   android: AndroidSounds.alarm,
    //   ios: IosSounds.alarm,
    //   looping: true, // Android only - API >= 28
    //   volume: 1, // Android only - API >= 28
    //   asAlarm: false, // Android only - all APIs
    // );
    soundAlarmScreen();
  }

  soundAlarmScreen() async {
// Initializing and playing the audio using just_audio
//     await player.setAudioSource(AudioSource.asset("marimba.mp3"));
    await player.setLoopMode(LoopMode.all);
    player.play();
  }

  openAlarmScreen() async {
    Future.delayed(const Duration(seconds: 1), () async {
      var alarms = await AlarmStorage.getAlarmRinging();
      if (alarms.isNotEmpty) {
        Navigator.pushNamed(context, '/');
      }
    });
  }

  void _showRemarkSelect(medicine_id) async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API

    List<String> title = [
      "ลืมทานยา/ไม่ว่างทาน",
      "ยาไม่ได้อยู่ใกล้",
      "ยาหมด",
      "ไม่ต้องการทานยา",
      "มีผลข้างเคียง",
      "อื่นๆ"
    ];

    final String? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return remark_select(items: title);
      },
    );

    // Update UI
    if (results != null) {
      // setState(() async {
      if (results == title.last) {
        _showAnotherRemarkSelect(medicine_id);
      } else {
        await ModelReport.addReportSkip(medicine_id, results);
      }

      // titleName = results.toString();
      // _fieldTitleName.text = titleName;
      // });
    }
  }

  void _showAnotherRemarkSelect(alert_id) async {
    final String? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return another_remark_select();
      },
    );

    // Update UI
    if (results != null) {
      await ModelReport.addReportSkip(alert_id, results);
      // setState(() {

      // titleName = results.toString();
      // _fieldTitleName.text = titleName;
      // });
    }
  }

  void _showAlertAlarmMedicine(alert_id, medicine_id, img_medicine, msg_time_alarm, msg_num_alarm,
      medicine_name, time_eat_real) async {
    final String? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert_alarm_medicine(
            alert_id, img_medicine, msg_time_alarm, msg_num_alarm, medicine_name);
      },
    );

    // Update UI
    if (results != null) {
      // setState(() async {
      player.play();
      // titleName = results.toString();
      // _fieldTitleName.text = titleName;
      if (results == "snooze") {
        _showTimeAlarmNext(alert_id, time_eat_real);
      } else if (results == "stop") {
        await ModelReport.addReportEat(medicine_id);
      } else if (results == "skip") {
        _showRemarkSelect(medicine_id);
      } else if (results == "edit") {
        _pushPageAddMedicine(context, false, medicine_id, medicine_name);
      } else if (results == "delete") {
        await ModelItemMedicine.deleteAlarm(alert_id);
      }
      // });
    }
  }

  void _showTimeAlarmNext(alert_id, time_eat_real) async {
    final String? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return time_alarm_next();
      },
    );

    // Update UI
    if (results != null) {
      Map<String, dynamic> data = {
        "alarm_id": alert_id,
        "time_eat_real": time_eat_real,
        "time_snooze": results
      };
      final response = await AppApi.post_Json(AppUrl.update_time_snooze, data); // เรียกใช้ api
      print(response);
      if (response['statusCode'] == 200) {
        // AppLoader.showSuccess("แก้ไขสำเร็จ");
      }
    }
  }

  void loadData() async {
    final list = await ModelRegister.getData();
    setState(() {
      AppUrl.objRegister = ModelRegister.fromJson(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bdColor,
      appBar: null,
      body: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        child: tabs[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 25,
        unselectedFontSize: 20,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.colorMain,
        backgroundColor: const Color(0xfff6f6f9),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        unselectedLabelStyle: const TextStyle(fontSize: 20, fontFamily: 'SukhumvitSet-SemiBold'),
        selectedLabelStyle: const TextStyle(fontSize: 25, fontFamily: 'SukhumvitSet-SemiBold'),
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/med.png"),
              size: 50,
            ),
            label: 'ข้อมูลยา',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/home.png"),
              size: 50,
            ),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/menu.png"),
              size: 50,
            ),
            label: 'เมนู',
          )
        ],
      ),
    );
  }

  Widget myAppBarIcon() {
    return Container(
      child: Stack(
        children: [
          const Icon(
            Icons.notifications,
            color: Colors.black,
            size: 30,
          ),
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.topRight,
            margin: const EdgeInsets.only(top: 5),
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xffc32c37),
                  border: Border.all(color: Colors.white, width: 1)),
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Center(
                  child: Text(
                    _counter.toString(),
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pushPageAddMedicine(
      BuildContext context, bool isHorizontalNavigation, String medicine_id, String medicine_name) {
    Navigator.of(context, rootNavigator: !isHorizontalNavigation)
        .push(
      _buildAdaptivePageRoute(
        builder: (context) => AddMedicine(medicine_id, medicine_name),
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
