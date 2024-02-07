import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class alert_alarm_medicine extends StatefulWidget {

  final alert_id;
  final medicine_name;
  final msg_time_alarm;
  final msg_num_alarm;
  final img_medicine;

  const alert_alarm_medicine(this.alert_id,this.img_medicine,this.msg_time_alarm, this.msg_num_alarm,this.medicine_name , {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _alert_alarm_medicineState();
}

class _alert_alarm_medicineState extends State<alert_alarm_medicine> {
  // this variable holds the selected items
  String _selectedItems = "";
  TextEditingController txtRemarkAnother = TextEditingController();

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems = itemValue;
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFF2F2F3),
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      titlePadding: EdgeInsets.zero,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Container(
          //   padding: EdgeInsets.only(left: 5),
          //   alignment: Alignment.centerRight,
          //   child: IconButton(
          //     icon: ImageIcon(
          //       AssetImage("assets/images/trash.png"),
          //       size:30,
          //       color: Colors.black,
          //     ),
          //     onPressed: () {
          //       Navigator.pop(context,"delete");
          //     },
          //   ),
          // ),
          Container(
            padding: EdgeInsets.only(right: 5),
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(
                Icons.edit,
                size:30,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context,"edit");
              },
            ),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(0
          ),
        ),
      ),
      content: Builder(
        builder: (context) {
          // Get available height and width of the build area of this widget. Make a choice depending on the size.
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;

          return Container(
            width: width-50,
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                                padding: EdgeInsets.all(20),
                                color:Colors.white,
                                child: Column(
                                  children: [
                                    // Image(
                                    //   image: AssetImage('assets/images/pills.png'),
                                    //   height: 50,
                                    //   width: 50,
                                    // ),
                                    widget.img_medicine != null && widget.img_medicine.isNotEmpty ?
                                    Image.network(widget.img_medicine,width: 50, height: 50,) :
                                    const ImageIcon(
                                      AssetImage("assets/images/pills.png"),
                                      size: 50,
                                      color: Colors.black,),
                                    const SizedBox(height: 10,),
                                    Text(
                                      widget.medicine_name,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 25,
                                          fontFamily:
                                          'SukhumvitSet-Bold'),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 10,right: 10),
                                      alignment: Alignment.center,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 10,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              const Image(
                                                image: AssetImage('assets/images/calendar_days.png'),
                                                height: 20,
                                                width: 20,
                                              ),
                                              const SizedBox(width: 10,),
                                              Text(
                                                widget.msg_time_alarm,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontFamily:
                                                    'SukhumvitSet-Bold'),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              const Image(
                                                image: AssetImage('assets/images/medicine.png'),
                                                height: 20,
                                                width: 20,
                                              ),
                                              const SizedBox(width: 10,),
                                              Text(
                                                widget.msg_num_alarm,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontFamily:
                                                    'SukhumvitSet-Bold'),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20,),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 10,top: 20,right: 10,bottom: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [

                                    InkWell(
                                      onTap: (){
                                        _selectedItems = "skip";
                                        _submit();
                                      },
                                      child: const Column(
                                        children: [
                                          Image(
                                            image: AssetImage('assets/images/cross_circle.png'),
                                            height: 50,
                                            width: 50,
                                          ),
                                          SizedBox(height: 5,),
                                          Text(
                                            "ข้าม",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontFamily:
                                                'SukhumvitSet-Bold'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: (){
                                        _selectedItems = "stop";
                                        _submit();
                                      },
                                      child: const Column(
                                        children: [
                                          Image(
                                            image: AssetImage('assets/images/check.png'),
                                            height: 50,
                                            width: 50,
                                          ),
                                          SizedBox(height: 5,),
                                          Text(
                                            "รับ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontFamily:
                                                'SukhumvitSet-Bold'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: (){
                                        _selectedItems = "snooze";
                                        _submit();
                                      },
                                      child: const Column(
                                                      children: [
                                                        Image(
                                                          image: AssetImage('assets/images/alarm_clock.png'),
                                                          height: 50,
                                                          width: 50,
                                                        ),
                                                        SizedBox(height: 5,),
                                                        Text(
                                                          "เลื่อนเวลาทาน",
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 18,
                                                              fontFamily:
                                                              'SukhumvitSet-Bold'),
                                                        ),
                                                      ],
                                                    ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ),
          );
        },
      ),

    );
  }
}
