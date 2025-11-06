import 'package:flutter/material.dart';
import 'package:tiktok_clone/College/view/screens/attendence_login_screen.dart';
import 'package:tiktok_clone/College/view/screens/webview_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class CollegeHomeScreen extends StatelessWidget {
  const CollegeHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DCRUST"),
      ),
      body:SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // College Banner
            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage(
                    "https://media.collegedekho.com/media/img/institute/crawled_images/None/TRYTRTYERWYERTY.jpg", // example image
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Welcome text
            const Text(
              "Welcome to DCRUST App",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 22),

            // Cards Section
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                featureCard(
                  context,
                  title: "College Website",
                  icon: Icons.language,
                  color: Colors.blueAccent,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const WebViewScreen(url: 'https://www.dcrustm.ac.in/'),),
                    );
                  },
                ),
                featureCard(
                  context,
                  title: "STUDENTS PORTAL",
                  icon: Icons.school_outlined,   //account_circle
                  color: Colors.green,
                  onTap: () async {
                final url = Uri.parse('https://www.dcrustedp.in/myexamlogin.php');
                await launchUrl(
                url,
                mode: LaunchMode.inAppBrowserView,
                );
                },
                ),
                featureCard(
                  context,
                  title: "Attendance",
                  icon: Icons.fact_check,
                  color: Colors.purple,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => AttendanceLoginScreen(),),
                    );
                  },
                ),
                featureCard(
                  context,
                  title: "Mess Bill Payment",
                  icon: Icons.payment,
                  color: Colors.teal,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const WebViewScreen(url: 'https://www.eduqfix.com/PayDirect/#/student'),),
                    );
                  },
                ),
                featureCard(
                  context,
                  title: "Exam Papers",
                  icon: Icons.menu_book,
                  color: Colors.yellowAccent,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const WebViewScreen(url: 'https://www.dcrustedp.in/dcrustpqp.php'),),
                    );
                  },
                ),
                featureCard(
                  context,
                  title: "Contact",
                  icon: Icons.contact_phone,
                  color: Colors.deepOrange,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const WebViewScreen(url: 'https://www.dcrustedp.in/about.php'),),
                    );
                  },
                ),
                featureCard(
                  context,
                  title: "Hostel Fee Payment",
                  icon: Icons.home_work,
                  color: Colors.orange,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const WebViewScreen(url: ''),),
                    );
                  },
                ),

                featureCard(
                  context,
                  title: "Time Table",
                  icon: Icons.calendar_month_outlined,
                  color: Colors.indigo,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const WebViewScreen(url: ''),),
                    );
                  },
                ),


              ],
            ),


          ],
        ),
      ),
    );
  }

  Widget featureCard(BuildContext context,
      {required String title,
        required IconData icon,
        required Color color,
        required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
