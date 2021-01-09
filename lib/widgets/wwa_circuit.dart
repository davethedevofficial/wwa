import 'package:flutter/material.dart';
import 'package:wwa/helpers/colors.dart';
import 'package:wwa/models/circuit.dart';
import 'package:wwa/models/exercise.dart';

class WWACircuit extends StatefulWidget {
  final String title;
  final Circuit circuit;

  const WWACircuit({Key key, this.title, this.circuit}) : super(key: key);
  @override
  _WWACircuitState createState() => _WWACircuitState();
}

class _WWACircuitState extends State<WWACircuit> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Stack(
        overflow: Overflow.visible,
        children: [
          Positioned(
            top: 0,
            left: -12.5,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Color.fromRGBO(22, 24, 26, 1),
                border: Border.all(
                  color: primaryColor,
                  width: 5,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withAlpha(120),
                    height: 1.1,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: widget.circuit.exercises
                        .map(
                          (Exercise e) => Container(
                            width: 200,
                            height: 140,
                            margin: EdgeInsets.only(right: 30),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                alignment: Alignment.center,
                                image: AssetImage(e.thumbnailPath),
                              ),
                            ),
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  margin: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(22, 24, 26, 1),
                                      borderRadius: BorderRadius.circular(99),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(200),
                                          offset: Offset(0.0, 11.0), //(x,y)
                                          blurRadius: 20.0,
                                        ),
                                      ]),
                                  child: Text(
                                    e.name,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )),
                          ),
                        )
                        .toList(),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
