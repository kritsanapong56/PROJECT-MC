import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_alarm_safealert/tool/color.dart';

class Addtime extends StatefulWidget {
  const Addtime({super.key});

  @override
  State<Addtime> createState() => _AddtimeState();
}

class _AddtimeState extends State<Addtime> {
  late Timer _timer;
  List<Map<String, int>> timeIntervals = [
    {'hours': 8, 'minutes': 0},
    {'hours': 12, 'minutes': 0},
    {'hours': 20, 'minutes': 0},
  ];
  @override
  void dispose() {
    _timer.cancel(); // ยกเลิกตัวจับเวลาเมื่อหน้าจอถูกปิด
    super.dispose();
  }

  void addTime(Map<String, int> newInterval) {
    setState(() {
      timeIntervals.add(newInterval);
    });
  }

  void removeTime(int index) {
    setState(() {
      timeIntervals.removeAt(index);
    });
  }

  void editTime(int index, Map<String, int> newInterval) {
    setState(() {
      timeIntervals[index] = newInterval;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.colorMain,
        title: new Text(
          "คุณต้องการรับแจ้งเตือนกี่โมง",
          style: TextStyle(
              fontSize: 25,
              color: Colors.black,
              fontFamily: 'SukhumvitSet-Bold'),
        ),
        leading: IconButton(
          icon: ImageIcon(
            AssetImage("assets/images/arrow_left.png"),
            size: 40,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // แสดงรายการช่วงเวลา
          for (int i = 0; i < timeIntervals.length; i++)
            ListTile(
              title: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black), // Add border styling
                  borderRadius: BorderRadius.all(
                      Radius.circular(10.0)), // Optional: Add border radius
                ),
                padding: EdgeInsets.all(10), // Optional: Add padding
                child: Text(
                  '${timeIntervals[i]['hours']} : ${timeIntervals[i]['minutes']} นาที',
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.black,
                    fontFamily: 'SukhumvitSet-Bold',
                  ),
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.black), // Add border styling
                      borderRadius: BorderRadius.all(
                          Radius.circular(10.0)), // Optional: Add border radius
                    ),
                    padding: EdgeInsets.all(10), // Optional: Add padding
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // แก้ไขเวลา
                        showEditDialog(context, i);
                      },
                    ),
                  ),
                  SizedBox(width: 10), // Optional: Add spacing between icons
                  Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.black), // Add border styling
                      borderRadius: BorderRadius.all(
                          Radius.circular(10.0)), // Optional: Add border radius
                    ),
                    padding: EdgeInsets.all(10), // Optional: Add padding
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // ลบเวลา
                        removeTime(i);
                      },
                    ),
                  ),
                ],
              ),
            ),

          // เพิ่มเวลา
          // Inside the Column widget
Column(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
    // ... other widgets

    // Add Padding to create space
    Padding(
      padding: EdgeInsets.only(top: 20),
      child: ElevatedButton(
        onPressed: () {
          // showAddDialog(context);
        },
        child: Text(
          'เพิ่มเวลา',
          style: TextStyle(fontSize: 20),
        ),
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
          // Add other styling properties as needed
        ),
      ),
    ),
  ],
),

// ... rest of the code

        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 60,
        margin: const EdgeInsets.all(20),
        child: Row(
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
                      EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                    ),
                    shape: MaterialStateProperty.resolveWith(
                        (states) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            )),
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => AppColors.colorMain),
                    elevation: MaterialStateProperty.resolveWith<double>(
                      (Set<MaterialState> states) {
                        return 2.0;
                      },
                    ),
                  ),
                  onPressed: () {
                    // Navigator.push(context,
                    //     CupertinoPageRoute(builder: (context) {
                    //       return MainMenu();
                    //     }));
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: const Text(
                          "ย้อนกลับ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontFamily: 'SukhumvitSet-Bold'),
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
                      const EdgeInsets.only(
                          left: 5, right: 5, top: 10, bottom: 10),
                    ),
                    shape: MaterialStateProperty.resolveWith(
                        (states) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            )),
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => AppColors.colorMain),
                    elevation: MaterialStateProperty.resolveWith<double>(
                      (Set<MaterialState> states) {
                        return 2.0;
                      },
                    ),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: const Text(
                          "ถัดไป",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontFamily: 'SukhumvitSet-Bold'),
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

  // แสดงไดอะล็อกสำหรับเพิ่มเวลา
  void showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Map<String, int> newInterval = {'hours': 0, 'minutes': 0};
        return AlertDialog(
          title: Text('เพิ่มเวลา'),
          content: Column(
            children: [
              Text('เลือกเวลาที่ต้องการแจ้งเตือน:'),
              DropdownButton<int>(
                value: newInterval['hours'],
                onChanged: (int? value) {
                  setState(() {
                    newInterval['hours'] = value!;
                  });
                },
                items: List.generate(24, (index) => index + 1)
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value ชั่วโมง'),
                  );
                }).toList(),
              ),
              Text('เลือกจำนวนนาที:'),
              DropdownButton<int>(
                value: newInterval['minutes'],
                onChanged: (int? value) {
                  setState(() {
                    newInterval['minutes'] = value!;
                  });
                },
                items: List.generate(60, (index) => index)
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value นาที'),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                addTime(newInterval);
                Navigator.pop(context);
              },
              child: Text('เพิ่ม'),
            ),
          ],
        );
      },
    );
  }

  // แสดงไดอะล็อกสำหรับแก้ไขเวลา
  void showEditDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Map<String, int> editedInterval = Map.from(timeIntervals[index]);
        return AlertDialog(
          title: Text('แก้ไขเวลาแจ้งเตือน'),
          content: Column(
            children: [
              Text('เลือกเวลาแจ้งเตือน:'),
              DropdownButton<int>(
                value: editedInterval['hours'],
                onChanged: (int? value) {
                  setState(() {
                    editedInterval['hours'] = value!;
                  });
                },
                items: List.generate(24, (index) => index + 1)
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value นาฬิกา'),
                  );
                }).toList(),
              ),
              Text('นาที:'),
              DropdownButton<int>(
                value: editedInterval['minutes'],
                onChanged: (int? value) {
                  setState(() {
                    editedInterval['minutes'] = value!;
                  });
                },
                items: List.generate(60, (index) => index)
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value นาที'),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                editTime(index, editedInterval);
                Navigator.pop(context);
              },
              child: Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }
}
