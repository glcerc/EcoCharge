import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.orangeAccent,
        textTheme: const TextTheme(
          bodyText2: TextStyle(fontSize: 18.0),
        ),
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundImage: const NetworkImage(
                          'https://www.clker.com/cliparts/Z/J/g/U/V/b/avatar-male-silhouette-md.png'),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  _buildInfoTile(context, 'Name', 'John Doe'),
                  _buildInfoTile(context, 'Username', 'johndoe123'),
                  _buildInfoTile(context, 'Email', 'john.doe@example.com'),
                  _buildInfoTile(context, 'Phone', '+1 (555) 123-4567'),
                  const SizedBox(height: 16.0),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Edit profile action
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  _buildButton(context, 'Settings and Security', Icons.settings),
                  const SizedBox(height: 24.0),
                  _buildButton(context, 'Contact and Support', Icons.headset_mic),
                  const SizedBox(height: 24.0),
                  _buildButton(context, 'Sign Out', Icons.exit_to_app),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, String title, String value) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText2!,
      ),
      subtitle: Text(
        value,
        style: Theme.of(context).textTheme.bodyText2!,
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {
        // Action for each button
      },
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
