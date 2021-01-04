import 'package:flutter/material.dart';
import 'package:wwa/helpers/colors.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(22, 24, 26, 1),
              Color.fromRGBO(34, 36, 44, 1),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '20',
                        style: TextStyle(color: Colors.white, fontSize: 48),
                      ),
                      SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 5,
                            width: 180,
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 5,
                              width: 99,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: progressBgColor,
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'of 40 Days, you got this!',
                            style: TextStyle(
                                color: Colors.white.withAlpha(80),
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
