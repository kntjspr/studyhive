import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDate = DateTime.now();
  final List<Event> _events = [
    Event(
      title: "Math Study Group",
      date: DateTime.now().add(const Duration(days: 2)),
      color: Colors.blue,
    ),
    Event(
      title: "Biology Lab",
      date: DateTime.now().add(const Duration(days: 3)),
      color: Colors.green,
    ),
    Event(
      title: "History Presentation",
      date: DateTime.now(),
      color: Colors.orange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFCDD2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFAB91),
        elevation: 0,
        title: Text(
          "Calendar",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildCalendarHeader(),
          _buildCalendarGrid(),
          const SizedBox(height: 20),
          _buildEventsList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewEvent,
        backgroundColor: const Color(0xFFFFAB91),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFFFAB91).withOpacity(0.7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white),
            onPressed: () {
              setState(() {
                _selectedDate =
                    DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
              });
            },
          ),
          Text(
            "${_getMonthName(_selectedDate.month)} ${_selectedDate.year}",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.white),
            onPressed: () {
              setState(() {
                _selectedDate =
                    DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: 42, // 6 weeks * 7 days
        itemBuilder: (context, index) {
          final int firstDayOfMonth =
              DateTime(_selectedDate.year, _selectedDate.month, 1).weekday % 7;
          final int day = index - firstDayOfMonth + 1;
          final DateTime date =
              DateTime(_selectedDate.year, _selectedDate.month, day);

          final bool isCurrentMonth = date.month == _selectedDate.month;
          final bool isToday = date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day;

          final bool hasEvent = _events.any((event) =>
              event.date.year == date.year &&
              event.date.month == date.month &&
              event.date.day == date.day);

          return GestureDetector(
            onTap: () {
              if (isCurrentMonth) {
                setState(() {
                  _selectedDate = date;
                });
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: isToday
                    ? Colors.red[300]
                    : hasEvent
                        ? Colors.amber[100]
                        : isCurrentMonth
                            ? Colors.white
                            : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                border:
                    isToday ? Border.all(color: Colors.red, width: 2) : null,
              ),
              child: Center(
                child: Text(
                  isCurrentMonth ? day.toString() : "",
                  style: GoogleFonts.poppins(
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    color: isToday ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventsList() {
    final List<Event> todayEvents = _events
        .where((event) =>
            event.date.year == _selectedDate.year &&
            event.date.month == _selectedDate.month &&
            event.date.day == _selectedDate.day)
        .toList();

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Events for ${_selectedDate.day} ${_getMonthName(_selectedDate.month)}",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: todayEvents.isEmpty
                  ? Center(
                      child: Text(
                        "No events for today",
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: todayEvents.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: Container(
                              width: 12,
                              height: double.infinity,
                              color: todayEvents[index].color,
                            ),
                            title: Text(
                              todayEvents[index].title,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () {
                                setState(() {
                                  _events.remove(todayEvents[index]);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _addNewEvent() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Add New Event",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Enter event title",
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  _events.add(Event(
                    title: controller.text,
                    date: _selectedDate,
                    color: Colors
                        .primaries[_events.length % Colors.primaries.length],
                  ));
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFAB91),
            ),
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[month - 1];
  }
}

class Event {
  final String title;
  final DateTime date;
  final Color color;

  Event({required this.title, required this.date, required this.color});
}
