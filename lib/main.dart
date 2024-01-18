import 'package:flutter/material.dart';
import 'package:moneymanager_app/pages/category_page.dart';
import 'package:moneymanager_app/pages/dashboard_page.dart';

void main() async {
  runApp(
    const NavigationBarApp()
  );
}

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true,
        colorScheme: const ColorScheme.dark().copyWith(
          background: const Color.fromARGB(255, 65, 44, 78)
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 242, 172, 191),
            foregroundColor: const Color.fromARGB(255, 70, 34, 85)
          ),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 2,
          shadowColor: Color.fromARGB(255, 242, 172, 191),
          backgroundColor: Color.fromARGB(255, 155, 159, 242),
          foregroundColor: Color.fromARGB(255, 255, 255, 255)
        ),
        cardTheme: const CardTheme(
          color: Color.fromARGB(255, 242, 126, 169)
        )),
      home: const NavigationApp(),
    );
  }
}

class NavigationApp extends StatefulWidget {
  const NavigationApp({super.key});

  @override
  State<NavigationApp> createState() => _NavigationAppState();
}

class _NavigationAppState extends State<NavigationApp> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        height: 60,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.dashboard),
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
        ],
      ),
      body: <Widget>[
        /// Dashboard
        const DashboardPage(),
        /// Home Page
        const CategoryPage(),
      ][currentPageIndex],
    );
  }
}
