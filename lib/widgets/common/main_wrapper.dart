import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
class MainWrapper extends StatefulWidget {
  final Widget child;
  
  const MainWrapper({Key? key, required this.child}) : super(key: key);

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  void _updateIndex(String location) {
    setState(() {
      switch (location) {
        case '/':
          _currentIndex = 0;
          break;
        case '/catalog':
          _currentIndex = 1;
          break;
        case '/recipes':
          _currentIndex = 2;
          break;
        case '/timer':
          _currentIndex = 3;
          break;
        case '/settings':
          _currentIndex = 4;
          break;
        default:
          // For detail screens, don't change the index
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    _updateIndex(location);
    
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/catalog');
              break;
            case 2:
              context.go('/recipes');
              break;
            case 3:
              context.go('/timer');
              break;
            case 4:
              context.go('/settings');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.coffee_outlined),
            selectedIcon: Icon(Icons.coffee),
            label: 'Catalog',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Recipes',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: 'Timer',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

