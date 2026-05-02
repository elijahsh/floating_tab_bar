import 'package:flutter/material.dart';
import 'package:floating_tab_bar/floating_tab_bar.dart';
import 'screens/screen1.dart';
import 'screens/screen2.dart';
import 'screens/screen3.dart';
import 'screens/screen4.dart';
import 'screens/screen5.dart';
import 'screens/screen6.dart';
import 'screens/screen7.dart';
import 'screens/screen8.dart';
import 'screens/screen9.dart';
import 'screens/screen10.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Floating Tab Bar Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        extensions: const [
          FloatingTabBarThemeData(),
        ],
      ),
      home: const MainMenu(),
      routes: {
        '/screen1': (context) => const Screen1(),
        '/screen2': (context) => const Screen2(),
        '/screen3': (context) => const Screen3(),
        '/screen4': (context) => const Screen4(),
        '/screen5': (context) => const Screen5(),
        '/screen6': (context) => const Screen6(),
        '/screen7': (context) => const Screen7(),
        '/screen8': (context) => const Screen8(),
        '/screen9': (context) => const Screen9(),
        '/screen10': (context) => const Screen10(),
      },
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Floating Tab Bar Demo'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Accessory example'),
            subtitle: const Text('Basic Items'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => Navigator.pushNamed(context, '/screen1'),
          ),
          ListTile(
            title: const Text('Simple with action'),
            subtitle: const Text('Fruits'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => Navigator.pushNamed(context, '/screen2'),
          ),
          ListTile(
            title: const Text('Tab bar with search bar'),
            subtitle: const Text('Flutter & Dart'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => Navigator.pushNamed(context, '/screen3'),
          ),
          ListTile(
            title: const Text('Tab bar with action button'),
            subtitle: const Text('African Animals'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => Navigator.pushNamed(context, '/screen4'),
          ),
          ListTile(
            title: const Text('Tab bar with Accessory segment'),
            subtitle: const Text('Programming Languages'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => Navigator.pushNamed(context, '/screen5'),
          ),
          ListTile(
            title: const Text('Options segment'),
            subtitle: const Text('World Cities'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => Navigator.pushNamed(context, '/screen6'),
          ),
          ListTile(
            title: const Text('Screen 7'),
            subtitle: const Text('Foods'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => Navigator.pushNamed(context, '/screen7'),
          ),
          ListTile(
            title: const Text('Screen 8'),
            subtitle: const Text('Social Media'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => Navigator.pushNamed(context, '/screen8'),
          ),
          ListTile(
            title: const Text('Screen 9'),
            subtitle: const Text('Adventure Sports'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => Navigator.pushNamed(context, '/screen9'),
          ),
          ListTile(
            title: const Text('Screen 10'),
            subtitle: const Text('Space & Astronomy'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => Navigator.pushNamed(context, '/screen10'),
          ),
        ],
      ),
    );
  }
}
