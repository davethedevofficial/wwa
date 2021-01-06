import 'package:flutter/material.dart';
import 'package:wwa/helpers/colors.dart';

class WWAStepper extends StatelessWidget {
  final int steps;
  final int currentStep;
  final Function onSelected;

  WWAStepper(
      {Key key,
      @required this.steps,
      this.currentStep = 0,
      @required this.onSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var step = 0; step < this.steps - 1; step++)
              Expanded(
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color:
                        step < (this.currentStep) ? primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var step = 0; step < this.steps; step++)
              InkWell(
                onTap: () {
                  onSelected(step);
                },
                child: Container(
                  width: 20,
                  height: 20,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color:
                        (this.currentStep) < step ? Colors.white : primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: step < (this.currentStep)
                      ? Container()
                      : Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                ),
              )
          ],
        ),
      ],
    );
  }
}
