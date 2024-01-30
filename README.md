## Features
* Alert message dialog
* Editable dialog
* Loading dialog
* Message dialog

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dialogs/dialogs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ValueNotifier<double> progress = ValueNotifier(0);

  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      progress.value = progress.value++;
      if (progress.value == 100) {
        timer.cancel();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                context.showAlert(
                  title: "This is a title!",
                  message: "This is a alert message",
                );
              },
              child: const Text("Show Alert Dialog"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.showEditor(
                  hint: "Write something...",
                  title: "This is a title!",
                  message: "This is a alert message",
                );
              },
              child: const Text("Show Editable Dialog"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.showLoading(progress: progress);
              },
              child: const Text("Show Loading Dialog"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.showMessage("This is a message");
              },
              child: const Text("Show Message Dialog"),
            ),
          ],
        ),
      ),
    );
  }
}
```
