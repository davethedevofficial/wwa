import 'package:flutter/material.dart';
import 'package:wwa/helpers/colors.dart';
import 'package:wwa/widgets/wwa_circle_loader_painter.dart';
import 'package:wwa/models/exercise.dart';

class WWAList extends StatelessWidget {
  final List<Exercise> items;
  final int currentItem;
  final Function onSelected;

  const WWAList(
      {Key key,
      @required this.items,
      this.currentItem = 0,
      @required this.onSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 0, right: 10.0, bottom: 10.0, left: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var item = 0; item < this.items.length; item++)
            InkWell(
              onTap: () {
                onSelected(item);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: item == currentItem
                        ? primaryColor
                        : Colors.white.withAlpha(70),
                    width: 3.0,
                  ),
                )),
                child: Wrap(
                  direction: Axis.horizontal,
                  children: [
                    Text(
                      items[item].name,
                      style: TextStyle(
                          color: item == currentItem
                              ? Colors.white
                              : Colors.white.withAlpha(70),
                          fontWeight: FontWeight.bold,
                          fontSize: item == currentItem ? 18 : 16),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      width: 15,
                      height: 15,
                      margin: EdgeInsets.only(top: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(120),
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              width: double.maxFinite,
                              height: double.maxFinite,
                              color: Colors.transparent,
                              child: CustomPaint(
                                painter: WWACircleLoaderPainter(
                                    items[item].completed == 0
                                        ? 0
                                        : (items[item].completed == 1
                                            ? 0.5
                                            : 1),
                                    clockwise: true,
                                    filled: true,
                                    exact: true),
                              ),
                            ),
                          ),
                          Center(
                            child: items[item].completed == 2
                                ? Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 14,
                                  )
                                : Container(),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
