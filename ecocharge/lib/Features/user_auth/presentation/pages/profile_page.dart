import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecocharge/Common/Toast.dart';
import 'package:ecocharge/Common/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = "";
  String email = "";
  String phoneNo = "";
  String fullname = "";

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //getting user info with _fetch method
    _fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: NetworkImage(
                      'https://www.clker.com/cliparts/Z/J/g/U/V/b/avatar-male-silhouette-md.png'),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 16.0),
                  //getting the value for username edittext
                  _buildEditableField("Username", usernameController, username),
                  SizedBox(height: 16.0),
                  _buildEditableField("Email", emailController, email),
                  SizedBox(height: 16.0),
                  _buildEditableField(
                      "Full Name", fullnameController, fullname),
                  SizedBox(height: 16.0),
                  _buildEditableField(
                      "Phone Number", phoneNoController, phoneNo),
                  SizedBox(height: 32.0),
                  ElevatedButton.icon(
                    onPressed: () {
                      _saveProfileChanges();
                    },
                    icon: Icon(Icons.published_with_changes),
                    label: Text('Save Changes'),
                  ),
                  const SizedBox(height: 8.0),
                  //creating buttons
                  _buildButton(
                      context, 'Settings and Security', Icons.settings),
                  const SizedBox(height: 8.0),
                  _buildButton(
                      context, 'Contact and Support', Icons.headset_mic),
                  const SizedBox(height: 8.0),
                  _buildButton(context, 'Sign Out', Icons.exit_to_app),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 2,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildEditableField(
      String label, TextEditingController controller, String initialValue) {
    controller.text = initialValue;
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  //getting user doc
  void _fetch() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      setState(() {
        username = userSnapshot.get('username');
        email = userSnapshot.get('email');
        fullname = userSnapshot.get('fullname');
        phoneNo = userSnapshot.get('phoneNo');

        usernameController.text = username;
        emailController.text = email;
        fullnameController.text = fullname;
        phoneNoController.text = phoneNo;
      });
    }
  }


  Future<void> _performSaveAction() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .update({
        'username': usernameController.text,
        'email': emailController.text,
        'fullname': fullnameController.text,
        'phoneNo': phoneNoController.text,
      });

      setState(() {
        username = usernameController.text;
        email = emailController.text;
        fullname = fullnameController.text;
        phoneNo = phoneNoController.text;
      });
    }

  }


  Future<void> _saveProfileChanges() async {
    // Show a confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Changes'),
          content: Text('Are you sure you want to save the changes?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                // perdom save if user clicks confirm
                await _performSaveAction();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
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

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    fullnameController.dispose();
    phoneNoController.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Navigate to different pages based on the selected index
      switch (_selectedIndex) {
        case 0:
          // Navigate to Home
          Navigator.pushNamed(context, "/home");
          break;
        case 1:
          // Navigate to Map
          Navigator.pushNamed(context, "/map");
          showToast(message: "Map screen loading");
          break;
        case 2:
          //profile is already selected do nothing
          break;
        default:
          break;
      }
    });
  }
}
