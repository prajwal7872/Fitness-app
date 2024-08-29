import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelineIndicator extends StatelessWidget {
  final int index;
  final bool isActive;
  final bool isFirst;
  final bool isLast;

  const TimelineIndicator({
    super.key,
    required this.index,
    required this.isActive,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      axis: TimelineAxis.horizontal,
      alignment: TimelineAlign.center,
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        drawGap: true,
        color: Colors.white,
        iconStyle: IconStyle(
          fontSize: 22,
          iconData: isActive ? Icons.check_circle : Icons.circle,
          color: isActive ? Colors.green : Colors.black,
        ),
      ),
      beforeLineStyle: LineStyle(
        color: isActive ? Colors.green : Colors.black,
        thickness: 3,
      ),
      afterLineStyle: LineStyle(
        color: isActive ? Colors.green : Colors.black,
        thickness: 3,
      ),
    );
  }
}
