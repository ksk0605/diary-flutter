import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'diary_service.dart';
import 'home_page.dart';

void main() {
  initializeDateFormatting().then(((_) => runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => DiaryService()),
          ],
          child: const MyApp(),
        ),
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
