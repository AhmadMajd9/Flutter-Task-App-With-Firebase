import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_task_planner_app/Model/task.dart';
import 'package:flutter_task_planner_app/provider/task_provider.dart';
import 'package:flutter_task_planner_app/theme/colors/light_colors.dart';
import 'package:flutter_task_planner_app/widgets/top_container.dart';
import 'package:flutter_task_planner_app/widgets/back_button.dart';
import 'package:flutter_task_planner_app/widgets/my_text_field.dart';
import 'package:flutter_task_planner_app/screens/home_page.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CreateNewTaskPage extends StatefulWidget {
  @override
  _CreateNewTaskPageState createState() => _CreateNewTaskPageState();
}

class _CreateNewTaskPageState extends State<CreateNewTaskPage> {
  TextEditingController titleControl = TextEditingController();
  TextEditingController dateControl = TextEditingController();
  TextEditingController descroptionControl = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _endTimeController = TextEditingController();

  double _height;
  double _width;

  String _setTime, _setDate;

  String _hour, _minute, _time;

  String dateTime;

  //*
  bool firstCategory = true;
  bool secCategory = false;
  bool therCategory = false;
  bool fourCategory = false;
  bool fiveCategory = false;

  // *

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  Chip custonChip(String label, bool isClick) {
    return Chip(
      label: Text(label),
      backgroundColor: isClick == true ? LightColors.kRed : Colors.grey[350],
      labelStyle: isClick == true
          ? TextStyle(color: Colors.white)
          : TextStyle(color: Colors.black),
    );
  }

  @override
  Widget build(BuildContext context) {
    _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate, // Refer step 1
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
      );
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
          dateControl.text = "${selectedDate.toLocal()}".split(' ')[0];
        });
    }

    Future<Null> _selectTime(
        BuildContext context, TextEditingController timer) async {
      final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );
      if (picked != null)
        setState(() {
          selectedTime = picked;
          _hour = selectedTime.hour.toString();
          _minute = selectedTime.minute.toString();
          _time = _hour + ' : ' + _minute;
          timer.text = _time;
          timer.text = formatDate(
              DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
              [hh, ':', nn, " ", am]).toString();
        });
    }

    Future<void> addTask(Task task) async {
      try {
        await Provider.of<TasksProvider>(context, listen: false).addTask(task);
      } catch (e) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error Occurred'),
                  content: Text('Somethong went wrong'),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Ok'))
                  ],
                ));
      }
    }

    double width = MediaQuery.of(context).size.width;
    var downwardIcon = Icon(
      Icons.keyboard_arrow_down,
      color: Colors.black54,
    );
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TopContainer(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
              width: width,
              child: Column(
                children: <Widget>[
                  MyBackButton(),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Create new task',
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      MyTextField(label: 'Title', control: titleControl),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: MyTextField(
                              label: 'Date',
                              icon: downwardIcon,
                              control: dateControl,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: CircleAvatar(
                              radius: 25.0,
                              backgroundColor: LightColors.kGreen,
                              child: Icon(
                                Icons.calendar_today,
                                size: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ))
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: MyTextField(
                          label: 'Start Time',
                          icon: null,
                          control: _startTimeController,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _selectTime(context, _startTimeController),
                        child: Icon(
                          Icons.timer_rounded,
                          size: 25.0,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 20),
                      //  onTap: () => _selectTime(context, _endTimeController),

                      Expanded(
                        child: MyTextField(
                          label: 'End Time',
                          icon: null,
                          control: _endTimeController,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _selectTime(context, _endTimeController),
                        child: Icon(
                          Icons.timer_rounded,
                          size: 25.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  MyTextField(
                    label: 'Description',
                    minLines: 3,
                    maxLines: 3,
                    control: descroptionControl,
                  ),
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Category',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          //direction: Axis.vertical,
                          alignment: WrapAlignment.start,
                          verticalDirection: VerticalDirection.down,
                          runSpacing: 0,
                          //textDirection: TextDirection.rtl,
                          spacing: 10.0,
                          children: <Widget>[
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    firstCategory = !firstCategory;
                                  });
                                },
                                child: custonChip("SPORT TASK", firstCategory)),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    secCategory = !secCategory;
                                  });
                                },
                                child: custonChip("MEDICAL TASK", secCategory)),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    therCategory = !therCategory;
                                  });
                                },
                                child: custonChip("RENT TASK", therCategory)),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    fourCategory = !fourCategory;
                                  });
                                },
                                child: custonChip("NOTES", fourCategory)),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    fiveCategory = !fiveCategory;
                                  });
                                },
                                child: custonChip(
                                    "GAMING PLATFORM TASK ", fiveCategory)),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
            Container(
              height: 80,
              width: width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => addTask(Task(
                        id: DateTime.now().toString(),
                        date: dateControl.text.toString(),
                        category: ["aa"],
                        descrition: descroptionControl.text.toString(),
                        title: titleControl.text.toString(),
                        taskStatus: TaskStatus.ioDo)),
                    child: Container(
                      child: Text(
                        'Create Task',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                      ),
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                      width: width - 40,
                      decoration: BoxDecoration(
                        color: LightColors.kBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
