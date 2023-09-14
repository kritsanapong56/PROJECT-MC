import 'dart:async';
import 'dart:io';

import 'alarm_notification.dart';
import 'alarm_storage.dart';
import 'alarms_model.dart';
import 'android_alarm.dart';

const alarmNumber = 8;
class PeriodicAlarm {
  /// Whether it's iOS device.
  static bool get iOS => Platform.isIOS;

  /// Whether it's Android device.
  static bool get android => Platform.isAndroid;

  static final ringStream = StreamController<AlarmModel>();

  // static final stopStream = StreamController<AlarmModel>();

  static Future<void> init() async {
    await Future.wait([
      if (android) AndroidAlarm.init(),
      AlarmNotification.instance.init(),
      AlarmStorage.init(),
      // ringStreamInit()
    ]);
  }

  // static Future<void> ringStreamInit() async {
  //   ringStream.stream.listen(
  //     (alarmModel) {
  //       if(alarmModel.days.contains(true) && alarmModel.id < alarmNumber){
  //         PeriodicAlarm.cancelAlarm(alarmModel.id);
  //         alarmModel.setDateTime = alarmModel.dateTime.add(const Duration(days: 1));
  //         PeriodicAlarm.setPeriodicAlarm(alarmModel: alarmModel);
  //       }
  //     },
  //   );
  // }

  static Future<void> dispose() async {
    await Future.wait([
      AndroidAlarm.audioPlayer.dispose(),
      ringStream.close()
    ]);
  }

  static Future<bool> setOneAlarm({required AlarmModel alarmModel}) async {
    // for (final alarm in PeriodicAlarm.getAlarms()) {
    //   if (alarm.id == alarmModel.id ||
    //       (alarm.dateTime.day == alarmModel.dateTime.day &&
    //           alarm.dateTime.hour == alarmModel.dateTime.hour &&
    //           alarm.dateTime.minute == alarmModel.dateTime.minute)) {
    //     await PeriodicAlarm.stop(alarm.id);
    //   }
    // }

    await AlarmStorage.saveAlarm(alarmModel);
    //await AlarmNotification.instance.cancel(alarmModel.id);

    if (alarmModel.enableNotificationOnKill) {
      await AlarmNotification.instance.requestPermission();
    }

    return await AndroidAlarm.setOneAlarm(
        alarmModel, () => ringStream.add(alarmModel));
  }

  static Future<bool> setPeriodicAlarm({required AlarmModel alarmModel}) async {
    await AlarmStorage.saveAlarm(alarmModel);
    //await AlarmNotification.instance.cancel(alarmModel.id);

    if (alarmModel.enableNotificationOnKill) {
      await AlarmNotification.instance.requestPermission();
    }

    return await AndroidAlarm.setPeriodicAlarm(
        alarmModel, () => ringStream.add(alarmModel));
  }

  static Future<bool> stop(int id) async {
    //await AlarmStorage.unsaveAlarm(id);

    AlarmNotification.instance.cancel(id);

    return await AndroidAlarm.stop(id);
  }

  static Future<bool> cancelAlarm(int alarmId) async {
    bool isCanceledAlarm = await AndroidAlarm.cancelAlarm(alarmId);
    AlarmNotification.instance.cancel(alarmId);

    return isCanceledAlarm;
  }

  static void saveAlarm(AlarmModel alarmModel) {
    AlarmStorage.saveAlarm(alarmModel);
  }

  static Future<bool> deleteAlarm(int alarmId) async {
    bool isDeletedAlarm = await AlarmStorage.deleteAlarm(alarmId);

    return isDeletedAlarm;
  }

  static Future<bool> saveActiveAlarmStatu(int id, bool active) async {
    bool res = await AlarmStorage.alarmActiveChange(id, active);

    return res;
  }

  static Future<void> setNotificationOnAppKillContent(
    String title,
    String body,
  ) =>
      AlarmStorage.setNotificationContentOnAppKill(title, body);

  static bool hasAlarm() => AlarmStorage.hasAlarm();

  static List<AlarmModel> getAlarms() => AlarmStorage.getSavedAlarms();

  static AlarmModel? getAlarmWithId(int alarmId) =>
      AlarmStorage.getAlarm(alarmId);
}
