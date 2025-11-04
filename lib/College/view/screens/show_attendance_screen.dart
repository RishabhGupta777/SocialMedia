import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:tiktok_clone/College/controller/attendance_provider.dart';

class ShowAttendanceScreen extends StatefulWidget {
  final String username;
  final String password;

  const ShowAttendanceScreen({
    super.key,
    required this.username,
    required this.password,
  });

  @override
  State<ShowAttendanceScreen> createState() => _ShowAttendanceScreenState();
}

class _ShowAttendanceScreenState extends State<ShowAttendanceScreen> {
  List<dynamic> attendanceData = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://atchecker.dcrust.aruns.co.in/api/v2/attendance?tenant=dcrustm&username=${widget.username}&password=${widget.password}'));

      if (response.statusCode == 200) {
        setState(() {
          attendanceData = jsonDecode(response.body);
          isLoading = false;
        });
        // ✅ Save login only after successful fetch
        final provider =
        Provider.of<AttendanceProvider>(context, listen: false);
        await provider.saveLogin(widget.username, widget.password);
      } else {
        setState(() {
          isLoading = false;
          isError = true;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Summary"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () {
              final provider =
              Provider.of<AttendanceProvider>(context, listen: false);
              provider.logout();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isError
          ? const Center(
        child: Text("Failed to load attendance. Please try again."),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: attendanceData.length,
        itemBuilder: (context, index) {
          final course = attendanceData[index];
          final details = course['daily_details'] as List<dynamic>;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ExpansionTile(
              tilePadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              title: Text(
                course['course_name'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
               // "${course['course_code']}  |  Attendance: ${course['attendance']}",
                " Attendance: ${course['attendance']}"
              ),
              children: [
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: details.map((day) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text("${day['date']}  (${day['time']})"),
                        trailing: Container(
                          height: 28,
                          width:90,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: day['status'] == "PRESENT"
                                ? Colors.green.shade100
                                : Colors.red.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              day['status'],
                              style: TextStyle(
                                color: day['status'] == "PRESENT"
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
