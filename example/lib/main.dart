import 'package:flutter/material.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';

void main() {
  Dialogs.init(
    alertDialogConfig: const AlertDialogConfig(
      positiveButtonTextStyle: TextStyle(
        color: Colors.orange,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      material: false,
    ),
    messageDialogConfig: const MessageDialogConfig(
      buttonTextStyle: TextStyle(
        color: Colors.orange,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      material: false,
    ),
    loadingDialogConfig: LoadingDialogConfig(
      loader: Center(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      material: false,
    ),
    snackBarConfig: const SnackBarConfig(
      messageStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    errorSnackBarConfig: SnackBarConfig(
      background: Colors.red.withOpacity(0.1),
      messageStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    warningSnackBarConfig: SnackBarConfig(
      background: Colors.orange.withOpacity(0.1),
      messageStyle: const TextStyle(
        color: Colors.orange,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
  );
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
                context.showLoader();
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.showSnackBar("This is a snack bar message!");
              },
              child: const Text("Show Snack Bar"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.showErrorSnackBar("This is a error snack bar message!");
              },
              child: const Text("Show Error Snack Bar"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.showWarningSnackBar(
                    "This is a warning snack bar message!");
              },
              child: const Text("Show Warning Snack Bar"),
            ),
          ],
        ),
      ),
    );
  }
}
