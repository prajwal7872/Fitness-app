import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import 'package:loginpage/sign_up/models/question.dart';
import 'package:loginpage/sign_up/widgets/custom_accordion_section.dart';

class AccordionWidget extends StatefulWidget {
  final List<Question> questions;
  final Map<int, String?> selectedAnswers;
  final ValueChanged<MapEntry<int, String?>> onChanged;
  final PageController pageController;
  const AccordionWidget({
    super.key,
    required this.questions,
    required this.selectedAnswers,
    required this.onChanged,
    required this.pageController,
  });

  @override
  State<AccordionWidget> createState() => _AccordionWidgetState();
}

class _AccordionWidgetState extends State<AccordionWidget> {
  int _openSectionIndex = 0;

  void _showValidationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Something Went Wrong',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Please answer all questions before proceeding.',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool _validateAnswers() {
    for (int i = 0; i < widget.questions.length; i++) {
      if (widget.selectedAnswers[i] == null) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Accordion(
      children: widget.questions.asMap().entries.map((entry) {
        int index = entry.key;
        Question questionData = entry.value;

        Color contentBgColor;
        Color headerBgColor;
        switch (index % 6) {
          case 0:
            contentBgColor = const Color.fromARGB(31, 228, 186, 235);
            headerBgColor = const Color.fromARGB(255, 208, 230, 249);
            break;
          case 1:
            contentBgColor = Colors.transparent;
            headerBgColor = const Color.fromARGB(255, 251, 236, 97);
            break;
          case 2:
            contentBgColor = Colors.transparent;
            headerBgColor = Colors.lightBlueAccent;
            break;
          case 3:
            contentBgColor = Colors.transparent;
            headerBgColor = const Color.fromARGB(255, 235, 106, 149);
            break;
          case 4:
            contentBgColor = Colors.transparent;
            headerBgColor = Colors.greenAccent;
          default:
            contentBgColor = Colors.transparent;
            headerBgColor = const Color.fromARGB(255, 237, 172, 75);
            break;
        }

        return CustomAccordionSection(
          isOpen: _openSectionIndex == index,
          contentBackgroundColor: contentBgColor,
          headerBackgroundColor: headerBgColor,
          question: questionData.question,
          answers: questionData.answers,
          selectedAnswer: widget.selectedAnswers[index],
          onChanged: (String? value) {
            setState(() {
              widget.onChanged(MapEntry(index, value));
              if (index < widget.questions.length - 1) {
                _openSectionIndex = index + 1;
              } else {
                if (_validateAnswers()) {
                  widget.pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  _showValidationDialog();
                }
              }
            });
          },
        );
      }).toList(),
    );
  }
}
