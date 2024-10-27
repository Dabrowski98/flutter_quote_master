import 'package:flutter/material.dart';
import 'package:flutter_quote_master/core/widgets/tile.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int reminders = 1;
  String startTime = '9:00';
  String endTime = '17:00';

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    const emptyPageTextStyle = TextStyle(
      height: 1.6,
      color: Color.fromARGB(255, 72, 72, 72),
      fontSize: 24,
    );

    const emptyPageTextStyleBig = TextStyle(
      height: 3,
      color: Color.fromARGB(255, 72, 72, 72),
      fontSize: 32,
      fontWeight: FontWeight.w500,
    );

    return Container(
      margin: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(4.0),
            height: 48,
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                  style: const TextStyle(
                    color: Color.fromARGB(255, 48, 48, 48),
                    fontSize: 24,
                  ),
                  children: getStyledTitle("Notifications")),
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            "Set up how many times you want to get motivated every day.",
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 48, 48, 48),
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "How many",
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 48, 48, 48),
                ),
              ),
              IconButton(
                onPressed: reminders > 1
                    ? () {
                        setState(() {
                          reminders--;
                        });
                      }
                    : null,
                icon: const Icon(Icons.remove),
                color: reminders > 1 ? Colors.black : Colors.grey,
              ),
              Text(
                '$reminders',
                style: const TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 48, 48, 48),
                ),
              ),
              IconButton(
                onPressed: reminders < 5
                    ? () {
                        setState(() {
                          reminders++;
                        });
                      }
                    : null,
                icon: const Icon(Icons.add),
                color: reminders < 5 ? Colors.black : Colors.grey,
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Text(
                    "Start at",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 48, 48, 48),
                    ),
                  ),
                  DropdownButton<String>(
                    value: startTime,
                    items: _getTimeDropdownItems(),
                    onChanged: (String? newValue) {
                      setState(() {
                        startTime = newValue!;
                      });
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  const Text(
                    "End at",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 48, 48, 48),
                    ),
                  ),
                  DropdownButton<String>(
                    value: endTime,
                    items: _getTimeDropdownItems(),
                    onChanged: (String? newValue) {
                      setState(() {
                        endTime = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              DayCheckbox(dayOfTheWeek: "M"),
              DayCheckbox(dayOfTheWeek: "T"),
              DayCheckbox(dayOfTheWeek: "W"),
              DayCheckbox(dayOfTheWeek: "T"),
              DayCheckbox(dayOfTheWeek: "F"),
              DayCheckbox(dayOfTheWeek: "S"),
              DayCheckbox(dayOfTheWeek: "S")
            ],
          )
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _getTimeDropdownItems() {
    List<String> times = [
      '9:00',
      '10:00',
      '11:00',
      '12:00',
      '13:00',
      '14:00',
      '15:00',
      '16:00',
      '17:00',
      '18:00',
      '19:00',
      '20:00',
      '21:00',
      '22:00',
    ];
    return times.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  List<TextSpan> getStyledTitle(String titleOfThePage) {
    List<String> words = titleOfThePage.split(" ");
    List<TextSpan> result = [];

    for (var word in words) {
      result.add(TextSpan(
        text: word[0],
        style: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ));
      result.add(TextSpan(
        text: '${word.substring(1)} ',
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ));
    }
    return result;
  }
}

class DayCheckbox extends StatefulWidget {
  final String dayOfTheWeek;

  const DayCheckbox({
    required this.dayOfTheWeek,
    Key? key,
  }) : super(key: key);

  @override
  _DayCheckboxState createState() => _DayCheckboxState();
}

class _DayCheckboxState extends State<DayCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isChecked
        ? Color.fromARGB(255, 230, 230, 230)
        : Color.fromARGB(255, 78, 78, 78);
    Color textColor = isChecked
        ? Color.fromARGB(255, 78, 78, 78)
        : Color.fromARGB(255, 230, 230, 230);

    return GestureDetector(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
        });
      },
      child: SizedBox(
        height: 55,
        width: 55,
        child: Tile(
          color: backgroundColor,
          child: Center(
            child: Text(
              widget.dayOfTheWeek,
              style: TextStyle(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
