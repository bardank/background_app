import 'dart:io';

import 'package:background_app/data/api/graphql_api_client.dart';
import 'package:background_app/data/modal/affirmation_modal.dart';
import 'package:background_app/data/modal/reminder_model.dart';
import 'package:background_app/notification_service.dart';
import 'package:background_app/schedule_config.dart';
import 'package:background_app/screens/reminder.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

import 'data/api/client_setup.dart';

Future<void> initializeHive() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await Hive.initFlutter('affirmDaily');
  } else {
    await Hive.initFlutter();
  }
  //20 is the hive adapter of ReminderModel
  if (!Hive.isAdapterRegistered(20)) {
    Hive.registerAdapter(ReminderModelAdapter());
    Hive.registerAdapter(TimeAdapter());

    Hive.registerAdapter(AffirmationAdapter());
  }
  await openHiveBox('user');
}

Future<void> openHiveBox(String boxName, {bool limit = false}) async {
  final box = await Hive.openBox(boxName).onError((error, stackTrace) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final String dirPath = dir.path;
    File dbFile = File('$dirPath/$boxName.hive');
    File lockFile = File('$dirPath/$boxName.lock');
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      dbFile = File('$dirPath/affirmDaily/$boxName.hive');
      lockFile = File('$dirPath/affirmDaily/$boxName.lock');
    }
    await dbFile.delete();
    await lockFile.delete();
    await Hive.openBox(boxName);
    throw 'Failed to open $boxName Box\nError: $error';
  });
  // clear box if it grows large
  if (limit && box.length > 500) {
    box.clear();
  }
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  setUpClient("");
  await initializeHive();
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    try {
      var status = await BackgroundFetch.configure(
          BackgroundFetchConfig(
              minimumFetchInterval: 15,
              forceAlarmManager: false,
              stopOnTerminate: false,
              startOnBoot: true,
              enableHeadless: true,
              requiresBatteryNotLow: false,
              requiresCharging: false,
              requiresStorageNotLow: false,
              requiresDeviceIdle: false,
              requiredNetworkType: NetworkType.ANY),
          onBackgroundFetch,
          _onBackgroundFetchTimeout);

      print('[BackgroundFetch] configure success: $status');

      BackgroundFetch.scheduleTask(TaskConfig(
          taskId: "com.transistorsoft.customtask",
          delay: 10000,
          periodic: false,
          forceAlarmManager: true,
          stopOnTerminate: false,
          enableHeadless: true));
    } on Exception catch (e) {
      print("[BackgroundFetch] configure ERROR: $e");
    }
  }

  void _onBackgroundFetchTimeout(String taskId) {
    print("[BackgroundFetch] TIMEOUT: $taskId");
    BackgroundFetch.finish(taskId);
  }

  @override
  Widget build(BuildContext context) {
    GraphQLApiClient client = Get.find<GraphQLApiClient>();
    return GraphQLProvider(
      client: client.graphQLClient,
      child: GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => ReminderScreen(),
        },
      ),
    );
  }
}
