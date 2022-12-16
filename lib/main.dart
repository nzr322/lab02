import 'package:flutter/material.dart';
import 'data.dart';

void main() {
  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}

class Subjects {
  Subjects(this.subjects);
  Map<int, String> subjects;
}

class Schedule {
  Schedule(Map<String, Map<int, String>> scheduleRaw) {
    scheduleRaw.forEach((key, value) => dayToSubjects[key] = Subjects(value));
  }
  Map<String, Subjects> dayToSubjects = {};
}

class ScheduleData {
  ScheduleData() {
    groupToSchedule = {};
    dataRaw.forEach((key, value) => groupToSchedule[key] = Schedule(value));
  }
  Map<String, Schedule> groupToSchedule = {};

  List<String> getGroupsNames() {
    return groupToSchedule.keys.toList();
  }

  Schedule getScheduleForGroup(String? groupName) {
    return groupToSchedule[groupName]!;
  }

  String getDayName(int dayIndex) {
    switch (dayIndex) {
      case 0:
        return "Понеділок";
      case 1:
        return "Вівторок";
      case 2:
        return "Середа";
      case 3:
        return "Четвер";
      case 4:
        return "П'ятниця";
      case 5:
        return "Субота";
      default:
    }
    return '';
  }
}

class Home extends StatelessWidget {
  String? selectedGroup;
  Home({required this.selectedGroup});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    ScheduleData scheduleData = ScheduleData();
    Schedule schedule = scheduleData.getScheduleForGroup(selectedGroup);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: const Text('Розклад'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(children: [
          Expanded(
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) {
                  String dayName = scheduleData.getDayName(index);
                  List<List<String>> subjects = [];
                  schedule.dayToSubjects[dayName]?.subjects.forEach(
                          (key, value) => subjects.add([key.toString(), value]));

                  return ExpansionTile(
                      title: Text(dayName),
                      children: subjects
                          .map((value) =>
                          ListTile(title: Text(value[0] + '. ' + value[1])))
                          .toList());
                },
                separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
              ))
        ]),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginDemo(),
    );
  }
}

class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  String userName = '';
  ScheduleData scheduleData = ScheduleData();
  late List<String> groups = scheduleData.getGroupsNames();
  String? selectedGroup;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    child: Image.asset('images/logo.png')),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Login',
                    hintText: 'Enter valid login'),
                onChanged: (text) {
                  userName = text;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomePage(userName: userName)));
              },
              child: Container(
                  alignment: Alignment.center,
                  width: 250,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFF8A2387),
                            Color(0xFFE94057),
                            Color(0xFFF27121),
                          ])),
                  child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ))),
            ),
            Container(
              alignment: Alignment.center,
              height: 25,
              width: 225,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child:
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ]),
            ),
            SizedBox(
              height: 130,
            ),
            Text('New User? Create Account')
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  String userName;
  HomePage({required this.userName});
  ScheduleData scheduleData = ScheduleData();
  late List<String> groups = scheduleData.getGroupsNames();
  String? selectedGroup;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Оберіть групу')),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(15.0),
                child: DropdownButton<String>(
                    value: selectedGroup,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: groups
                        .map((group) => DropdownMenuItem(
                      value: group,
                      child: Text(group),
                    ))
                        .toList(),
                    onChanged: (String? newGroup) {
                      selectedGroup = newGroup;
                    }),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            Home(selectedGroup: selectedGroup)));
                  },
                  child: Text('Продовжити'))
            ],
          ),
        ),
      ),
    );
  }
}