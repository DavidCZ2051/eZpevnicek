import 'package:flutter/material.dart';
import 'package:zpevnicek/pages.dart';
import 'package:zpevnicek/logic.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadDownloaded();
  await loadSongs();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
      ),
      title: "Zpěvníček",
      home: const BackBone(),
    );
  }
}
