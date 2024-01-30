import 'package:flutter/material.dart';
import 'package:flutter_app_dialogs/dialogs.dart';

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

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

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
                );
              },
              child: const Text("Show Editable Dialog"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.showLoading();
              },
              child: const Text("Show Loading Dialog"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.showMessage("This is a message", title: "Successful!");
              },
              child: const Text("Show Message Dialog"),
            ),
          ],
        ),
      ),
    );
  }
}
