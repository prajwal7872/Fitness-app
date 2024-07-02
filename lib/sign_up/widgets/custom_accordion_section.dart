import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';

class CustomAccordionSection extends AccordionSection {
  final Color contentBackgroundColor;
  final Color headerBackgroundColor;
  final String question;
  final List<String> answers;
  final String? selectedAnswer;
  final ValueChanged<String?> onChanged;

  CustomAccordionSection({
    super.key,
    required super.isOpen,
    required this.contentBackgroundColor,
    required this.headerBackgroundColor,
    required this.question,
    required this.answers,
    required this.selectedAnswer,
    required this.onChanged,
  }) : super(
          header: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              question,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ),
          content: Column(
            children: answers.map((answer) {
              return ListTile(
                title: Text(answer),
                leading: Radio<String>(
                  value: answer,
                  groupValue: selectedAnswer,
                  onChanged: onChanged,
                ),
              );
            }).toList(),
          ),
        );
}
