import 'package:flutter/material.dart';
import 'package:prototype01/feedCam.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(22,149,163, 1),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            // Section 1 - Illustration
            Container(
              margin: EdgeInsets.only(top: 32),

              width: 350,
              height: 400,
              child: Image(
                image: AssetImage('assets/images/logo.png'),
              ),
            ),
            // Section 2 - kivk with Caption
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Text(
                    'DriveAlerto®',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 32,
                      fontFamily: 'poppins',
                    ),
                  ),
                ),

                Text(
                  'Driver Drowsiness Detection App',
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 18),
                  textAlign: TextAlign.center,
                ),

              ],
            ),
            // Section 3 - Get Started Button
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 16),
              margin: EdgeInsets.only(bottom: 16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FeedCam()));
                },
                child: Text(
                  'Get Started',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18, fontFamily: 'poppins'),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 36, vertical: 18), backgroundColor: Colors.pink,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
