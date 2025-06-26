import 'package:flutter/material.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';

class DemoMessage extends StatelessWidget {
  final MessageDialogContent content;

  const DemoMessage({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.all(24),
          alignment: Alignment.center,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white,
          ),
          child: Center(child: Text(content.titleText ?? "Message")),
        ),
      ],
    );
  }
}

class DemoSnackBar extends StatelessWidget {
  final SnackBarContent content;

  const DemoSnackBar({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.all(24),
          alignment: Alignment.center,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white,
          ),
          child: Center(child: Text(content.titleText ?? "Error snack bar")),
        ),
      ],
    );
  }
}

void main() {
  Toast.alignment = Alignment(0, 0.7);
  Toast.duration = Duration(seconds: 5);
  Toast.builder = (context, msg, args) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red, width: 2),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(msg, style: TextStyle(color: Colors.white, fontSize: 16)),
          if (args != null)
            Text(
              args.toString(),
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
        ],
      ),
    );
  };
  Dialogs.init(
    alertDialogConfig: (context) {
      return AlertDialogConfig(
        builder: (context, content) {
          return Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
            ),
            child: Text(content.titleText ?? "Alert dialog"),
          );
        },
      );
    },
    messageDialogConfig: (context) {
      return MessageDialogConfig(
        builder: (context, content) {
          return DemoMessage(content: content);
        },
      );
    },
    configs: {
      "custom": (context) {
        return DialogConfig(
          duration: const Duration(seconds: 3),
          reverseDuration: const Duration(seconds: 3),
          builder: (context, content) {
            return Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            );
          },
        );
      },
    },
    snackBarConfig: (context) {
      return SnackBarConfig(
        builder: (context, content) {
          return DemoSnackBar(content: content);
        },
      );
    },
    errorSnackBarConfig: (context) {
      return SnackBarConfig(
        builder: (context, content) {
          return DemoSnackBar(content: content);
        },
      );
    },
    warningSnackBarConfig: (context) {
      return SnackBarConfig(
        builder: (context, content) {
          return DemoSnackBar(content: content);
        },
      );
    },
    infoSnackBarConfig: (context) {
      return SnackBarConfig(
        builder: (context, content) {
          return DemoSnackBar(content: content);
        },
      );
    },
    waitingSnackBarConfig: (context) {
      return SnackBarConfig(
        builder: (context, content) {
          return DemoSnackBar(content: content);
        },
      );
    },
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Toast.darkMode = Theme.of(context).brightness == Brightness.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    Toast.context = context;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Toast.show("Hello toast");
              },
              child: const Text("Show Toast"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Widget child = Container(
                  width: double.infinity,
                  height: 500,
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      context.dismiss();
                    },
                    child: const Text("Close"),
                  ),
                );
                AndrossyDialog.show(
                  context: context,
                  position: AndrossyDialogPosition.center,
                  builder: (context) => child,
                );
              },
              child: const Text("Show Custom Dialog"),
            ),
            const SizedBox(height: 24),
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
                  "This is a warning snack bar message!",
                );
              },
              child: const Text("Show Warning Snack Bar"),
            ),
          ],
        ),
      ),
    );
  }
}
