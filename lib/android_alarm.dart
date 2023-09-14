import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:audio_session/audio_session.dart';
import 'package:control_volume/control_volume.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

import 'alarm_notification.dart';
import 'alarm_storage.dart';
import 'alarms_model.dart';

class AndroidAlarm {
  static String ringPort = 'alarm-ring';
  static String stopPort = 'alarm-stop';
  static int timerDurationSeconds = 5;
  static int secondsToMinutes = 60;

  // static String stopPort1 = 'alarm-stop1';

  /// Initializes AndroidAlarmManager dependency
  static Future<void> init() => AndroidAlarmManager.initialize();
  static final audioPlayer = AudioPlayer();

  static const platform =
      MethodChannel('com.cagridurmus.periodic_alarm/notifOnAppKill');

  static bool get hasAnotherAlarm => AlarmStorage.getSavedAlarms().length > 1;

  static Future<bool> setOneAlarm(
      AlarmModel alarmModel, void Function()? onRing) async {
    try {
      final ReceivePort port = ReceivePort();
      final success = IsolateNameServer.registerPortWithName(
        port.sendPort,
        "$ringPort-${alarmModel.id}",
      );

      if (!success) {
        IsolateNameServer.removePortNameMapping("$ringPort-${alarmModel.id}");
        IsolateNameServer.registerPortWithName(
            port.sendPort, "$ringPort-${alarmModel.id}");
      }
      port.listen((message) {
        debugPrint('[Alarm] $message');
        if (message == 'ring') onRing?.call();
      });
    } catch (e) {
      debugPrint('[Alarm] ReceivePort error: $e');
      return false;
    }

    if (alarmModel.enableNotificationOnKill && !hasAnotherAlarm) {
      try {
        await platform.invokeMethod(
          'setNotificationOnKillService',
          {
            'title': AlarmStorage.getNotificationOnAppKillTitle(),
            'description': AlarmStorage.getNotificationOnAppKillBody(),
          },
        );
        debugPrint('[Alarm] NotificationOnKillService set with success');
      } catch (e) {
        debugPrint('[Alarm] NotificationOnKillService error: $e');
      }
    }
    final res = await AndroidAlarmManager.oneShotAt(
        alarmModel.dateTime, alarmModel.id, AndroidAlarm.playAlarm,
        alarmClock: true,
        allowWhileIdle: true,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
        params: alarmModel.toJson());

    debugPrint(res
        ? '${alarmModel.dateTime} ve ${alarmModel.id} li tek seferlik alarm oluşturuldu.'
        : 'Oluşturulamadı');

    if (res &&
            alarmModel.notificationTitle != null &&
            alarmModel.notificationTitle!.isNotEmpty &&
            alarmModel.notificationBody != null &&
            alarmModel
                .notificationBody!.isNotEmpty /* &&
        alarmModel.active*/
        ) {
      await AlarmNotification.instance.scheduleAlarmNotif(
        id: alarmModel.id,
        dateTime: alarmModel.dateTime,
        title: alarmModel.notificationTitle!,
        body: alarmModel.notificationBody!,
      );
    }
    return res;
  }

  static Future<bool> setPeriodicAlarm(
      AlarmModel alarmModel, void Function()? onRing) async {
    try {
      final ReceivePort port = ReceivePort();
      final success = IsolateNameServer.registerPortWithName(
        port.sendPort,
        "$ringPort-${alarmModel.id}",
      );

      if (!success) {
        IsolateNameServer.removePortNameMapping("$ringPort-${alarmModel.id}");
        IsolateNameServer.registerPortWithName(
            port.sendPort, "$ringPort-${alarmModel.id}");
      }
      port.listen((message) {
        debugPrint('[Alarm] $message');
        if (message == 'ring') onRing?.call();
      });
    } catch (e) {
      debugPrint('[Alarm] ReceivePort error: $e');
      return false;
    }

    if (alarmModel.enableNotificationOnKill && !hasAnotherAlarm) {
      try {
        await platform.invokeMethod(
          'setNotificationOnKillService',
          {
            'title': AlarmStorage.getNotificationOnAppKillTitle(),
            'description': AlarmStorage.getNotificationOnAppKillBody(),
          },
        );
        debugPrint('[Alarm] NotificationOnKillService set with success');
      } catch (e) {
        debugPrint('[Alarm] NotificationOnKillService error: $e');
      }
    }

    final res = await AndroidAlarmManager.oneShotAt(
        alarmModel.dateTime, alarmModel.id, AndroidAlarm.playAlarm1,
        alarmClock: true,
        allowWhileIdle: true,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
        params: alarmModel.toJson());

    debugPrint(res
        ? '${alarmModel.dateTime} ve ${alarmModel.id} li periodic alarm oluşturuldu.'
        : 'Oluşturulamadı');

    if (res &&
            alarmModel.notificationTitle != null &&
            alarmModel.notificationTitle!.isNotEmpty &&
            alarmModel.notificationBody != null &&
            alarmModel.notificationBody!
                .isNotEmpty /* &&
        alarmModel.active &&
        alarmModel.days[DateTime.now().weekday - 1]*/
        ) {
      await AlarmNotification.instance.scheduleAlarmNotif(
        id: alarmModel.id,
        dateTime: alarmModel.dateTime,
        title: alarmModel.notificationTitle!,
        body: alarmModel.notificationBody!,
      );
    }
    return res;
  }

  @pragma('vm:entry-point')
  static Future<void> playAlarm(int id, Map<String, dynamic> data) async {
    var alarmModel = AlarmModel.fromJson(data);
    SendPort send = IsolateNameServer.lookupPortByName("$ringPort-$id")!;
    send.send('ring');
    playMusic(send, alarmModel, id);
  }

  @pragma('vm:entry-point')
  static Future<void> playAlarm1(int id, Map<String, dynamic> data) async {
    // var now = DateTime.now();

    var alarmModel = AlarmModel.fromJson(data);
    SendPort send = IsolateNameServer.lookupPortByName("$ringPort-$id")!;

    playMusic(send, alarmModel, id);
    send.send('ring');
  }

  static playMusic(SendPort send, AlarmModel alarmModel, int id) async {
    await AlarmStorage.saveIsAlarmRinging(id);
    // ignore: no_leading_underscores_for_local_identifiers

    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration(
      androidAudioAttributes: AndroidAudioAttributes(
        usage: AndroidAudioUsage.media,
      ),
    ));
    Timer? timer;
    try {
      final assetAudioPath = alarmModel.assetAudioPath;

      if (assetAudioPath.startsWith('http')) {
        await audioPlayer.setUrl(assetAudioPath);
      } else {
        await audioPlayer.setAsset(assetAudioPath);
      }

      final loopAudio = alarmModel.loopAudio;
      if (loopAudio) audioPlayer.setLoopMode(LoopMode.all);

      send.send('Alarm fadeDuration: ${alarmModel.fadeDuration.toString()}');

      final musicTime = (alarmModel.musicTime).toDouble();

      if (musicTime > 0) {
        double volume = 0.0;

        audioPlayer.setVolume(0.0);
        audioPlayer.play();

        send.send('Alarm playing with fadeDuration ${musicTime}s');

        timer = Timer.periodic(
          Duration(seconds: timerDurationSeconds),
          (timer) {
            // counter++;
            if (audioPlayer.volume < alarmModel.incMusicVolume) {
              volume = audioPlayer.volume +
                  (alarmModel.incMusicVolume * timerDurationSeconds) /
                      (alarmModel.incMusicTime * secondsToMinutes);
            } else {
              volume = audioPlayer.volume +
                  ((alarmModel.musicVolume - alarmModel.incMusicVolume) *
                          timerDurationSeconds) /
                      ((alarmModel.musicTime - alarmModel.incMusicTime) *
                          secondsToMinutes);
            }
            if (volume > 1.0) {
              volume = 1.0;
            }
            ControlVolume().setVolume(volume, showSystemUI: false);
            audioPlayer.setVolume(volume);
            debugPrint('music volume: ${audioPlayer.volume}');
            if (audioPlayer.volume >= alarmModel.musicVolume) timer.cancel();
          },
        );
      } else {
        audioPlayer.play();
        send.send('Alarm with id $id starts playing.');
      }
    } catch (e) {
      send.send('AudioPlayer with id $id error: ${e.toString()}');
      await AudioPlayer.clearAssetCache();
      send.send('Asset cache reset. Please try again.');
    }

    try {
      final ReceivePort port = ReceivePort();
      final success = IsolateNameServer.registerPortWithName(
          port.sendPort, "$stopPort-${alarmModel.id}");

      if (!success) {
        IsolateNameServer.removePortNameMapping("$stopPort-${alarmModel.id}");
        IsolateNameServer.registerPortWithName(
            port.sendPort, "$stopPort-${alarmModel.id}");
      }

      port.listen(
        (message) async {
          send.send('(isolate) received: $message');
          if (message == 'stop') {
            timer!.cancel();
            await audioPlayer.stop();
            // await audioPlayer.dispose();
            port.close();
          }
        },
      );
    } catch (e) {
      send.send('(isolate) ReceivePort error: $e');
    }
  }

  static Future<bool> cancelAlarm(int alarmId) async {
    bool res = await AndroidAlarmManager.cancel(alarmId);

    return res;
  }

  @pragma('vm:entry-point')
  static Future<bool> stop(int id) async {
    bool res;
    try {
      // SendPort send1 = IsolateNameServer.lookupPortByName("$ringPort-$id")!;
      List<String> isRingingAlarms = await AlarmStorage.getAlarmRinging();

      if (isRingingAlarms.length <= 1) {
        final SendPort send =
            IsolateNameServer.lookupPortByName("$stopPort-$id")!;
        send.send('stop');
      } else {
        for (int i = 0; i <= isRingingAlarms.length - 1; i++) {
          final SendPort send = IsolateNameServer.lookupPortByName(
              "$stopPort-${isRingingAlarms[i]}")!;
          send.send('stop');
        }
      }
      await AlarmStorage.removeAlarmRinging();
      // send1.send('ring');

      res = true;
    } catch (e) {
      debugPrint('[Alarm] (main) SendPort error: $e');
      res = false;
    }

    // if (!hasAnotherAlarm) stopNotificationOnKillService();
    return res;
  }

  static Future<void> stopNotificationOnKillService() async {
    try {
      await platform.invokeMethod('stopNotificationOnKillService');
      debugPrint('[Alarm] NotificationOnKillService stopped with success');
    } catch (e) {
      debugPrint('[Alarm] NotificationOnKillService error: $e');
    }
  }
}
