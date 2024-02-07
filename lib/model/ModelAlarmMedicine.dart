import '../tool/api.dart';
import '../../tool/url.dart';

class ModelAlarmMedicine {
  final String alarm_id;
  final String medicine_name;
  final String msg_num_medicine;
  final String set_time_alarm;
  final String start_date_alarm;
  final String img_medicine;
  final String msg_skip;

  ModelAlarmMedicine({
    required this.alarm_id,
    required this.medicine_name,
    required this.msg_num_medicine,
    required this.set_time_alarm,
    required this.start_date_alarm,
    required this.img_medicine,
    required this.msg_skip,
  });

  factory ModelAlarmMedicine.fromMap(Map<String, dynamic> json) => ModelAlarmMedicine(
        alarm_id: json["alarm_id"],
        medicine_name: json["medicine_name"],
        msg_num_medicine: json["msg_num_medicine"],
        set_time_alarm: json["set_time_alarm"],
        start_date_alarm: json["start_date_alarm"],
        img_medicine: json["img_medicine"],
        msg_skip: json["msg_skip"],
      );

  Map<String, dynamic> toJson() => {
        'alarm_id': alarm_id,
        'medicine_name': medicine_name,
        'msg_num_medicine': msg_num_medicine,
        'set_time_alarm': set_time_alarm,
        'start_date_alarm': start_date_alarm,
        'img_medicine': img_medicine,
        'msg_skip': msg_skip,
      };

  static getMedicineToDay(dateMedicine) async {
    Map<String, dynamic> data = {"register_id": AppUrl.RegisterID, "date_medicine": dateMedicine};
    final response = await AppApi.post_Json(AppUrl.get_medicine_today, data); // เรียกใช้ api
    return response;
  }
}
