import 'package:diary/diary_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  TextEditingController createTextController = TextEditingController();
  TextEditingController updateTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<DiaryService>(
      builder: (context, diaryService, child) {
        List<Diary> diaryList = diaryService.getByDate(_focusedDay);

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showCreateDialog(diaryService);
            },
            child: Icon(Icons.create),
            backgroundColor: Colors.indigo,
          ),
          body: SafeArea(
            child: Column(
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      // Call `setState()` when updating the selected day
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    }
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      // Call `setState()` when updating calendar format
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    // No need to call `setState()` here
                    _focusedDay = focusedDay;
                  },
                ),
                Divider(
                  color: Colors.grey,
                ),
                Expanded(
                  child: diaryList.isEmpty
                      ? Center(
                          child: Text(
                            "??? ??? ????????? ??????????????????.",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: diaryList.length,
                          itemBuilder: ((context, index) {
                            int i = diaryList.length - index - 1;
                            Diary diary = diaryList[i];
                            return ListTile(
                              title: Text(
                                diary.text,
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                ),
                              ),
                              trailing: Text(
                                DateFormat('kk:mm').format(diary.createdAt),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              onTap: (() {
                                showUpdateDialog(diaryService, diary);
                              }),
                              onLongPress: () {
                                showDeleteDialog(diaryService, diary);
                              },
                            );
                          }),
                        ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void createDiary(DiaryService diaryService) {
    // ?????? ?????? ??????
    String newText = createTextController.text.trim();
    if (newText.isNotEmpty) {
      diaryService.create(newText, _focusedDay);
      createTextController.text = "";
    }
  }

  void updateDiary(DiaryService diaryService, Diary diary) {
    // ?????? ?????? ??????
    String updatedText = updateTextController.text.trim();
    if (updatedText.isNotEmpty) {
      diaryService.update(
        diary.createdAt,
        updatedText,
      );
    }
  }

  /// ?????? ??????????????? ????????????
  void showCreateDialog(DiaryService diaryService) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("?????? ??????"),
          content: TextField(
            controller: createTextController,
            autofocus: true,
            // ?????? ??????
            cursorColor: Colors.indigo,
            decoration: InputDecoration(
              hintText: "??? ??? ????????? ??????????????????.",
              // ????????? ????????? ??? ?????? ??????
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.indigo),
              ),
            ),
            onSubmitted: (_) {
              // ?????? ?????? ??? ????????????
              createDiary(diaryService);
              Navigator.pop(context);
            },
          ),
          actions: [
            /// ?????? ??????
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "??????",
                style: TextStyle(color: Colors.indigo),
              ),
            ),

            /// ?????? ??????
            TextButton(
              onPressed: () {
                createDiary(diaryService);
                Navigator.pop(context);
              },
              child: Text(
                "??????",
                style: TextStyle(color: Colors.indigo),
              ),
            ),
          ],
        );
      },
    );
  }

  /// ?????? ??????????????? ????????????
  void showUpdateDialog(DiaryService diaryService, Diary diary) {
    showDialog(
      context: context,
      builder: (context) {
        updateTextController.text = diary.text;
        return AlertDialog(
          title: Text("?????? ??????"),
          content: TextField(
            autofocus: true,
            controller: updateTextController,
            // ?????? ??????
            cursorColor: Colors.indigo,
            decoration: InputDecoration(
              hintText: "??? ??? ????????? ????????? ?????????.",
              // ????????? ????????? ??? ?????? ??????
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.indigo),
              ),
            ),
            onSubmitted: (v) {
              // ?????? ?????? ??? ????????????
              updateDiary(diaryService, diary);
              Navigator.pop(context);
            },
          ),
          actions: [
            /// ?????? ??????
            TextButton(
              child: Text(
                "??????",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.indigo,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),

            /// ?????? ??????
            TextButton(
              child: Text(
                "??????",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.indigo,
                ),
              ),
              onPressed: () {
                // ????????????
                updateDiary(diaryService, diary);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  /// ?????? ??????????????? ????????????
  void showDeleteDialog(DiaryService diaryService, Diary diary) {
    showDialog(
      context: context,
      builder: (context) {
        updateTextController.text = diary.text;
        return AlertDialog(
          title: Text("?????? ??????"),
          content: Text('"${diary.text}"??? ?????????????????????????'),
          actions: [
            TextButton(
              child: Text(
                "??????",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.indigo,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),

            /// Delete
            TextButton(
              child: Text(
                "??????",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.indigo,
                ),
              ),
              onPressed: () {
                diaryService.delete(diary.createdAt);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
