import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wwa/helpers/colors.dart';
import 'package:wwa/helpers/constants.dart';
import 'package:wwa/widgets/wwa_elevation.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  _launchIG() async {
    const url = ig_url;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            image: Image.asset('assets/images/splash.png').image,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Image.asset('assets/images/Logo.png'),
              SvgPicture.asset('assets/images/logo.svg'),
              SizedBox(height: 10),
              Text(
                'WOMEN WORKOUT APP',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              WWAElevation(
                color: primaryColor,
                child: RaisedButton(
                  child: Text(
                    'START THE JOURNEY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99),
                  ),
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  color: primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/workout', //'/home',
                    );
                  },
                ),
              ),
              SizedBox(height: 30),
              InkWell(
                onTap: () {
                  _launchIG();
                },
                child: Text(
                  '@womenworkoutapp',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }
}
