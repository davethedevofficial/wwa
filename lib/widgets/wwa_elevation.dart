import 'package:flutter/material.dart';

class WWAElevation extends StatelessWidget {
  final Widget child;
  final Color color;

  WWAElevation({@required this.child, @required this.color})
      : assert(child != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 30,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: this.child,
    );
  }
}
