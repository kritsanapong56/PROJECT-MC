import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import '../../model/ModelRegister.dart';
import '../../tool/color.dart'; 
import '../../tool/pref.dart';
import '../../tool/url.dart';
import '../../ui/medicine/AddMedicine.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dialog/gender_select.dart';

class AddProfile extends StatefulWidget {
  @override
  _AddProfileState createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
  int _counter = 10;
  var _stxtHBD = "";
  TextEditingController txtName = TextEditingController();
  TextEditingController txtHBD = TextEditingController();
  TextEditingController txtGender = TextEditingController();

  @override
  initState() {
    loadDataRegister();
    super.initState();
    // new Timer(const Duration(seconds: 0), onClose);
  }

  void loadDataRegister() async {
    final list = await ModelRegister.getData();
    setState((){
      AppUrl.objRegister = ModelRegister.fromJson(list);
      txtName.text = AppUrl.objRegister.name;
      txtGender.text = AppUrl.objRegister.gender_name;

      if(AppUrl.objRegister.date_of_birth.toString() != "0000-00-00"){
        txtHBD.text = DateFormat('dd/MM/yyyy').format(DateTime.parse(AppUrl.objRegister.date_of_birth));
      }
    });
  }
  void _showGenderSelect() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API

    List<String> gender = ["ชาย","หญิง"];

    final String? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return gender_select(items: gender,defaults : txtGender.text);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        txtGender.text = results.toString();
      });
    }
  }
  void dateHBD(BuildContext context) {
    FocusScopeNode currentFocus =
    FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    Timer(const Duration(milliseconds: 400), ()
    {
      int yearCurrent = DateTime.now().year + 1;
      showRoundedDatePicker(
        borderRadius: 25,
        styleDatePicker: MaterialRoundedDatePickerStyle(
          textStyleDayHeader: const TextStyle(fontFamily: 'SukhumvitSet-Bold',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.color_grey
          ),
          textStyleDayOnCalendar: const TextStyle(fontFamily: 'SukhumvitSet-Bold',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.color_grey
          ),
          paddingMonthHeader: EdgeInsets.all(10),
          sizeArrow: 40,
          colorArrowPrevious: AppColors.colorMain,
          colorArrowNext: AppColors.colorMain,
          textStyleMonthYearHeader:const TextStyle(fontFamily: 'SukhumvitSet-Bold',
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color:Colors.black),
          textStyleButtonPositive: TextStyle(fontFamily: 'SukhumvitSet-Bold',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color:AppColors.color_grey),
          textStyleButtonNegative: TextStyle(fontFamily: 'SukhumvitSet-Bold',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color:AppColors.color_grey),
        ),
        theme: ThemeData(
          primaryColor: AppColors.colorMain,
          hintColor: AppColors.colorMain,
          textTheme: TextTheme(
            caption: TextStyle(fontFamily: 'SukhumvitSet-Bold',
                fontWeight: FontWeight.w500,
                color:AppColors.color_grey),
          ),
        ),
        // era: EraMode.BUDDHIST_YEAR,
        context: context,
        height: 330,
        fontFamily: 'SukhumvitSet-Bold',
        // locale: const Locale("th"),
        initialDate: DateTime.now(),
        firstDate: DateTime(1850),
        lastDate: DateTime(yearCurrent),
      ).then((date) {
        setState(() {
          _stxtHBD = DateFormat('yyyy-MM-dd').format(date!);
          var strDay = DateFormat('dd/MM/yyyy').format(date!);
          txtHBD.text = strDay;

          FocusScopeNode currentFocus =
          FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
        leadingWidth: 0,
        leading: Container(),
        actions: [
          IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.black,
              size: 40,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),

      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        margin: EdgeInsets.only(top: 30.0),
        child: ListView(
            children: [
              Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset("assets/images/profile.png",width: 100,height: 100,),
                          new Text(AppUrl.objRegister.name.toString().isNotEmpty ? AppUrl.objRegister.name : "ชื่อ - สกุล",style: const TextStyle(
                              fontFamily: 'SukhumvitSet-Bold',
                          fontSize: 20),
                          textAlign: TextAlign.center,),
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
                                        margin: const EdgeInsets.only(top: 20,left: 10,right: 10),
                                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                        width: double.maxFinite,
                                        child: TextField(
                                          controller: txtName,
                                          enabled: true,
                                          style: const TextStyle(
                                              fontSize: 25.0,
                                              fontFamily: 'SukhumvitSet-Bold',
                                              color: Colors.black),
                                          decoration: new InputDecoration(
                                              contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10.0, horizontal: 15),
                                              //ปรับตำแหน่งcursor เริ่มต้นในช่องข้อความ
                                              border: new OutlineInputBorder(
                                                  borderRadius:
                                                  const BorderRadius.all(
                                                    const Radius.circular(20.0),
                                                  ),
                                                  borderSide: BorderSide(
                                                      width: 0,
                                                      style: BorderStyle.none)),
                                              filled: true,
                                              hintText: "ชื่อ : ชื่อ-นามสกุล",
                                              hintStyle: new TextStyle(
                                                  fontFamily: 'SukhumvitSet-Medium',
                                                  color: Colors.grey[800]),
                                              fillColor:AppColors.bgColor),
                                          // fillColor: Colors.white70),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),

                          //ปฏิธิน

                          Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Expanded(
                                  flex: 10,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [  Container(
                                          margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                                          padding: EdgeInsets.only(left: 15.0, right: 15.0),
                                          width: double.maxFinite,
                                          child: TextField(
                                            onTap: (){
                                              dateHBD(context);
                                            },
                                            controller: txtHBD,
                                            readOnly: true,
                                            style: TextStyle(
                                                fontSize: 25.0,
                                                fontFamily: 'SukhumvitSet-Bold',
                                                color: Colors.black),
                                            decoration: new InputDecoration(
                                                contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10.0, horizontal: 15),
                                                //ปรับตำแหน่งcursor เริ่มต้นในช่องข้อความ
                                                border: new OutlineInputBorder(
                                                    borderRadius:
                                                    const BorderRadius.all(
                                                      const Radius.circular(20.0),
                                                    ),
                                                    borderSide: BorderSide(
                                                        width: 0,
                                                        style: BorderStyle.none)),
                                                filled: true,
                                                hintText: "วันเกิด : วว/ดด/ปป",
                                                hintStyle: new TextStyle(
                                                    fontFamily: 'SukhumvitSet-Medium',
                                                    color: Colors.grey[800]),
                                                fillColor:AppColors.bgColor),
                                            // fillColor: Colors.white70),
                                          ),
                                        ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          // Container(
                          //   child: Row(
                          //     mainAxisSize: MainAxisSize.max,
                          //     children: <Widget>[
                          //       Expanded(
                          //         flex: 10,
                          //         child: Column(
                          //           crossAxisAlignment: CrossAxisAlignment.center,
                          //           children: [
                          //             Container(
                          //                 margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                          //                 padding: EdgeInsets.only(left: 15.0, right: 15.0),
                          //                 width: double.maxFinite,
                          //                 child: TextField(
                          //                   onTap: (){
                          //                     _showGenderSelect();
                          //                   },
                          //                   controller: txtGender,
                          //                   readOnly: true,
                          //                   style: TextStyle(
                          //                       fontSize: 25.0,
                          //                       fontFamily: 'SukhumvitSet-Bold',
                          //                       color: Colors.black),
                          //                   decoration: new InputDecoration(
                          //                       contentPadding:
                          //                       const EdgeInsets.symmetric(
                          //                           vertical: 10.0, horizontal: 15),
                          //                       //ปรับตำแหน่งcursor เริ่มต้นในช่องข้อความ
                          //                       border: new OutlineInputBorder(
                          //                           borderRadius:
                          //                           const BorderRadius.all(
                          //                             const Radius.circular(20.0),
                          //                           ),
                          //                           borderSide: BorderSide(
                          //                               width: 0,
                          //                               style: BorderStyle.none)),
                          //                       filled: true,
                          //                       hintText: "เพศ :",
                          //                       hintStyle: new TextStyle(
                          //                           fontFamily: 'SukhumvitSet-Medium',
                          //                           color: Colors.grey[800]),
                          //                       fillColor:AppColors.bgColor),
                          //                   // fillColor: Colors.white70),
                          //                 ),
                          //               ),
                          //           ],
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ]),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerFloat,
    floatingActionButton: Visibility(
    visible: !keyboardIsOpen,
    child: Container(
        height: 60,
        margin: const EdgeInsets.all(20),
        child:  Row(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(left: 5),
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
                    Map<String, dynamic> data = {
                      "register_id": AppUrl.RegisterID,
                      "date_hbd":_stxtHBD,
                      "gender":txtGender.text,
                      "name":txtName.text
                    };
                    ModelRegister.updateData(context,data);
                  },
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          "ตกลง",
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
    )
    );
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
  try{
    String? register_id = prefs.getString('register_id');
    AppUrl.RegisterID = register_id!;
  } catch (e) {
    print(e);
  }
}

