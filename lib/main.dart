import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_2/pages/firstpage.dart';
import 'package:flutter_application_2/pages/task_page.dart';
import 'package:flutter_application_2/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/.env"); // Load api keys
  await SupabaseService.initialize(); // Initialize Supabase
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SupabaseClient>(create: (_) => SupabaseService().client),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "To-Do App",
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FirstPage(),
        routes: {
          '/firstpage': (context) => FirstPage(),
          '/taskpage': (context) => TaskPage(filter: 'All'),
        },
      ),
    );
  }
}
