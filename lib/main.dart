import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alarm_safealert/periodic_alarm.dart';
import 'package:flutter_alarm_safealert/tool/color.dart';
import 'package:flutter_alarm_safealert/tool/url.dart';
import 'package:flutter_alarm_safealert/ui/Home.dart';
import 'package:flutter_alarm_safealert/ui/home/HomeMain.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:just_audio/just_audio.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();
final FirebaseMessaging messaging = FirebaseMessaging.instance;
final flutterRingtonePlayer = FlutterRingtonePlayer;
final audioPlayer = AudioPlayer();
Future<void> main() async {
  // Intl.defaultLocale = 'th_TH';
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // await Alarm.init(showDebugLogs: true);
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  requestPermission();
  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      print('TERMINATED');
      final redirectRoute = message.data['route'];
      print('redirectRoute $redirectRoute');
      //remove redirect route here, so the unknownRoute will trigger the default route
    }
  });

  FirebaseMessaging.instance.onTokenRefresh.listen((String token) async {
    print("New token: $token");
    AppUrl.FCM_token = token;
    // await sendFCMtoServer();
  });
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print('Message clicked!');
    FlutterRingtonePlayer.stop();
  });
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  // flutterLocalNotificationsPlugin.cancelAll();
  pushFCMtoken();
  await initLocalNotification();
  configLoading();
  runApp(MyApp());
}

void pushFCMtoken() async {
  String? token = await messaging.getToken();
  // sync token to server
  print("Token: $token");
  AppUrl.FCM_token = token!;
  // await sendFCMtoServer();
}

/// Shows notification permission request.
Future<bool> requestPermission() async {
  late bool? result;

  if (Platform.isAndroid) {
    result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  } else {
    result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
  return result ?? false;
}

void initMessaging() {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  AndroidInitializationSettings initializationSettingsAndroid;
  InitializationSettings initializationSettings;

  initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
  initializationSettings = new InitializationSettings(android: initializationSettingsAndroid);
  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  var androidDetails = new AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    importance: Importance.max,
    priority: Priority.high,
  );
  var generalNotificationDetails = NotificationDetails(android: androidDetails);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    Map<String, dynamic> data = message.data;
    // int.parse(data["alert_id"]),
    if (notification != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode, notification.title, notification.body, generalNotificationDetails);
    }
  });
}

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification?.body}');
  await Firebase.initializeApp();
  // audioPlayer.play();
  // FlutterRingtonePlayer.play(
  //   android: AndroidSounds.alarm,
  //   ios: IosSounds.alarm,
  //   looping: false, // Android only - API >= 28
  //   volume: 1, // Android only - API >= 28
  //   asAlarm: false, // Android only - all APIs
  // );
}

initLocalNotification() async {
  await PeriodicAlarm.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: AppColors.colorMain));
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: MaterialColor(AppColors.colorMain.value, AppColors.shadesColorMain),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          locale: const Locale('th'),
          supportedLocales: const [Locale('en')],
          home: Home(),
          builder: EasyLoading.init(),
        ));
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.threeBounce // รูปแบบ loader
    ..loadingStyle = EasyLoadingStyle.custom // loader แบบ  custom
    ..indicatorSize = 50.0 // ขนาด loader
    ..radius = 10.0
    ..progressColor = AppColors.colorMain
    ..backgroundColor = Colors.white // พื้นหลัง loader
    ..indicatorColor = AppColors.color // สี loader
    ..textColor = AppColors.colorBlue // สีข้อความ ใน loader
    ..textStyle = TextStyle(fontFamily: 'SukhumvitSet-Bold')
    ..maskColor = Colors.deepPurple.withOpacity(0.3) // สีพื้นหลัง loader
    ..userInteractions =
        false // พอมี loader ขึ้นมาแล้วจะกดข้างหลังได้หรือไม่ true จะกดได้ false จะกดไ่ม่ได้
    ..maskType = EasyLoadingMaskType.custom; // พื้นหลัง loader แบบ custom
}
