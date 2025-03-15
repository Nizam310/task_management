import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:task_management/provider/object_box_provider.dart';
import 'package:task_management/provider/task_provider.dart';
import 'package:task_management/pages/Home/home.dart';
import 'package:task_management/util/fire_store_sync_service/fire_store_sync_service.dart';
import 'package:task_management/util/local_db/object_box_main.dart';
import 'package:task_management/util/network_connection/connectivity.dart';

late ObjectBox objectBox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBN2YD5RJBrU0BOOyCBGN4RtegyCy7GK3w",
      appId: "1:986326817915:android:44cc82834b21c757fad6de",
      messagingSenderId: "986326817915",
      projectId: "task-manager-f6b4e",
    ),
  );

  objectBox = await ObjectBox.create();
  final objectBoxProvider = ObjectBoxProvider(objectBox.store);
  final firestoreSyncService = FireStoreSyncService(objectBox.taskBox);
  ConnectivityService(firestoreSyncService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => objectBoxProvider),
        ChangeNotifierProvider(create: (_) => TaskProvider(objectBoxProvider)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: OKToast(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(useMaterial3: false),
          home: const Home(),
        ),
      ),
    );
  }
}
