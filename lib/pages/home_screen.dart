// home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_provider.dart';
import './screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          if (appProvider.isLoggedIn)
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                appProvider.logout();
                // Navigate to login screen
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
        ],
      ),
      body: Center(
        child: appProvider.isLoggedIn
            ? Text('Welcome, ${appProvider.userEmail}')
            : Text('Please log in'),
      ),
    );
  }
}
