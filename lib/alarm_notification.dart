import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alarm_safealert/tool/url.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

const String alarmStopActionId = 'ข้าม';

const String alarmTakeActionId = 'รับ';

const String alarmSnoozeActionId = 'เลื่อนเวลา';

class AlarmNotification {
  AlarmNotification._();

  static final instance = AlarmNotification._();

  final FlutterLocalNotificationsPlugin localNotif = FlutterLocalNotificationsPlugin();

  static final StreamController<String?> selectNotificationStream =
      StreamController<String?>.broadcast();

  /// Adds configuration for local notifications and initialize service.
  Future<void> init() async {
    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await localNotif.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            selectNotificationStream.add(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            selectNotificationStream.add(notificationResponse.actionId);

            break;
        }
      },
    );
    tz.initializeTimeZones();

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
    FirebaseMessaging.instance.onTokenRefresh.listen((String token) async {
      print("New token: $token");
      AppUrl.FCM_token = token;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
    FirebaseMessaging.onBackgroundMessage(_messageHandler);
  }

  Future<void> _messageHandler(RemoteMessage message) async {
    print('background message ${message.notification!.body}');
    // FlutterRingtonePlayer.play(
    //   android: AndroidSounds.alarm,
    //   ios: IosSounds.alarm,
    //   looping: false, // Android only - API >= 28
    //   volume: 1, // Android only - API >= 28
    //   asAlarm: false, // Android only - all APIs
    // );
    // Future.delayed(const Duration(milliseconds: 4000), () {
    //   FlutterRingtonePlayer.stop();
    // });
  }

  /// Shows notification permission request.
  Future<bool> requestPermission() async {
    late bool? result;

    if (Platform.isAndroid) {
      result = await localNotif
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission();
    } else {
      result = await localNotif
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
    return result ?? false;
  }

  tz.TZDateTime nextInstanceOfTime(DateTime time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime.from(
      time,
      tz.local,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  /// Schedules notification at the given time.
  Future<void> scheduleAlarmNotif({
    required int id,
    required DateTime dateTime,
    required String title,
    required String body,
    String? payload,
  }) async {
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      presentSound: false,
      presentAlert: false,
      presentBadge: false,
    );

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm',
      'alarm_package',
      channelDescription: 'Alarm package',
      importance: Importance.max,
      priority: Priority.max,
      enableLights: true,
      fullScreenIntent: true,
      playSound: false,
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
    );

    const platformChannelSpecifics = NotificationDetails(
      iOS: iOSPlatformChannelSpecifics,
      android: androidPlatformChannelSpecifics,
    );

    final zdt = nextInstanceOfTime(dateTime);

    final hasPermission = await requestPermission();
    if (!hasPermission) {
      debugPrint('[Alarm] Notification permission not granted');
      return;
    }

    try {
      await localNotif.zonedSchedule(
        id,
        title,
        body,
        zdt,
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
      debugPrint('[Alarm] Notification with id $id scheduled successfuly at $zdt');
    } catch (e) {
      debugPrint('[Alarm] Schedule notification with id $id error: $e');
    }
  }

  /// Cancels notification. Called when the alarm is cancelled or
  /// when an alarm is overriden.
  Future<void> cancel(int id) async {
    await localNotif.cancel(id);
    debugPrint('[Alarm] Notification with id $id canceled');
  }
}
