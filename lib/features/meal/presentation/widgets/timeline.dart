import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class HorizontalTimeline extends StatelessWidget {
  final List<bool> acceptedMeals;
  final List<bool> rejectedMeals;

  const HorizontalTimeline(
      {super.key, required this.acceptedMeals, required this.rejectedMeals});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(acceptedMeals.length, (index) {
          bool isFirst = index == 0;
          bool isLast = index == acceptedMeals.length - 1;
          bool isAccepted = acceptedMeals[index];
          bool isRejected = rejectedMeals[index];
          IconData iconData;
          Color iconColor;
          if (isAccepted) {
            iconData = Icons.check_circle;
            iconColor = Colors.green;
          } else if (isRejected) {
            iconData = Icons.cancel;
            iconColor = Colors.red;
          } else {
            iconData = Icons.circle;
            iconColor = Colors.black;
          }

          return SizedBox(
            width: 103,
            child: TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.center,
              isFirst: isFirst,
              isLast: isLast,
              indicatorStyle: IndicatorStyle(
                drawGap: true,
                color: Colors.white,
                iconStyle: IconStyle(
                  fontSize: 22,
                  iconData: iconData,
                  color: iconColor,
                ),
              ),
              beforeLineStyle: LineStyle(
                  color: isAccepted || isRejected ? iconColor : Colors.black,
                  thickness: 3),
              afterLineStyle: LineStyle(
                  color: isAccepted || isRejected ? iconColor : Colors.black,
                  thickness: 3),
            ),
          );
        }),
      ),
    );
  }
}
