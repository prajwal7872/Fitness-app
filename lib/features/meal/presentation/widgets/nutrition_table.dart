import 'package:flutter/material.dart';

class NutritionalTable extends StatelessWidget {
  final Map<String, String> nutritionalPlan;

  const NutritionalTable({super.key, required this.nutritionalPlan});

  @override
  Widget build(BuildContext context) {
    final keys = nutritionalPlan.keys.toList();
    final values = nutritionalPlan.values.toList();

    assert(keys.length == values.length);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          border: TableBorder.all(),
          children: List.generate(
            (keys.length / 2).ceil(),
            (index) {
              final keyIndex1 = index * 2;
              final keyIndex2 = keyIndex1 + 1;
              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      keys[keyIndex1],
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      values[keyIndex1],
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (keyIndex2 < keys.length) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        keys[keyIndex2],
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        values[keyIndex2],
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ] else ...[
                    const SizedBox.shrink(),
                    const SizedBox.shrink(),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
